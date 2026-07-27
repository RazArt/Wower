BHelper = {}

BHelper._event_frame = CreateFrame('Frame')
BHelper._event_frame:SetScript('OnEvent', function(_, event, ...)
    BHelper[event](BHelper, ...)
end)
BHelper._event_frame:RegisterEvent('PLAYER_LOGIN')

function BHelper:PLAYER_LOGIN()
    setmetatable(BHelper, {__index = BHelper.common})

    self._debug = true
    self._runing = false

    BHelper:create_state_frame()

    self:set_module(self:get_player_class())

    CreateFrame('Frame'):SetScript('OnUpdate', function(_, elapsed)
        self.timers:update(elapsed)
        if ((self.modules[self._module] ~= nil) and (self._runing) and (not self._cooldown)) then
            self.modules[self._module]:_update()
        end
    end)
end

function BHelper:create_state_frame()
    self.state_frame = CreateFrame('Frame')
    self.state_frame:SetSize(50, 50)
    self.state_frame:SetFrameStrata('tooltip')
    self.state_frame:SetPoint('center', UIParent, 'center', 0, -160)
    self.state_frame.texture = self.state_frame:CreateTexture(nil, 'tooltip')
    self.state_frame.texture:SetAllPoints(self.state_frame)
    self.state_frame.texture:SetTexture('Interface\\AddOns\\BHelper\\textures\\warning.tga')
    self.state_frame:Hide()
end

function BHelper:set_module(module)
    if ((self.modules[module] ~= nil) and (self.modules[module] ~= self._module)) then
        self:print('set_module <', module, '>')
        self._module = module
        self.modules[module]:_init()
    end
end

function BHelper:set_action(action)
    if ((self.modules[self._module] ~= nil) and (self.modules[self._module][action] ~= nil) and
        (self.modules[self._module]._action ~= action)) then
        self:print('set_action <', action, '>')
        self.modules[self._module]._action = action
    end
end

function BHelper:set_var(var, value)
    if ((self.modules[self._module] ~= nil) and (self.modules[self._module].vars[var] ~= nil)) then
        self.modules[self._module].vars[var] = value
    end
end

function BHelper:toggle_var(var)
    if ((self.modules[self._module] ~= nil) and (self.modules[self._module].vars[var] ~= nil)) then
        if (self.modules[self._module].vars[var]) then
            self:print('var_toggle <', var, '>', false)
            self.modules[self._module].vars[var] = false
        else
            self:print('var_toggle <', var, '>', true)
            self.modules[self._module].vars[var] = true
        end
    end
end

function BHelper:toggle()
    if (self._runing) then
        self:stop()
    else
        self:start()
    end
end

function BHelper:start()
    self:print('start')
    self._runing = true
    self.state_frame:Show()
end

function BHelper:stop()
    self:print('stop')
    self._runing = false
    self.state_frame:Hide()
end

function BHelper:print(...)
    if (self._debug) then print('\124cffff00ffBHelper\124r', '->', ...) end
end

function BHelper:cooldown(count)
    self:print('cooldown <', count, '>')
    self._cooldown = true
    self.timers:create(count, function()
        self:print('cooldown < off >')
        self._cooldown = false
    end, 'cooldown')
end

function BHelper:commands(msg)
    msg = msg .. '\n'
    local args = {}

    for arg in string.gmatch(msg, '([^%s]+)') do table.insert(args, arg) end

    if ((args[1] == 'toggle') or (#args == 0)) then
        self:toggle()
    elseif (args[1] == 'start') then
        self:start()
    elseif (args[1] == 'stop') then
        self:stop()
    elseif (args[1] == 'tv') then
        self:toggle_var(args[2])
    elseif (args[1] == 'sv') then
        self:set_var(args[2], args[3])
    elseif (args[1] == 'sm') then
        self:set_module(args[2])
    elseif (args[1] == 'sa') then
        self:set_action(args[2])
    elseif (args[1] == 'm') then
        self.modules[self._module]:_macros()
    elseif (args[1] == 'c') then
        self:cooldown(tonumber(args[2]))
    else
        self:print('Неизвестная команда')
    end
end

SLASH_BHELPER1, SLASH_BHELPER2 = '/bhelper', '/bh'
SlashCmdList["BHELPER"] = function(message)
    BHelper:commands(message)
end
