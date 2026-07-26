BHelper.common = {}

function BHelper.common:init()
    self:set_route(self.root:get_player_class())
end

function BHelper.common:general_update()
    if (not UnitExists('target')) then Keystroke:show(0, 1) end

    if ((self:get_health_on_percent() < 10) and (GetItemCount(33447) > 0) and
        ((select(1, GetItemCooldown(33447))) == 0)) then Keystroke:show(10, 0, 0, 1, 0) end

    if ((self:get_mana_on_percent() < 10) and (GetItemCount(33448) > 0) and
        ((select(1, GetItemCooldown(33448))) == 0)) then Keystroke:show(9, 0, 0, 1, 0) end
end

function BHelper.common:get_health_on_percent()
    return UnitHealth('player') / UnitHealthMax('player') * 100
end

function BHelper.common:get_mana_on_percent()
    return UnitMana('player') / UnitManaMax('player') * 100
end

function BHelper.common:get_health()
    return UnitHealth('player')
end

function BHelper.common:get_mana()
    return UnitMana('player')
end

function BHelper.common:get_power()
    return UnitPower('player')
end

function BHelper.common:check_combo_points(count)
    return (GetComboPoints('player', 'target') >= count)
end

function BHelper.common:get_spell_cooldown(spellname)
    local start, duration, _ = GetSpellCooldown(spellname)
    local cd_time = start + duration - GetTime() - 0.2
    return (cd_time < 0) and 0 or cd_time
end

function BHelper.common:is_spell_cooldown(spellname)
    local start, duration, _ = GetSpellCooldown(spellname)
    return (start + duration - GetTime() - 0.2 > 0) and true or false
end

function BHelper.common:is_player_cast()
    local _, _, _, _, _, endTime = UnitCastingInfo('player')
    if (endTime ~= nil) then return (endTime / 1000 - GetTime() - 0.2 > 0) and true or false end

    local _, _, _, _, _, endTime = UnitChannelInfo('player')
    if (endTime ~= nil) then return (endTime / 1000 - GetTime() - 0.2 > 0) and true or false end

    return false
end

function BHelper.common:is_enemy_cast()
    if (UnitCastingInfo('target')) then return true end
    if (UnitChannelInfo('target')) then return true end
end

function BHelper.common:can_cast(spellname)
    if (not (select(1, IsUsableSpell(spellname)))) then return false end
    if (self:is_player_cast()) then return false end
    if (self:is_spell_cooldown(spellname)) then return false end
    return true
end

function BHelper.common:can_cast_on_enemy(spellname)
    if (not self:can_cast(spellname)) then return false end
    if (UnitIsDeadOrGhost('target')) then return false end
    if (UnitCanAttack('player', 'target') ~= 1) then return false end
    if (IsSpellInRange(spellname, 'target') ~= 1) then return false end
    return true
end

function BHelper.common:can_cast_on_point(spellname)
    if (not self:can_cast(spellname)) then return false end
    if (UnitExists('mouseover') ~= 1) then return false end
    return true
end

function BHelper.common:get_ememy_debuff_time(spell, player)
    player = player or false
    for i = 1, 40 do
        local name, _, _, _, _, _, expirationTime, unitCaster, _, _, spellId = UnitDebuff('target',
                                                                                          i)
        if (((type(spell) == 'string') and (spell == name)) or
            ((type(spell) == 'number') and (spell == spellId))) then
            if (((player) and (unitCaster == 'player')) or (not player)) then
                if (expirationTime == 0) then return 99999 end
                if (expirationTime == nil) then return 0 end
                return expirationTime - GetTime()
            end
        end
    end

    return 0
end

function BHelper.common:get_ememy_debuff_count(spell, player)
    player = player or false
    for i = 1, 40 do
        local name, _, _, count, _, _, _, unitCaster, _, _, spellId = UnitDebuff('target', i)
        if (((type(spell) == 'string') and (spell == name)) or
            ((type(spell) == 'number') and (spell == spellId))) then
            if (((player) and (unitCaster == 'player')) or (not player)) then
                return count
            end
        end
    end

    return 0
end

function BHelper.common:get_player_buff_time(spell, player)
    player = player or false
    for i = 1, 40 do
        local name, _, _, _, _, _, expirationTime, unitCaster, _, _, spellId = UnitBuff('player', i)
        if (((type(spell) == 'string') and (spell == name)) or
            ((type(spell) == 'number') and (spell == spellId))) then
            if (((player) and (unitCaster == 'player')) or (not player)) then
                if (expirationTime == 0) then return 99999 end
                if (expirationTime == nil) then return 0 end
                return expirationTime - GetTime()
            end
        end
    end

    return 0
end

function BHelper.common:get_player_buff_count(spell, player)
    player = player or false
    for i = 1, 40 do
        local name, _, _, count, _, _, _, unitCaster, _, _, spellId = UnitBuff('player', i)
        if (((type(spell) == 'string') and (spell == name)) or
            ((type(spell) == 'number') and (spell == spellId))) then
            if (((player) and (unitCaster == 'player')) or (not player)) then
                return count
            end
        end
    end

    return 0
end

function BHelper.common:get_bag_free_slots()
    local free_slots_count = 0
    for bag_num = 0, 4 do
        free_slots_count = free_slots_count + (select(1, GetContainerNumFreeSlots(bag_num)))
    end
    return free_slots_count
end
