BHelper.threat = {}
BHelper.threat._list = {}
BHelper.threat.first_unit_GUID = ''
BHelper.threat.second_unit_GUID = ''
BHelper.threat.second_unit_treat = 0

BHelper.threat._party_IDs = {}
BHelper.threat._party_pets_IDs = {}
BHelper.threat._raid_IDs = {}
BHelper.threat._raid_pets_IDs = {}

for i = 1, 4 do BHelper.threat._party_IDs[i] = format('party%d', i) end
for i = 1, 4 do BHelper.threat._party_pets_IDs[i] = format('partypet%d', i) end
for i = 1, 40 do BHelper.threat._raid_IDs[i] = format('raid%d', i) end
for i = 1, 40 do BHelper.threat._raid_pets_IDs[i] = format('raidpet%d', i) end

function BHelper.threat:update()
    -- if (not BHelper.vars._combat_state) then return false end
    -- if (not BHelper.player:can_target_attack()) then return false end

    local is_party = GetNumPartyMembers() > 0
    local is_raid = GetNumRaidMembers() > 0

    wipe(self._list)

    local player_GUID = UnitGUID('player')
    if player_GUID then table.insert(self._list, {'player', player_GUID, UnitName('player')}) end
    local player_pet_GUID = UnitGUID('pet')
    if player_pet_GUID then table.insert(self._list, {'pet', player_pet_GUID, UnitName('pet')}) end

    if is_party or is_raid then
        local units_ID = is_raid and BHelper.threat._raid_IDs or BHelper.threat._party_IDs
        local units_pets_ID = is_raid and BHelper.threat._raid_pets_IDs or BHelper.threat._party_pets_IDs

        for i = 1, is_raid and GetNumRaidMembers() or GetNumPartyMembers() do
            local unit_GUID = UnitGUID(units_ID[i])
            local unit_pet_GUID = UnitGUID(units_pets_ID[i])

            if (unit_GUID) then table.insert(self._list, {units_ID[i], unit_GUID, UnitName(units_ID[i])}) end

            if (unit_pet_GUID) then
                table.insert(self._list, {units_pets_ID[i], unit_pet_GUID, UnitName(units_pets_ID[i])})
            end
        end
    end

    for i = #self._list, 1, -1 do
        local is_tank, status, threat_percent, _, threat_value = UnitDetailedThreatSituation(self._list[i][1], 'target')

        if threat_value then
            table.insert(self._list[i], is_tank and true or false)
            table.insert(self._list[i], status)
            table.insert(self._list[i], threat_percent)
        else
            table.remove(self._list, i)
        end
    end

    if (#self._list > 0) then
        table.sort(self._list, function(a, b)
            return a[6] > b[6]
        end)

        self.first_unit_GUID = self._list[1][2] or ''
        self.second_unit_GUID = self._list[2][2] or ''
        self.second_unit_treat = self._list[2][6] or 0
    end
end

function BHelper.threat:check_low_threat()
    if (self.first_unit_GUID ~= UnitGUID('player')) then return true end
    if (self.second_unit_treat >= 70) then return true end
    return false
end
