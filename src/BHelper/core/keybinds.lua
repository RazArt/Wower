BHelper.keybinds = {}

local core = {}
local keybinds = {}
local timers = {}

local binds = {}
local base_frame = CreateFrame('Frame')

function BHelper.keybinds:namespace_init()
    core = BHelper.core
    keybinds = BHelper.keybinds
    timers = BHelper.timers
end

local function get_bind_index(group, name)
    for i = 1, #binds do if ((binds[i].group == group) and (binds[i].name == name)) then return i end end
    return 0
end

local function get_bind_string(key, modifier)
    if (modifier == 1) then return 'ALT-' .. key end
    if (modifier == 2) then return 'ALT-CTRL-' .. key end
    if (modifier == 3) then return 'ALT-SHIFT-' .. key end
    if (modifier == 4) then return 'CTRL-' .. key end
    if (modifier == 5) then return 'CTRL-SHIFT-' .. key end
    if (modifier == 6) then return 'SHIFT-' .. key end
end

local function bind(group, name, key)
    if (core:combat()) then
        timers:create(1, function()
            bind(group, name, key)
        end, 'bind')
        return false
    end

    name = ((name) and (type(name) == 'string')) and name:lower() or ''
    key = ((key) and (type(key) == 'string')) and key:upper() or false
    command = group .. ' ' .. name

    if (key) then return SetOverrideBinding(base_frame, true, key, command) end
    for i = 1, #binds do
        if ((binds[i].group == group) and (binds[i].name == name)) then return true end
        if (not binds[i].name) then
            SetOverrideBinding(base_frame, true, binds[i].bind_string, command)
            binds[i].group = group
            binds[i].name = name
            -- print(i, binds[i].bind_string, group .. ' ' .. name)
            return true
        end
    end
    keybinds:rebind()
    return false
end

local function place(group, name, slot)
    if (core:combat()) then
        timers:create(1, function()
            place(group, name, slot)
        end, 'place')
        return false
    end

    name = ((name) and (type(name) == 'string')) and name:lower() or ''
    slot = ((slot) and (type(slot) == 'number')) and slot or 0

    if (slot == 0) then return end

    if (group == 'macro') then PickupMacro(name) end
    if (group == 'spell') then PickupSpell(name) end
    if (group == 'item') then PickupItem(name) end
    PlaceAction(slot)
    ClearCursor()
end

local function show(num, r, g, b)
    base_frame.frame[num].texture:SetTexture((r or 0) / 255, (g or 0) / 255, (b or 0) / 255)
    base_frame.frame[num]:Show()

    timers:create(core:get_update_time(), function()
        base_frame.frame[num]:Hide()
    end, 'keybinds_hide_' .. num)
    return true
end

local function show_bind(num, group, name)
    if (GetCurrentKeyBoardFocus()) then return false end

    name = ((name) and (type(name) == 'string')) and name:lower() or ''
    local index = get_bind_index(group, name)

    if (index == 0) then return false end
    show(num, 44, binds[index].key, binds[index].modifier)
end

function BHelper.keybinds:rebind()
    ClearOverrideBindings(base_frame)
    for i = 1, #binds do
        binds[i].name = nil
        binds[i].group = nil
    end

    keybinds:bind_spells()
    keybinds:bind_macros()
    keybinds:bind_items()
end

function BHelper.keybinds:bind_spells()
    for _, spellbook in pairs({BOOKTYPE_SPELL, BOOKTYPE_PET}) do
        for i = 1, 255 do
            local name, rank = GetSpellName(i, spellbook)
            if (not name) then break end
            if rank == 'Расовая' then name = name .. '(Расовая)' end
            bind('spell', name)
        end
    end
end

function BHelper.keybinds:bind_spell(name, key)
    return bind('spell', name, key)
end

function BHelper.keybinds:bind_macros()
    for i = 54, 1, -1 do
        local name = GetMacroInfo(i)
        if (name) then bind('macro', name) end
    end
end

function BHelper.keybinds:bind_macro(name, key)
    return bind('macro', name, key)
end

function BHelper.keybinds:bind_items()
    for i = 1, 20 do
        local item = GetInventoryItemLink('player', i)
        if ((item) and (GetItemSpell(item))) then
            local name = GetItemInfo(item)
            bind('item', name)
        end
    end
    for bag = 0, 4 do
        for i = 1, GetContainerNumSlots(bag) do
            local item = GetContainerItemLink(bag, i)
            if ((item) and (GetItemSpell(item))) then
                local name = GetItemInfo(item)
                bind('item', name)
            end
        end
    end
end

function BHelper.keybinds:bind_item(name, key)
    return bind('item', name, key)
end

function BHelper.keybinds:place_spell(name, slot)
    return place('spell', name, slot)
end

function BHelper.keybinds:place_macro(name, slot)
    return place('macro', name, slot)
end

function BHelper.keybinds:place_item(name, slot)
    return place('item', name, slot)
end

function BHelper.keybinds:show_pet(can_attack)
    return show(1, 56, can_attack)
end

function BHelper.keybinds:show_click()
    return show(2, 56)
end

function BHelper.keybinds:show_spell(name)
    return show_bind(3, 'spell', name)
end

function BHelper.keybinds:show_macro(name)
    return show_bind(3, 'macro', name)
end

function BHelper.keybinds:show_item(name)
    return show_bind(3, 'item', name)
end

function BHelper.keybinds:show_attack(name)
    return show_bind(4, 'spell', name)
end

function BHelper.keybinds:show_help(name)
    return show_bind(5, 'spell', name)
end

local function init()
    local count = 1
    local keys = {
        ['B'] = 66,
        ['C'] = 67,
        ['F'] = 70,
        ['G'] = 71,
        ['H'] = 72,
        ['I'] = 73,
        ['J'] = 74,
        ['K'] = 75,
        ['L'] = 76,
        ['M'] = 77,
        ['N'] = 78,
        ['O'] = 79,
        ['P'] = 80,
        ['T'] = 84,
        ['U'] = 85,
        ['V'] = 86,
        ['X'] = 88,
        ['Y'] = 89,
        ['Z'] = 90,
        ['F1'] = 112,
        ['F2'] = 113,
        ['F3'] = 114,
        ['F4'] = 115,
        ['F5'] = 116,
        ['F6'] = 117,
        ['F7'] = 118,
        ['F8'] = 119,
        ['F9'] = 120,
        ['F10'] = 121,
        ['F11'] = 122,
        ['F12'] = 123,
        [';'] = 186,
        ['='] = 187,
        [','] = 188,
        ['-'] = 189,
        ['.'] = 190,
        ['/'] = 191,
        ['`'] = 192,
        ['['] = 219,
        ['\\'] = 220,
        [']'] = 221,
        ['\''] = 222
    }
    for key, code in pairs(keys) do
        for m = 1, 6 do
            binds[count] = {}
            binds[count].key = code
            binds[count].modifier = m
            binds[count].bind_string = get_bind_string(key, m)
            count = count + 1
        end
    end

    base_frame.width = 1
    base_frame:SetScale(0.71)
    base_frame:SetFrameStrata('tooltip')
    base_frame:SetPoint('topleft', UIParent, 0, 0)
    base_frame.texture = base_frame:CreateTexture(nil, 'tooltip')
    base_frame.texture:SetAllPoints(base_frame)
    base_frame.texture:SetTexture(31 / 255, 11 / 255, 12 / 255)
    base_frame.frame = {}

    for i = 1, 6 do
        base_frame.width = base_frame.width + 1
        base_frame:SetSize(base_frame.width, 1)

        base_frame.frame[i] = CreateFrame('Frame', nil, base_frame)
        base_frame.frame[i]:SetSize(1, 1)
        base_frame.frame[i]:SetPoint('topleft', base_frame, i, 0)
        base_frame.frame[i].texture = base_frame.frame[i]:CreateTexture(nil, 'tooltip')
        base_frame.frame[i].texture:SetAllPoints(base_frame.frame[i])
        base_frame.frame[i]:Hide()
    end
end
init()
