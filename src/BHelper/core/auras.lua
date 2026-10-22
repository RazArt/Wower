BHelper.auras = {}

function BHelper.auras:player(aura, cast_by_player)
    return self:_get('player', aura, cast_by_player)
end

function BHelper.auras:target(aura, cast_by_player)
    return self:_get('target', aura, cast_by_player)
end

function BHelper.auras:_get(unit_id, aura, cast_by_player)
    unit_id = string.lower(unit_id)
    aura = (type(aura) == 'string') and string.lower(aura) or aura

    if (not self._auras) then return 0, 0 end
    if (not self._auras[unit_id]) then return 0, 0 end
    if (not self._auras[unit_id][aura]) then return 0, 0 end

    if ((cast_by_player) and (self._auras[unit_id][aura][true])) then
        return self._auras[unit_id][aura][true].time, self._auras[unit_id][aura][true].count
    elseif ((not cast_by_player) and (self._auras[unit_id][aura][true])) then
        return self._auras[unit_id][aura][true].time, self._auras[unit_id][aura][true].count
    elseif ((not cast_by_player) and (self._auras[unit_id][aura][false])) then
        return self._auras[unit_id][aura][false].time, self._auras[unit_id][aura][false].count
    end

    return 0, 0
end

function BHelper.auras:update()
    wipe(self._auras)

    if (not BHelper.vars._combat_state) then return false end
    if (not BHelper.player:can_target_attack()) then return false end

    for _, unit_id in pairs({'player', 'target'}) do
        self._auras[unit_id] = {}
        for _, filter in pairs({'HARMFUL', 'HELPFUL'}) do
            for i = 1, 100 do
                local aura, _, _, count, _, _, expiration_time, unit_caster, _, _, id = UnitAura(unit_id, i, filter)
                if (aura == nil) then break end

                aura = string.lower(aura)
                expiration_time = (expiration_time > 0) and (expiration_time - GetTime()) or expiration_time
                expiration_time = (expiration_time == 0) and 9999 or expiration_time
                local cast_by_player = (unit_caster == 'player') and true or false

                if (not self._auras[unit_id][aura]) then self._auras[unit_id][aura] = {} end
                self._auras[unit_id][aura][cast_by_player] = {}
                self._auras[unit_id][aura][cast_by_player].aura = aura
                self._auras[unit_id][aura][cast_by_player].id = id
                self._auras[unit_id][aura][cast_by_player].time = expiration_time
                self._auras[unit_id][aura][cast_by_player].count = count
                self._auras[unit_id][id] = self._auras[unit_id][aura]
            end
        end
    end
end

function BHelper.auras:init()
    self._auras = {}

    BHelper.timers:create(BHelper.update_time, function()
        self:update()
    end, 'auras_update', true)
end
BHelper.auras:init()
