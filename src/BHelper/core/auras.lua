BHelper.auras = {}

function BHelper.auras:player(aura, cast_by_player)
    return self:_get('player', aura, cast_by_player)
end

function BHelper.auras:target(aura, cast_by_player)
    return self:_get('target', aura, cast_by_player)
end

function BHelper.auras:_get(unit_id, aura, cast_by_player)
    unit_id = string.lower(unit_id)
    aura = string.lower(aura)

    if (not self._auras[unit_id][aura]) then return 0, 0 end
    if ((cast_by_player) and (not self._auras[unit_id][aura].cast_by_player)) then return 0, 0 end

    return self._auras[unit_id][aura].time, self._auras[unit_id][aura].count
end

function BHelper.auras:update()
    for _, unit_id in pairs({'player', 'target'}) do
        self._auras[unit_id] = {}
        for _, filter in pairs({'HARMFUL', 'HELPFUL'}) do
            for i = 1, 100 do
                local aura, _, _, count, _, _, expiration_time, unit_caster, _, _, id = UnitAura(unit_id, i, filter)
                if (aura == nil) then break end

                aura = string.lower(aura)
                expiration_time = (expiration_time > 0) and (expiration_time - GetTime()) or expiration_time
                expiration_time = (expiration_time == 0) and 9999 or expiration_time
                self._auras[unit_id][aura] = {}
                self._auras[unit_id][aura].time = expiration_time
                self._auras[unit_id][aura].count = count
                self._auras[unit_id][aura].cast_by_player = (unit_caster == 'player') and true or false
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
