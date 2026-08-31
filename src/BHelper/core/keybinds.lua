BHelper.keybinds = {}

function BHelper.keybinds:_get_bind_key(class, name)
    class = string.lower(class)
    name = string.lower(name)
    for key, bind in pairs(self._binds) do
        if ((bind.class == class) and (bind.name == name)) then return key end
    end
    return false
end

function BHelper.keybinds:_bind(class, name, mouse_click)
    class = string.lower(class)
    name = string.lower(name)
    mouse_click = mouse_click or false
    for key, bind in pairs(self._binds) do
        if ((bind.class == class) and (bind.name == name)) then return key end
        if (bind.name == nil) then
            if (SetBinding('ALT-CTRL-' .. key, class .. ' ' .. name)) then
                bind.name = name
                bind.class = class
                bind.mouse_click = not mouse_click and 0 or 1
                return key
            end
        end
    end
    return false
end

function BHelper.keybinds:bind_macro(name, mouse_click)
    return self:_bind('macro', name, mouse_click)
end

function BHelper.keybinds:bind_spell(name, mouse_click)
    return self:_bind('spell', name, mouse_click)
end

function BHelper.keybinds:bind_item(name, mouse_click)
    return self:_bind('item', name, mouse_click)
end

function BHelper.keybinds:unbind_all()
    local result = true
    for key, bind in pairs(self._binds) do
        bind.name = nil
        bind.class = nil
        bind.mouse_click = nil
        if (SetBinding('ALT-CTRL-' .. key) == nil) then result = false end
    end
    return result
end

function BHelper.keybinds:_show(num, class, name, time_count)
    time_count = time_count or 0.05
    if (ACTIVE_CHAT_EDIT_BOX) then return false end

    local key = self:_get_bind_key(class, name)
    if (not key) then return false end
    local flag = 44 / 255
    local mouse_click = self._binds[key].mouse_click / 255
    key = string.byte(key, 1) / 255

    self._frames.frame[num].texture:SetTexture(flag, key, mouse_click)
    self._frames.frame[num]:Show()

    BHelper.timers:create(time_count, function()
        self._frames.frame[num]:Hide()
    end, 'keybinds_hide_' .. num)
    return true
end

function BHelper.keybinds:show_macro(name, time_count)
    return self:_show(1, 'macro', name, time_count)
end

function BHelper.keybinds:show_spell(name, time_count)
    return self:_show(1, 'spell', name, time_count)
end

function BHelper.keybinds:show_item(name, time_count)
    return self:_show(1, 'item', name, time_count)
end

function BHelper.keybinds:show_attack(name, time_count)
    return self:_show(2, 'spell', name, time_count)
end

function BHelper.keybinds:show_help(name, time_count)
    return self:_show(3, 'spell', name, time_count)
end

function BHelper.keybinds:init()
    self._binds = {}

    for _, key in ipairs({
        '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'T', 'Y', 'U', 'I', 'O', 'P', 'H', 'J',
        'K', 'L', 'X', 'C', 'V', 'B', 'N', 'M'
    }) do self._binds[key] = {} end
    self:unbind_all()

    self._frames = CreateFrame('Frame')
    self._frames:SetScale(0.71)
    self._frames:SetSize(4, 1)
    self._frames:SetFrameStrata('tooltip')
    self._frames:SetPoint('topleft', UIParent, 0, 0)
    self._frames.texture = self._frames:CreateTexture(nil, 'tooltip')
    self._frames.texture:SetAllPoints(self._frames)
    self._frames.texture:SetTexture(31 / 255, 11 / 255, 12 / 255)
    self._frames.frame = {}
    for i = 1, 3 do
        self._frames.frame[i] = CreateFrame('Frame', nil, self._frames)
        self._frames.frame[i]:SetSize(1, 1)
        self._frames.frame[i]:SetPoint('topleft', self._frames, i, 0)
        self._frames.frame[i].texture = self._frames.frame[i]:CreateTexture(nil, 'tooltip')
        self._frames.frame[i].texture:SetAllPoints(self._frames.frame[i])
        self._frames.frame[i]:Hide()
    end
end
BHelper.keybinds:init()
