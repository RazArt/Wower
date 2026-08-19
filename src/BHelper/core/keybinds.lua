BHelper.keybinds = {}

function BHelper.keybinds:_bind_exist(class, name)
    for key, bind in pairs(self._binds) do
        if ((bind.class == class) and (bind.name == name)) then return key end
    end
end

function BHelper.keybinds:_bind(class, name, mouse_click)
    name = string.lower(name)
    class = string.lower(class)
    mouse_click = mouse_click or false

    for key, bind in pairs(self._binds) do
        if ((bind.name == nil) or ((bind.name == name) and (bind.class == class))) then
            if (SetBinding('ALT-CTRL-SHIFT-' .. key, command)) then
                bind.name = name
                bind.class = class
                bind.mouse_click = not mouse_click and 0 or 1
                return true
            end
        end
    end
    return false
end

-- function BHelper.keybinds:_bind_macro(name, mouse_click)
--     -- name = BHelper.macros:get_formatted_name(name)
--     if (self:_bind(name, 'macro ' .. name, mouse_click)) then
--         return true
--     else
--         return false
--     end
-- end

-- function BHelper.keybinds:_bind_spell(name, mouse_click)
--     if (self:_bind(name, 'spell ' .. name, mouse_click)) then
--         return true
--     else
--         return false
--     end
-- end

-- function BHelper.keybinds:_bind_item(name, mouse_click)
--     if (self:_bind(name, 'item ' .. name, mouse_click)) then
--         return true
--     else
--         return false
--     end
-- end

function BHelper.keybinds:unbind_all()
    local result = true
    for key, bind in pairs(self._binds) do
        bind.name = nil
        bind.mouse_click = nil
        if (SetBinding('ALT-CTRL-SHIFT-' .. key) == nil) then result = false end
    end
    return result
end

function BHelper.keybinds:_show(num, name)
    if (ACTIVE_CHAT_EDIT_BOX) then return false end

    name = string.lower(name)
    for key, bind in pairs(self._binds) do
        if (bind.name == name) then
            local flag = 44 / 255
            local key = string.byte(key, 1) / 255
            local mouse_click = bind.mouse_click / 255
            self._frames.frame[num].texture:SetTexture(flag, key, mouse_click)
            self._frames.frame[num]:Show()
            BHelper.timers:create(0.05, function()
                self._frames.frame[num]:Hide()
            end, 'keybinds_hide_' .. num)
            return true
        end
    end
    return false
end

function BHelper.keybinds:show_macro(name)
    name = BHelper.macros:get_formatted_name(name)
    if (self:_show(1, BHelper.macros:get_formatted_name(name))) then
        return true
    else
        return false
    end
end

function BHelper.keybinds:show_spell(name)
    if (self:_show(1, name)) then
        return true
    else
        return false
    end
end

function BHelper.keybinds:show_item(name)
    if (self:_show(1, name)) then
        return true
    else
        return false
    end
end

function BHelper.keybinds:show_attack(name)
    if (self:_show(2, name)) then
        return true
    else
        return false
    end
end

function BHelper.keybinds:show_help(name)
    if (self:_show(3, name)) then
        return true
    else
        return false
    end
end

function BHelper.keybinds:init()
    self._binds = {}

    for _, key in ipairs({
        '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'T', 'Y', 'U', 'I', 'O', 'P', 'H', 'J',
        'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M'
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
