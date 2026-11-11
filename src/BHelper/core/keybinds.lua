BHelper.keybinds = {}

local core = {}
local keybinds = {}
local timers = {}

local binds = {}
local base = {}

function BHelper.keybinds:namespace_init()
    core = BHelper.core
    keybinds = BHelper.keybinds
    timers = BHelper.timers
end

local function get_bind_index(class, name)
    class = class:lower()
    name = name:lower()

    for num, bind in pairs(binds) do if ((bind.class == class) and (bind.name == name)) then return num end end
    return 0
end

local function get_bind_string(key, modifier)
    if (modifier == 1) then return 'ALT-' .. key end
    if (modifier == 2) then return 'ALT-CTRL-' .. key end
    if (modifier == 3) then return 'ALT-SHIFT-' .. key end
    if (modifier == 4) then return 'CTRL-' .. key end
    if (modifier == 5) then return 'CTRL-SHIFT-' .. key end
    if (modifier == 6) then return 'SHIFT-' .. key end
    if (modifier == 7) then return 'ALT-CTRL-SHIFT-' .. key end
end

local function put(class, name, slot)
    name = ((name) and (type(name) == 'string')) and name:lower() or ''
    slot = ((slot) and (type(slot) == 'number')) and slot or 0

    if (slot == 0) then return end

    if (class == 'macro') then PickupMacro(name) end
    if (class == 'spell') then PickupSpell(name) end
    if (class == 'item') then PickupItem(name) end
    PlaceAction(slot)
    ClearCursor()
end

local function bind(class, name, key)
    name = ((name) and (type(name) == 'string')) and name:lower() or ''
    key = ((key) and (type(key) == 'string')) and key:upper() or false

    if (key) then SetBinding(key, class .. ' ' .. name) end

    for index, bind in pairs(binds) do
        if ((bind.class == class) and (bind.name == name)) then return true end
        if (not bind.name) then
            if (SetBinding(bind.bind_string, class .. ' ' .. name)) then
                -- print('!!!!!!!!!!', class, name, key)
                bind.name = name
                bind.class = class
                return true
            else
                -- print(class, name, key)
            end
            return false
        end
    end

    return false
end

local function show(num, r, g, b)
    r = r or 0
    g = g or 0
    b = b or 0

    base.frame[num].texture:SetTexture(r / 255, g / 255, b / 255)
    base.frame[num]:Show()

    timers:create(core:get_update_time(), function()
        base.frame[num]:Hide()
    end, 'keybinds_hide_' .. num)
    return true
end

local function show_bind(num, class, name)
    if (GetCurrentKeyBoardFocus()) then return false end

    local flag = 0
    local info = 0
    local modifier = 0

    flag = 44
    local index = get_bind_index(class, name)
    if (index == 0) then return false end

    info = binds[index].key
    modifier = binds[index].modifier

    show(num, flag, info, modifier)
end

function BHelper.keybinds:bind_spell(name, key)
    return bind('spell', name, key)
end

local spellbooks = {BOOKTYPE_SPELL, BOOKTYPE_PET}
function BHelper.keybinds:bind_spells()
    local spells = {}

    for _, spellbook in pairs(spellbooks) do
        for i = 1, 255 do
            local name = GetSpellName(i, spellbook)
            if (not name) then break end
            spells[name] = true
        end
    end
    for name, _ in pairs(spells) do bind('spell', name) end
end

function BHelper.keybinds:bind_macro(name, key)
    return bind('macro', name, key)
end

function BHelper.keybinds:bind_item(name, key)
    return bind('item', name, key)
end

function BHelper.keybinds:place_spell(name, slot)
    return put('spell', name, slot)
end

function BHelper.keybinds:place_macro(name, slot)
    return put('macro', name, slot)
end

function BHelper.keybinds:place_item(name, slot)
    return put('item', name, slot)
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

function BHelper.keybinds:unbind_all()
    for i = 1, #binds do
        binds[i].name = nil
        binds[i].class = nil
        SetBinding(binds[i].bind_string)
    end
end

local function init()
    binds = {}

    local keys = {
        '7', '8', '9', '0', 'Q', 'E', 'R', 'F', 'T', 'Y', 'U', 'I', 'O', 'P', 'G', 'H', 'J', 'K', 'L', 'Z', 'X', 'C',
        'V', 'B', 'N', 'M'
    }

    local count = 1
    for i = 1, #keys do
        for m = 1, 7 do
            binds[count] = {}
            binds[count].key = string.byte(keys[i], 1)
            binds[count].modifier = m
            binds[count].bind_string = get_bind_string(keys[i], m)
            count = count + 1
        end
    end

    base = CreateFrame('Frame')
    base.width = 1
    base:SetScale(0.71)
    base:SetFrameStrata('tooltip')
    base:SetPoint('topleft', UIParent, 0, 0)
    base.texture = base:CreateTexture(nil, 'tooltip')
    base.texture:SetAllPoints(base)
    base.texture:SetTexture(31 / 255, 11 / 255, 12 / 255)
    base.frame = {}

    for i = 1, 6 do
        base.width = base.width + 1
        base:SetSize(base.width, 1)

        base.frame[i] = CreateFrame('Frame', nil, base)
        base.frame[i]:SetSize(1, 1)
        base.frame[i]:SetPoint('topleft', base, i, 0)
        base.frame[i].texture = base.frame[i]:CreateTexture(nil, 'tooltip')
        base.frame[i].texture:SetAllPoints(base.frame[i])
        base.frame[i]:Hide()
    end
end
init()
