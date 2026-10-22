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

function BHelper.threat:update()
    threat.first_unit_GUID = ''
    threat.second_unit_GUID = ''
    threat.second_unit_treat = 0
    wipe(threat._list)

    if (not player:check_combat_state()) then return false end
    if (not player:can_target_attack()) then return false end

    local is_party = GetNumPartyMembers() > 0
    local is_raid = GetNumRaidMembers() > 0

    local player_GUID = player:get_GUID()
    local player_pet_GUID = pet:get_GUID()

    if player_GUID then table.insert(threat._list, {'player', player_GUID}) end
    if player_pet_GUID then table.insert(threat._list, {'pet', player_pet_GUID}) end

    if is_party or is_raid then
        local units_ID = is_raid and threat._raid_IDs or threat._party_IDs
        local units_pets_ID = is_raid and threat._raid_pets_IDs or threat._party_pets_IDs

        for i = 1, is_raid and GetNumRaidMembers() or GetNumPartyMembers() do
            local unit_GUID = UnitGUID(units_ID[i])
            local unit_pet_GUID = UnitGUID(units_pets_ID[i])

            if ((unit_GUID) and (unit_GUID ~= player_GUID)) then
                table.insert(threat._list, {units_ID[i], unit_GUID})
            end
            if ((unit_pet_GUID) and (unit_pet_GUID ~= player_pet_GUID)) then
                table.insert(threat._list, {units_pets_ID[i], unit_pet_GUID})
            end
        end
    end

    for i = #threat._list, 1, -1 do
        local _, _, threat_percent = UnitDetailedThreatSituation(threat._list[i][1], 'target')

        if threat_percent then
            table.insert(threat._list[i], threat_percent)
        else
            table.remove(threat._list, i)
        end
    end

    if (#threat._list > 1) then
        table.sort(threat._list, function(a, b)
            return a[3] > b[3]
        end)
    end

    if (threat._list[1]) then threat.first_unit_GUID = threat._list[1][2] or '' end
    if (threat._list[2]) then
        threat.second_unit_GUID = threat._list[2][2] or ''
        threat.second_unit_treat = threat._list[2][3] or 0
    end
end

function BHelper.threat:init()
    self._list = {}

    self._party_IDs = {}
    self._party_pets_IDs = {}
    self._raid_IDs = {}
    self._raid_pets_IDs = {}

    for i = 1, 4 do self._party_IDs[i] = format('party%d', i) end
    for i = 1, 4 do self._party_pets_IDs[i] = format('partypet%d', i) end
    for i = 1, 40 do self._raid_IDs[i] = format('raid%d', i) end
    for i = 1, 40 do self._raid_pets_IDs[i] = format('raidpet%d', i) end
end
BHelper.threat:init()
