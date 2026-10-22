BHelper.player = {}

function BHelper.player:get_GUID()
    if (BHelper.player.GUID) then return BHelper.player.GUID end
    BHelper.player.GUID = UnitGUID('player')
    return BHelper.player.GUID
end

function BHelper.player:get_name()
    if (BHelper.player.name) then return BHelper.player.name end
    BHelper.player.name = select(1, UnitName('player'))
    return BHelper.player.name
end

function BHelper.player:get_class()
    if (BHelper.player.class) then return BHelper.player.class end
    BHelper.player.class = select(2, UnitClass('player')):lower()
    return BHelper.player.class
end

function BHelper.player:get_spec() -- Add cache
    return GetSpecialization('player') or 1
    -- return 1
end

function BHelper.player:get_level()
    return UnitLevel('player') or 1
end

function BHelper.player:get_health_on_percent()
    return BHelper.player:get_health() / BHelper.player:get_health_max() * 100
end

function BHelper.player:get_mana_on_percent()
    return BHelper.player:get_mana() / BHelper.player:get_mana_max() * 100
end

function BHelper.player:get_health()
    return UnitHealth('player') or 0
end

function BHelper.player:get_mana()
    return UnitMana('player') or 0
end

function BHelper.player:get_power()
    return UnitPower('player') or 0
end

function BHelper.player:get_health_max()
    return UnitHealthMax('player') or 0
end

function BHelper.player:get_mana_max()
    return UnitManaMax('player') or 0
end

function BHelper.player:get_power_max()
    return UnitPowerMax('player') or 0
end

function BHelper.player:check_combo_points(count)
    return (GetComboPoints('player', 'target') >= count)
end

function BHelper.player:aura(aura, cast_by_player)
    return BHelper.auras:get('player', aura, cast_by_player)
end

function BHelper.player:can_use_item(item)
    if (BHelper.player:get_item_count(item) == 0) then return false end
    if (BHelper.player:check_item_on_cooldown(item)) then return false end
    if (BHelper.player:is_mounted()) then return false end
    if (not HasFullControl()) then return false end
    return true
end

function BHelper.player:check_item_on_cooldown(item)
    local start, duration = GetItemCooldown(item)
    return (start + duration - GetTime() - 0.2 > 0) and true or false
end

function BHelper.player:check_equipped_item(item)
    if (not IsEquippedItem(item)) then return false end
    return true
end

function BHelper.player:equip_set(set)
    return UseEquipmentSet(set)
end

function BHelper.player:get_item_count(item)
    return GetItemCount(item)
end

function BHelper.player:can_cast(spellname, check_time)
    if (not select(1, IsUsableSpell(spellname))) then return false end
    if (BHelper.player:spell_is_targeting()) then return false end
    if (BHelper.player:check_cast()) then return false end
    if (BHelper.player:check_spell_on_cooldown(spellname, check_time)) then return false end
    if (not HasFullControl()) then return false end
    return true
end

function BHelper.player:can_cast_on_enemy(spellname, check_time)
    if (not BHelper.player:can_cast(spellname, check_time)) then return false end
    if (not BHelper.player:can_target_attack()) then return false end
    if (not BHelper.player:check_spell_range(spellname, unit_id)) then return false end
    return true
end

function BHelper.player:can_cast_on_friend(spellname, unit_id, check_time)
    unit_id = unit_id or 'target'
    if (not BHelper.player:can_cast(spellname, check_time)) then return false end
    if (not UnitExists(unit_id)) then return false end
    if (UnitIsDeadOrGhost(unit_id)) then return false end
    if (UnitIsDeadOrGhost('player')) then return false end
    if (not UnitCanAssist('player', unit_id)) then return false end
    if (not BHelper.player:check_spell_range(spellname, unit_id)) then return false end
    return true
end

function BHelper.player:can_cast_on_point(spellname, check_time)
    if (not BHelper.player:can_cast(spellname, check_time)) then return false end
    if (not UnitExists('mouseover')) then return false end
    if (IsMouseButtonDown('RightButton')) then return false end
    if (IsMouseButtonDown('LeftButton')) then return false end
    if (IsMouseButtonDown('MiddleButton')) then return false end
    return true
end

function BHelper.player:can_target_attack()
    if (not UnitExists('target')) then return false end
    if (UnitIsDeadOrGhost('target')) then return false end
    if (UnitIsDeadOrGhost('player')) then return false end
    if (not UnitCanAttack('player', 'target')) then return false end

    if (BHelper.target:aura('Спячка') > 0) then return false end
    if (BHelper.target:aura('Смерч') > 0) then return false end
    if (BHelper.target:aura('Превращение') > 0) then return false end
    if (BHelper.target:aura('Страх') > 0) then return false end
    if (BHelper.target:aura('Ослепление') > 0) then return false end

    -- if (BHelper.target:get_name() == 'Малый слизнюк') then return false end
    -- if (BHelper.target:get_name() == 'Дарнаван') then return false end
    -- if (BHelper.target:get_name() == 'Большой слизнюк') then return false end
    -- if (BHelper.target:get_name() == 'Темное ядро') then return false end
    -- if (((BHelper.target:get_name() == 'Принц Валанар') or
    --     (BHelper.target:get_name() == 'Принц Келесет') or
    --     (BHelper.target:get_name() == 'Принц Талдарам')) and (BHelper.target:get_health() == 1) and
    --     (BHelper.player:aura('Перенаправление') == 0)) then return false end

    return true
end

function BHelper.player:spell_is_targeting()
    if (not SpellIsTargeting()) then return false end
    return true
end

function BHelper.player:check_spell_range(spellname, unit_id)
    unit_id = unit_id or 'target'
    if (IsSpellInRange(spellname, unit_id) ~= 1) then return false end
    return true
end

function BHelper.player:get_spell_casttime(spellname)
    local castTime = select(7, GetSpellInfo(spellname))
    return (castTime > 0) and (castTime / 1000) or 0
end

function BHelper.player:get_spell_cooldown(spellname)
    local start, duration = GetSpellCooldown(spellname)
    if (start == nil) then start = 0 end
    if (duration == nil) then duration = 0 end
    return start + duration - GetTime() - 0.2
end

function BHelper.player:check_spell_on_cooldown(spellname, check_time)
    check_time = check_time or 0.2
    check_time = (check_time > 0.2) and (check_time - 0.2) or 0.2

    local cd = BHelper.player:get_spell_cooldown(spellname)
    return (cd > check_time) and true or false
end

function BHelper.player:check_cast()
    local _, _, _, _, _, endTime = UnitCastingInfo('player')
    if (endTime) then return (endTime / 1000 - GetTime() > 0.2) and true or false end

    local _, _, _, _, _, endTime = UnitChannelInfo('player')
    if (endTime) then return (endTime / 1000 - GetTime() > 0.2) and true or false end

    return false
end

function BHelper.player:check_combat_state()
    return BHelper.vars._combat_state
end

function BHelper.player:check_party_or_raid()
    if ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) then return true end
    return false
end

function BHelper.player:check_moving()
    if (GetUnitSpeed('player') > 0) then return true end
    return false
end

function BHelper.player:check_hight_threat(limit)
    limit = limit or 85

    if (not BHelper.player:check_party_or_raid()) then return false end
    if (not BHelper.target:should_evade()) then return false end

    if (BHelper.threat.first_unit_GUID == BHelper.player:get_GUID()) then return true end
    if ((BHelper.threat.second_unit_GUID == BHelper.player:get_GUID()) and (BHelper.threat.second_unit_treat >= limit)) then
        return true
    end
    return false
end

function BHelper.player:check_low_threat(limit)
    limit = limit or 80

    if (not BHelper.player:check_party_or_raid()) then return false end
    if (BHelper.threat.first_unit_GUID ~= BHelper.player:get_GUID()) then return true end
    if (BHelper.threat.second_unit_treat >= limit) then return true end
    return false
end

function BHelper.player:check_heroism_buff()
    if (BHelper.player:aura('Героизм') > 0) then return true end
    if (BHelper.player:aura('Жажда крови') > 0) then return true end
    return false
end

function BHelper.player:check_burst_mode()
    if (BHelper.player:check_heroism_buff()) then return true end
    if (BHelper.target:is_boss()) then return true end
    return false
end

function BHelper.player:is_mounted()
    return IsMounted()
end

function BHelper.player:check_location_is_icc()
    if (GetCurrentMapAreaID() == 605) then return true end
    return false
end

