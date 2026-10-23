BHelper.auras = {}

local filters = {'HARMFUL', 'HELPFUL'}

function BHelper.auras:get(unit_id, aura, cast_by_player)
    unit_id = unit_id:lower()
    aura = (type(aura) == 'string') and aura:lower() or aura
    cast_by_player = (cast_by_player) and '|PLAYER' or ''

    for _, filter in pairs(filters) do
        for i = 1, 255 do
            local name, _, _, count, _, _, time, _, _, _, id = UnitAura(unit_id, i, filter .. cast_by_player)
            if (not name) then break end
            if ((aura == name:lower()) or (aura == id)) then
                time = (time > 0) and (time - GetTime()) or time
                time = (time == 0) and 9999 or time
                return time, count
            end
        end
    end
    return 0, 0
end
