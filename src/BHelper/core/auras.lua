BHelper.auras = {}

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

function BHelper.auras:namespace_init()
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

function BHelper.auras:get(unit_id, aura, cast_by_player)
    unit_id = unit_id:lower()
    aura = (type(aura) == 'string') and aura:lower() or aura

    if (not auras._auras) then return 0, 0 end
    if (not auras._auras[unit_id]) then return 0, 0 end
    if (not auras._auras[unit_id][aura]) then return 0, 0 end

    if ((cast_by_player) and (auras._auras[unit_id][aura][true])) then
        return auras._auras[unit_id][aura][true].time, auras._auras[unit_id][aura][true].count
    elseif ((not cast_by_player) and (auras._auras[unit_id][aura][true])) then
        return auras._auras[unit_id][aura][true].time, auras._auras[unit_id][aura][true].count
    elseif ((not cast_by_player) and (auras._auras[unit_id][aura][false])) then
        return auras._auras[unit_id][aura][false].time, auras._auras[unit_id][aura][false].count
    end

    return 0, 0
end

function BHelper.auras:update()
    wipe(auras._auras)

    if (not player:check_combat_state()) then return false end
    if (not player:can_target_attack()) then return false end

    for _, unit_id in pairs({'player', 'target'}) do
        auras._auras[unit_id] = {}
        for _, filter in pairs({'HARMFUL', 'HELPFUL'}) do
            for i = 1, 100 do
                local aura, _, _, count, _, _, expiration_time, unit_caster, _, _, id = UnitAura(unit_id, i, filter)
                if (aura == nil) then break end

                aura = aura:lower()
                expiration_time = (expiration_time > 0) and (expiration_time - GetTime()) or expiration_time
                expiration_time = (expiration_time == 0) and 9999 or expiration_time
                local cast_by_player = (unit_caster == 'player') and true or false

                if (not auras._auras[unit_id][aura]) then auras._auras[unit_id][aura] = {} end
                auras._auras[unit_id][aura][cast_by_player] = {}
                auras._auras[unit_id][aura][cast_by_player].aura = aura
                auras._auras[unit_id][aura][cast_by_player].id = id
                auras._auras[unit_id][aura][cast_by_player].time = expiration_time
                auras._auras[unit_id][aura][cast_by_player].count = count
                auras._auras[unit_id][id] = auras._auras[unit_id][aura]
            end
        end
    end
end

function BHelper.auras:init()
    self._auras = {}
end
BHelper.auras:init()
