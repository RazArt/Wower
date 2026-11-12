BHelper = {}

local event_frame = CreateFrame('Frame')
event_frame:SetScript('OnEvent', function(_, event, ...)
    BHelper[event](BHelper, ...)
end)

event_frame:RegisterEvent('PLAYER_LOGIN')
event_frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
event_frame:RegisterEvent('PLAYER_CONTROL_LOST')
event_frame:RegisterEvent('PLAYER_CONTROL_GAINED')
event_frame:RegisterEvent('PLAYER_TARGET_CHANGED')
event_frame:RegisterEvent('SPELLS_CHANGED')
event_frame:RegisterEvent('UPDATE_MACROS')
event_frame:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
event_frame:RegisterEvent('UNIT_INVENTORY_CHANGED')

function BHelper:PLAYER_LOGIN()
    BHelper.core:namespace_init()
    BHelper.keybinds:namespace_init()
    BHelper.pet:namespace_init()
    BHelper.player:namespace_init()
    BHelper.target:namespace_init()
    BHelper.threat:namespace_init()

    BHelper.core:reload()

    BHelper.timers:create(0.5, function()
        BHelper.threat:update()
    end, 'threat_update', true)

    BHelper.timers:create(BHelper.core:get_update_time(), function()
        BHelper.core:execute()
    end, 'main_execute', true)
end

function BHelper:SPELLS_CHANGED()
    self.timers:create(1, function()
        BHelper.keybinds:bind_spells()
    end, 'spells_update')
end

function BHelper:UPDATE_MACROS()
    self.timers:create(1, function()
        BHelper.keybinds:bind_macros()
    end, 'macros_update')
end

function BHelper:PLAYER_EQUIPMENT_CHANGED()
    self.timers:create(1, function()
        BHelper.keybinds:bind_items()
    end, 'items_update')
end

function BHelper:UNIT_INVENTORY_CHANGED(unit_id)
    if (unit_id ~= 'player') then return false end

    self.timers:create(1, function()
        BHelper.keybinds:bind_items()
    end, 'items_update')
end

function BHelper:ACTIVE_TALENT_GROUP_CHANGED()
    self.timers:create(1, function()
        self.core:reload()
    end, 'reload')
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

    if (args[1] == 'start') then
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
    elseif (args[1] == 'r') then
        self.core:reload()
    elseif (args[1] == 'l') then
        self.core:locked_toggle()
    elseif (args[1] == 'h') then
        self.keybinds:hide(2)
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

-- function BHelper:init()
--     self.vars = {}
--     self.vars._player = {}
-- end
-- BHelper:init()
