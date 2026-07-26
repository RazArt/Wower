BHelper.keybinds = {}

function BHelper.keybinds:init()
    self._binds = {}

    self._binds[2] = {key = '1'}
    self._binds[3] = {key = '2'}
    self._binds[4] = {key = '3'}
    self._binds[5] = {key = '4'}
    self._binds[6] = {key = '5'}
    self._binds[7] = {key = '6'}
    self._binds[8] = {key = '7'}
    self._binds[9] = {key = '8'}
    self._binds[10] = {key = '9'}
    self._binds[11] = {key = '0'}
    self._binds[16] = {key = 'Q'}
    self._binds[17] = {key = 'W'}
    self._binds[18] = {key = 'E'}
    self._binds[19] = {key = 'R'}
    self._binds[20] = {key = 'T'}
    self._binds[21] = {key = 'Y'}
    self._binds[22] = {key = 'U'}
    self._binds[23] = {key = 'I'}
    self._binds[24] = {key = 'O'}
    self._binds[25] = {key = 'P'}

    self:unbind_all()

    self._base_frame = CreateFrame('Frame')
    self._base_frame:SetScale(0.71)
    self._base_frame:SetSize(3, 1)
    self._base_frame:SetFrameStrata('tooltip')
    self._base_frame:SetPoint('topleft', UIParent, 0, 0)
    self._base_frame.frames = {}
    for i = 1, 3 do
        self._base_frame.frames[i] = CreateFrame('Frame', nil, self._base_frame)
        local frame = self._base_frame.frames[i]
        frame:SetSize(1, 1)
        frame:SetPoint('topleft', self._base_frame, i - 1, 0)
        frame.texture = frame:CreateTexture(nil, 'tooltip')
        frame.texture:SetAllPoints(frame)
        frame:Hide()
    end
end

function BHelper.keybinds:bind(name, command, mouse_click)
    name = string.lower(name)
    mouse_click = mouse_click or false

    for _, bind in pairs(self._binds) do
        if ((bind.name == nil) or (bind.name == name)) then
            bind.name = name
            bind.mouse_click = mouse_click and 1 or 0
            SetBinding('ALT-CTRL-SHIFT-' .. bind.key, command)
            break
        end
    end
end

function BHelper.keybinds:unbind(name)
    name = string.lower(name)

    for _, bind in pairs(self._binds) do
        if (bind.name == name) then
            bind.name = nil
            bind.mouse_click = nil
            SetBinding('ALT-CTRL-SHIFT-' .. bind.key)
            break
        end
    end
end

function BHelper.keybinds:unbind_all()
    for _, bind in pairs(self._binds) do
        bind.name = nil
        bind.mouse_click = nil
        SetBinding('ALT-CTRL-SHIFT-' .. bind.key)
    end
end

function BHelper.keybinds:_show(num, name)
    if (ACTIVE_CHAT_EDIT_BOX ~= nil) then return end

    name = string.lower(name)

    for scan_code, bind in pairs(self._binds) do
        if (bind.name == name) then
            local frame = self._base_frame.frames[num]
            frame.texture:SetTexture(44 / 255, scan_code / 255, bind.mouse_click / 255)
            frame:Show()

            -- BHelper.timers:create(0.05, function()
            --     self._base_frame.blocks[num]:Hide()
            -- end, 'hide_' .. num)
        end
    end
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
