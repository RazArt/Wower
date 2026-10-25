BHelper.keybinds = {}

local core = {}
local keybinds = {}
local timers = {}

function BHelper.keybinds:namespace_init()
    core = BHelper.core
    keybinds = BHelper.keybinds
    timers = BHelper.timers
end

function BHelper.keybinds:_get_bind_index(class, name)
    class = class:lower()
    name = name:lower()

    for num, bind in pairs(keybinds._binds) do if ((bind.class == class) and (bind.name == name)) then return num end end
    return 0
end

function BHelper.keybinds:_get_bind_string(key, modifier)
    if (modifier == 1) then return 'ALT-' .. key end
    if (modifier == 2) then return 'CTRL-' .. key end
    if (modifier == 3) then return 'ALT-CTRL-' .. key end
    return ''
end

function BHelper.keybinds:_bind(class, name)
    class = class:lower()
    name = name:lower()

    for index, bind in pairs(keybinds._binds) do
        if ((bind.class == class) and (bind.name == name)) then return true end
        if (not bind.name) then
            if (SetBinding(bind.bind_string, class .. ' ' .. name)) then
                bind.name = name
                bind.class = class
                return true
            end
            return false
        end
    end
    return false
end

function BHelper.keybinds:bind_macro(name, key)
    if (key) then
        if (SetBinding(key, 'macro ' .. name)) then return true end
        return false
    else
        return keybinds:_bind('macro', name)
    end
end

function BHelper.keybinds:bind_spell(name, key)
    if (key) then
        if (SetBinding(key, 'spell ' .. name)) then return true end
        return false
    else
        return keybinds:_bind('spell', name)
    end
end

function BHelper.keybinds:bind_item(name, key)
    if (key) then
        if (SetBinding(key, 'item ' .. name)) then return true end
        return false
    else
        return keybinds:_bind('item', name)
    end
end

function BHelper.keybinds:unbind_all()
    local result = true
    for _, bind in pairs(keybinds._binds) do
        bind.name = nil
        bind.class = nil
        if (not SetBinding(bind.bind_string)) then result = false end
    end
    return result
end

function BHelper.keybinds:_show(num, class, name, time_count)
    time_count = time_count or core:get_update_time()
    if (ACTIVE_CHAT_EDIT_BOX) then return false end

    local flag = 0
    local info = 0
    local modifier = 0

    if (num > 1) then
        flag = 44 / 255
        local index = keybinds:_get_bind_index(class, name)
        if (index == 0) then return false end
        info = keybinds._binds[index].key
        modifier = keybinds._binds[index].modifier
    else
        flag = 56 / 255
        info = 1 / 255
    end

    keybinds._frames.frame[num].texture:SetTexture(flag, info, modifier)
    keybinds._frames.frame[num]:Show()

    timers:create(time_count, function()
        keybinds._frames.frame[num]:Hide()
    end, 'keybinds_hide_' .. num)
    return true
end

function BHelper.keybinds:show_click()
    return keybinds:_show(1)
end

function BHelper.keybinds:show_macro(name, time_count)
    return keybinds:_show(2, 'macro', name, time_count)
end

function BHelper.keybinds:show_spell(name, time_count)
    return keybinds:_show(2, 'spell', name, time_count)
end

function BHelper.keybinds:show_item(name, time_count)
    return keybinds:_show(2, 'item', name, time_count)
end

function BHelper.keybinds:show_attack(name, time_count)
    return keybinds:_show(3, 'spell', name, time_count)
end

function BHelper.keybinds:show_help(name, time_count)
    return keybinds:_show(4, 'spell', name, time_count)
end

function BHelper.keybinds:show_pet(name, time_count)
    return keybinds:_show(5, 'macro', 'pet' .. name, time_count)
end

function BHelper.keybinds:init()
    self._binds = {}

    local binds = {
        {'T', 1}, {'Y', 1}, {'U', 1}, {'I', 1}, {'O', 1}, {'P', 1}, {'H', 1}, {'G', 1}, {'J', 1}, {'K', 1}, {'L', 1},
        {'Z', 1}, {'X', 1}, {'C', 1}, {'V', 1}, {'B', 1}, {'N', 1}, {'M', 1}, {'T', 2}, {'Y', 2}, {'U', 2}, {'I', 2},
        {'O', 2}, {'P', 2}, {'H', 2}, {'G', 2}, {'J', 2}, {'K', 2}, {'L', 2}, {'Z', 2}, {'X', 2}, {'C', 2}, {'V', 2},
        {'B', 2}, {'N', 2}, {'M', 2}, {'1', 3}, {'2', 3}, {'3', 3}, {'4', 3}, {'5', 3}, {'6', 3}, {'7', 3}, {'8', 3},
        {'9', 3}, {'0', 3}, {'T', 3}, {'Y', 3}, {'U', 3}, {'I', 3}, {'O', 3}, {'P', 3}, {'H', 3}, {'G', 3}, {'J', 3},
        {'K', 3}, {'L', 3}, {'Z', 3}, {'X', 3}, {'C', 3}, {'V', 3}, {'B', 3}, {'N', 3}, {'M', 3}
    }

    for i = 1, #binds do
        self._binds[i] = {}
        self._binds[i].key = string.byte(binds[i][1], 1) / 255
        self._binds[i].modifier = binds[i][2] / 255
        self._binds[i].bind_string = self:_get_bind_string(binds[i][1], binds[i][2])
    end

    self._frames = CreateFrame('Frame')
    self._frames:SetScale(0.71)
    self._frames:SetSize(6, 1)
    self._frames:SetFrameStrata('tooltip')
    self._frames:SetPoint('topleft', UIParent, 0, 0)
    self._frames.texture = self._frames:CreateTexture(nil, 'tooltip')
    self._frames.texture:SetAllPoints(self._frames)
    self._frames.texture:SetTexture(31 / 255, 11 / 255, 12 / 255)
    self._frames.frame = {}
    for i = 1, 5 do
        self._frames.frame[i] = CreateFrame('Frame', nil, self._frames)
        self._frames.frame[i]:SetSize(1, 1)
        self._frames.frame[i]:SetPoint('topleft', self._frames, i, 0)
        self._frames.frame[i].texture = self._frames.frame[i]:CreateTexture(nil, 'tooltip')
        self._frames.frame[i].texture:SetAllPoints(self._frames.frame[i])
        self._frames.frame[i]:Hide()
    end
end
BHelper.keybinds:init()
