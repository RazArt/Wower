BHelper.threat = {}

function BHelper.threat:update()
    self.first_unit_GUID = ''
    self.second_unit_GUID = ''
    self.second_unit_treat = 0

    if (not BHelper.vars._combat_state) then return false end
    if (not BHelper.player:can_target_attack()) then return false end

    local is_party = GetNumPartyMembers() > 0
    local is_raid = GetNumRaidMembers() > 0

    wipe(self._list)

    local player_GUID = BHelper.player:get_GUID()
    local player_pet_GUID = BHelper.player:get_pet_GUID()

    if player_GUID then table.insert(self._list, {'player', player_GUID}) end
    if player_pet_GUID then table.insert(self._list, {'pet', player_pet_GUID}) end

    if is_party or is_raid then
        local units_ID = is_raid and self._raid_IDs or self._party_IDs
        local units_pets_ID = is_raid and self._raid_pets_IDs or self._party_pets_IDs

        for i = 1, is_raid and GetNumRaidMembers() or GetNumPartyMembers() do
            local unit_GUID = UnitGUID(units_ID[i])
            local unit_pet_GUID = UnitGUID(units_pets_ID[i])

            if ((unit_GUID) and (unit_GUID ~= player_GUID)) then
                table.insert(self._list, {units_ID[i], unit_GUID})
            end
            if ((unit_pet_GUID) and (unit_pet_GUID ~= player_pet_GUID)) then
                table.insert(self._list, {units_pets_ID[i], unit_pet_GUID})
            end
        end
    end

    for i = #self._list, 1, -1 do
        local _, _, threat_percent = UnitDetailedThreatSituation(self._list[i][1], 'target')

        if threat_percent then
            table.insert(self._list[i], threat_percent)
        else
            table.remove(self._list, i)
        end
    end

    if (#self._list > 1) then
        table.sort(self._list, function(a, b)
            return a[3] > b[3]
        end)
    end

    if (self._list[1]) then self.first_unit_GUID = self._list[1][2] or '' end
    if (self._list[2]) then
        self.second_unit_GUID = self._list[2][2] or ''
        self.second_unit_treat = self._list[2][3] or 0
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

    BHelper.timers:create(0.3, function()
        self:update()
    end, 'threat_update', true)
end
BHelper.threat:init()
