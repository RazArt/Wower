BHelper = {}

-- 1 - 1 ветка PvE
-- 2 - 1 ветка PvP
-- 3 - 2 ветка PvE
-- 4 - 2 ветка PvP
-- 5 - 3 ветка PvE
-- 6 - 4 ветка PvP

BHelper._event_frame = CreateFrame('Frame')
BHelper._event_frame:SetScript('OnEvent', function(_, event, ...)
    BHelper[event](BHelper, ...)
end)
BHelper._event_frame:RegisterEvent('PLAYER_LOGIN')
BHelper._event_frame:RegisterEvent('PLAYER_REGEN_DISABLED')
BHelper._event_frame:RegisterEvent('PLAYER_REGEN_ENABLED')
BHelper._event_frame:RegisterEvent('UI_ERROR_MESSAGE')
BHelper._event_frame:RegisterEvent('PLAYER_CONTROL_LOST')
BHelper._event_frame:RegisterEvent('PLAYER_CONTROL_GAINED')

function BHelper:PLAYER_LOGIN()
    BHelper.DB:init()
    self:create_state_frame()
    self:global_macros()

    self.modules[BHelper.DB().module]:_init()
    self.modules[BHelper.DB().module]:_macros()

    CreateFrame('Frame'):SetScript('OnUpdate', function(_, elapsed)
        self.timers:update(elapsed)
        if ((self:is_module_exist(self:DB().module)) and (self._runing) and (not self._cooldown)) then
            self.modules[self:DB().module]:_update()
        end
    end)
end

function BHelper:UI_ERROR_MESSAGE(message)
    if (message == SPELL_FAILED_NOT_BEHIND) then
        self.vars._behind_of_target = false
        self.timers:create(0.5, function()
            self.vars._behind_of_target = true
        end, 'behind_of_target')
    end
end

function BHelper:PLAYER_REGEN_DISABLED()
    self.vars._combat_state = true
    self:start()
end

function BHelper:PLAYER_REGEN_ENABLED()
    self.vars._combat_state = false
    self:stop()
end

function BHelper:PLAYER_CONTROL_LOST()
    print('FFFFFFFFFFFFFEEEEEEEAAAAAAAAAAAARRRRR')
    self._cooldown = true
end

function BHelper:PLAYER_CONTROL_GAINED()
    print('Играем дальше_________________________________')
    self._cooldown = false
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

function BHelper:init()
    self._debug = true
    self._runing = false
    self._module = ''
    self._action = ''

    self.vars = {}
    self.vars._player = {}
    self.vars._combat_state = false
    self.vars._behind_of_target = true
end
BHelper:init()
