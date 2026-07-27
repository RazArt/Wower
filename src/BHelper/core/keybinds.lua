BHelper.keybinds = {}

function BHelper.keybinds:_bind(name, command, mouse_click)
    for key, bind in pairs(self._binds) do
        if ((bind.name == nil) or (bind.name == name)) then
            bind.name = name
            bind.mouse_click = mouse_click and 1 or 0
            SetBinding('ALT-CTRL-SHIFT-' .. key, command)
            break
        end
    end
end

function BHelper.keybinds:bind_spell(name, mouse_click)
    name = string.lower(name)
    command = 'spell ' .. name
    mouse_click = mouse_click or false

    self:_bind(name, command, mouse_click)
end

function BHelper.keybinds:bind_item(name)
    name = string.lower(name)
    command = 'item ' .. name

    self:_bind(name, command, false)
end

function BHelper.keybinds:bind_macro(name)
    name = string.lower(name)
    command = 'macro ' .. name

    self:_bind(name, command, false)
end

function BHelper.keybinds:unbind(name)
    name = string.lower(name)

    for key, bind in pairs(self._binds) do
        if (bind.name == name) then
            bind.name = nil
            bind.mouse_click = nil
            SetBinding('ALT-CTRL-SHIFT-' .. key)
            break
        end
    end
end

function BHelper.keybinds:unbind_all()
    for key, bind in pairs(self._binds) do
        bind.name = nil
        bind.mouse_click = nil
        SetBinding('ALT-CTRL-SHIFT-' .. key)
    end
end

function BHelper.keybinds:_show(num, name)
    if (ACTIVE_CHAT_EDIT_BOX ~= nil) then return end

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

            break
        end
    end

    BHelper.print('Заклинание <', name, '>не найдено')
end

function BHelper.keybinds:show_spell(name)
    self:_show(1, name)
end

function BHelper.keybinds:show_attack(name)
    self:_show(2, name)
end

function BHelper.keybinds:show_help(name)
    self:_show(3, name)
end

function BHelper.keybinds:init()
    self._binds = {}

    local keys = {
        '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I',
        'O', 'P'
    }
    for _, key in ipairs(keys) do self._binds[key] = {} end

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
