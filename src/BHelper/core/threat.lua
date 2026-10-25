BHelper.threat = {}

local auras = {}
local core = {}
local keybinds = {}
local macros = {}
local modules = {}
local pet = {}
local player = {}
local pool = {}
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
    pool = BHelper.pool
    target = BHelper.target
    threat = BHelper.threat
    timers = BHelper.timers
end

local threat_list = {}
local units_ID = {{}, {}}

for i = 1, 4 do
    table.insert(units_ID[1], format('party%d', (i <= 4) and i or (i - 4)))
    table.insert(units_ID[1], format('partypet%d', (i <= 4) and i or (i - 4)))
end
table.insert(units_ID[1], 'player')
table.insert(units_ID[1], 'pet')
for i = 1, 40 do
    table.insert(units_ID[2], format('raid%d', (i <= 40) and i or (i - 40)))
    table.insert(units_ID[2], format('raidpet%d', (i <= 40) and i or (i - 40)))
end

function BHelper.threat:get_tank_GUID()
    return ((threat_list[1]) and (threat_list[1].guid)) and threat_list[1].guid or ''
end

function BHelper.threat:get_DD_GUID()
    return ((threat_list[2]) and (threat_list[2].guid)) and threat_list[2].guid or ''
end

function BHelper.threat:get_DD_threat()
    return ((threat_list[2]) and (threat_list[2].threat)) and threat_list[2].threat or 0
end

function BHelper.threat:update()
    for i = #threat_list, 1, -1 do pool:release(threat_list[i], 'threat', true) end
    wipe(threat_list)

    if (not player:on_combat()) then return false end
    if (not player:can_target_attack()) then return false end

    local is_party = GetNumPartyMembers() > 0
    local is_raid = GetNumRaidMembers() > 0
    if ((not is_party) and (not is_raid)) then return false end

    local units_ID = (is_raid) and units_ID[2] or units_ID[1]
    for i = #units_ID, 1, -1 do
        local unit_GUID = UnitGUID(units_ID[i])
        if (unit_GUID) then
            local _, _, threat_pct = UnitDetailedThreatSituation(units_ID[i], 'target')
            if ((threat_pct) and (type(threat_pct) == 'number')) then
                local unit_info = pool:fetch('threat')
                unit_info.guid = unit_GUID
                unit_info.threat = threat_pct
                threat_list[#threat_list + 1] = unit_info
            end
        end
    end

    if (#threat_list > 1) then
        table.sort(threat_list, function(a, b)
            return a.threat > b.threat
        end)
    end

    -- print('-------')
    -- for i = 1, #threat_list do
    --     if ((threat_list[i]) and (threat_list[i].guid) and (threat_list[i].threat)) then
    --         print(i, threat_list[i].guid, threat_list[i].threat,
    --               (threat_list[i].guid == player.GUID()) and '<<<<<<<<<<<< YOU' or '')
    --     end
    -- end
    -- print(player:has_stable_threat())
end
