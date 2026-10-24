BHelper = {}

BHelper._event_frame = CreateFrame('Frame')
BHelper._event_frame:SetScript('OnEvent', function(_, event, ...)
    BHelper[event](BHelper, ...)
end)
BHelper._event_frame:RegisterEvent('PLAYER_LOGIN')
BHelper._event_frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
BHelper._event_frame:RegisterEvent('PLAYER_REGEN_DISABLED')
BHelper._event_frame:RegisterEvent('PLAYER_REGEN_ENABLED')
BHelper._event_frame:RegisterEvent('PLAYER_CONTROL_LOST')
BHelper._event_frame:RegisterEvent('PLAYER_CONTROL_GAINED')
BHelper._event_frame:RegisterEvent('PLAYER_TARGET_CHANGED')

function BHelper:PLAYER_LOGIN()
    BHelper.core:namespace_init()
    BHelper.tables:namespace_init()
    BHelper.keybinds:namespace_init()
    BHelper.modules:namespace_init()
    BHelper.pet:namespace_init()
    BHelper.player:namespace_init()
    BHelper.target:namespace_init()
    BHelper.threat:namespace_init()

    BHelper.core:reload()

    BHelper.timers:create(0.5, function()
        BHelper.threat:update()
    end, 'threat_update', true)

    BHelper.timers:create(BHelper.core:get_update_time(), function()
        if ((BHelper.core.module:get()) and (BHelper.core:runing()) and (not BHelper.core:cooldown())) then
            BHelper.core.module:get():_execute()
        end
    end, 'main_execute', true)

    BHelper:create_state_frame()

    -- if ((not BHelperDBIcons) or (type(BHelperDBIcons) ~= 'table')) then BHelperDBIcons = {} end
    -- for i = 1, GetNumMacroIcons() do BHelperDBIcons[i] = GetMacroIconInfo(i) end
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
    BHelper.core:init_DB()

    self.timers:create(1, function()
        self.core:reload()
    end)
end

function BHelper:PLAYER_REGEN_DISABLED()
    BHelper.core:start()
end

function BHelper:PLAYER_REGEN_ENABLED()
    BHelper.core:stop()
end

function BHelper:PLAYER_CONTROL_LOST()
    BHelper.core._cooldown = true
end

function BHelper:PLAYER_CONTROL_GAINED()
    BHelper.core._cooldown = false
end

function BHelper:PLAYER_TARGET_CHANGED()
    BHelper.target._name = (UnitName('target')) or ''
end

function BHelper:commands(msg)
    msg = msg .. '\n'
    local args = {}

    for arg in string.gmatch(msg, '([^%s]+)') do table.insert(args, arg) end

    if ((args[1] == 'toggle') or (#args == 0)) then
        self.core:toggle()
    elseif (args[1] == 'start') then
        self.core:start()
    elseif (args[1] == 'stop') then
        self.core:stop()
    elseif (args[1] == 'tv') then
        self.core:toggle_var(args[2])
    elseif (args[1] == 'sv') then
        self.core:set_var(args[2], args[3])
    elseif (args[1] == 'sm') then
        self.core.module:set(args[2])
    elseif (args[1] == 'sp') then
        self.core.profile:set(args[2])
    elseif (args[1] == 'sa') then
        self.core.action:set(args[2])
    elseif (args[1] == 'm') then
        self.modules[self._module]:_macros()
    elseif (args[1] == 'c') then
        if (not args[2]) then args[2] = 0.2 end
        self.core:add_cooldown(tonumber(args[2]))
    else
        self.core:print('Неизвестная команда')
    end
end

SLASH_BHELPER1, SLASH_BHELPER2 = '/bhelper', '/bh'
SlashCmdList['BHELPER'] = function(message)
    BHelper:commands(message)
end

function BHelper:init()
    self.vars = {}
    self.vars._player = {}

end
BHelper:init()
