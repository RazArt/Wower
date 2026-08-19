BHelper = {}

BHelper._event_frame = CreateFrame('Frame')
BHelper._event_frame:SetScript('OnEvent', function(_, event, ...)
    BHelper[event](BHelper, ...)
end)
BHelper._event_frame:RegisterEvent('PLAYER_LOGIN')
BHelper._event_frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
BHelper._event_frame:RegisterEvent('PLAYER_REGEN_DISABLED')
BHelper._event_frame:RegisterEvent('PLAYER_REGEN_ENABLED')
BHelper._event_frame:RegisterEvent('UI_ERROR_MESSAGE')
BHelper._event_frame:RegisterEvent('PLAYER_CONTROL_LOST')
BHelper._event_frame:RegisterEvent('PLAYER_CONTROL_GAINED')

function BHelper:PLAYER_LOGIN()
    self.vars.player_name = self:get_player_name()
    self.DB:init()
    self:create_state_frame()
    self:reload()

    CreateFrame('Frame'):SetScript('OnUpdate', function(_, elapsed)
        self.timers:update(elapsed)
        local module = self:get_module()
        if ((module) and (self._runing) and (not self._cooldown)) then module:_update() end
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

function BHelper:ACTIVE_TALENT_GROUP_CHANGED()
    self.timers:create(1, function()
        self:reload()
    end)
end

function BHelper:PLAYER_REGEN_DISABLED()
    self.vars._combat_state = true
    self:start()
end

function BHelper:PLAYER_REGEN_ENABLED()
    self.vars._combat_state = false
    self:stop()
end

function BHelper:UI_ERROR_MESSAGE(message)
    if (message == SPELL_FAILED_NOT_BEHIND) then
        self.vars.behind_of_target = false
        self.timers:create(0.5, function()
            self.vars.behind_of_target = true
        end, 'behind_of_target')
    end
end

function BHelper:PLAYER_CONTROL_LOST()
    self._cooldown = true
end

function BHelper:PLAYER_CONTROL_GAINED()
    self._cooldown = false
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
    elseif (args[1] == 'sp') then
        self.DB:set_profile_name(args[2])
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

function BHelper:init()
    self._debug = true
    self._runing = false
    self._module = ''
    self._action = ''

    self.vars = {}
    self.vars._player = {}
    self.vars._combat_state = false
    self.vars.behind_of_target = true
end
BHelper:init()
