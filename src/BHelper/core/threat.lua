BHelper.threat = {}

local auras = {}
local core = {}
local keybinds = {}
local macros = {}
local modules = {}
local pet = {}
local player = {}
local target = {}
local threat = {}
local timers = {}

function BHelper.threat:namespace_init()
    auras = BHelper.auras
    core = BHelper.core
    keybinds = BHelper.keybinds
    macros = BHelper.macros
    modules = BHelper.modules
    pet = BHelper.pet
    player = BHelper.player
    target = BHelper.target
    threat = BHelper.threat
    timers = BHelper.timers
end

function BHelper.threat:get_tank_GUID()
    return ((threat._list[1]) and (threat._list[1].guid)) and threat._list[1].guid or ''
end

function BHelper.threat:get_DD_GUID()
    return ((threat._list[2]) and (threat._list[2].guid)) and threat._list[2].guid or ''
end

function BHelper.threat:get_DD_threat()
    return ((threat._list[2]) and (threat._list[2].threat)) and threat._list[2].threat or ''
end

function BHelper.threat:update()
    for i = #threat._list, 1, -1 do wipe(threat._list[i]) end
    wipe(threat._list)

    if (not player:on_combat()) then return false end
    if (not player:can_target_attack()) then return false end

    local is_party = GetNumPartyMembers() > 0
    local is_raid = GetNumRaidMembers() > 0
    if ((not is_party) and (not is_raid)) then return false end

    local units_ID = (is_party) and threat._units_ID[1] or threat._units_ID[2]
    for i = #units_ID, 1, -1 do
        local unit_GUID = UnitGUID(units_ID[i])
        if (unit_GUID) then
            local _, _, threat_level = UnitDetailedThreatSituation(units_ID[i], 'target')
            if (threat_level) then table.insert(threat._list, {guid = unit_GUID, threat = threat_level}) end
        end
    end

    if (#threat._list > 1) then
        table.sort(threat._list, function(a, b)
            return a.threat > b.threat
        end)
    end

    print('--------')
    for i = 1, #threat._list do print(threat._list[i].guid, threat._list[i].threat) end
    print(player:check_safety_threat())
end

function BHelper.threat:init()
    self._list = {}

    self._units_ID = {{}, {}}
    for i = 1, 4 do
        table.insert(self._units_ID[1], format('party%d', (i <= 4) and i or (i - 4)))
        table.insert(self._units_ID[1], format('partypet%d', (i <= 4) and i or (i - 4)))
    end
    table.insert(self._units_ID[1], 'player')
    table.insert(self._units_ID[1], 'pet')

    for i = 1, 40 do
        table.insert(self._units_ID[2], format('raid%d', (i <= 40) and i or (i - 40)))
        table.insert(self._units_ID[2], format('raidpet%d', (i <= 40) and i or (i - 40)))
    end
end
BHelper.threat:init()
