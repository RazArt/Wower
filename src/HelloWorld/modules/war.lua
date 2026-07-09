(select(2, UnitClass('player'))):lower()

function HelloWorld.war:init()
    self:set_module((select(2, UnitClass('player'))):lower())
end

function HelloWorld.war:general_update()
    if (not UnitExists('target')) then
        HelloWorld:show(1)
    else
        HelloWorld:hide(1)
    end

    if ((self:get_health_on_percent() < 10) and (GetItemCount(33447) > 0) and
        ((select(1, GetItemCooldown(33447))) == 0)) then
        HelloWorld:show(2)
    else
        HelloWorld:hide(2)
    end

    if ((self:get_mana_on_percent() < 10) and (GetItemCount(33448) > 0) and
        ((select(1, GetItemCooldown(33448))) == 0)) then
        HelloWorld:show(3)
    else
        HelloWorld:hide(3)
    end
end

function HelloWorld.war:get_health_on_percent()
    return UnitHealth('player') / UnitHealthMax('player') * 100
end

function HelloWorld.war:get_mana_on_percent()
    return UnitMana('player') / UnitManaMax('player') * 100
end

function HelloWorld.war:get_health()
    return UnitHealth('player')
end

function HelloWorld.war:get_mana()
    return UnitMana('player')
end

function HelloWorld.war:get_power()
    return UnitPower('player')
end

function HelloWorld.war:get_combo_points()
    return GetComboPoints('player', 'target')
end

function HelloWorld.war:get_spell_cooldown(spellname)
    local start, duration, _ = GetSpellCooldown(spellname);
    local cd_time = start + duration - GetTime()
    if cd_time < 0 then
        return 0
    else
        return cd_time
    end
end

function HelloWorld.war:can_cast(spellname)
    if (not (select(1, IsUsableSpell(spellname)))) then return false end
    if (UnitCastingInfo('player')) then return false end
    if (UnitChannelInfo('player')) then return false end
    if (self:get_spell_cooldown(spellname) > 0) then return false end
    return true
end

function HelloWorld.war:can_cast_on_enemy(spellname)
    if (not self:can_cast(spellname)) then return false end
    if (UnitIsDeadOrGhost('target')) then return false end
    if (UnitCanAttack('player', 'target') ~= 1) then return false end
    if (IsSpellInRange(spellname, 'target') ~= 1) then return false end
    return true
end

function HelloWorld.war:can_cast_on_point(spellname)
    if (not self:can_cast(spellname)) then return false end
    if (UnitExists('mouseover') ~= 1) then return false end
    return true
end

function HelloWorld.war:get_ememy_debuff_time(spellname, player)
    player = player or false
    local _, _, _, _, _, _, expirationTime, unitCaster = UnitDebuff('target', spellname)
    if ((player) and (unitCaster ~= 'player')) then return 0 end
    if (expirationTime == nil) then return 0 end
    return expirationTime - GetTime()
end

function HelloWorld.war:get_player_buff_time(spellname)
    player = player or false
    local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff('player', spellname)
    if ((player) and (unitCaster ~= 'player')) then return 0 end
    if (expirationTime == nil) then return 0 end
    return expirationTime - GetTime()
end

function HelloWorld.war:is_enemy_cast()
    if (UnitCastingInfo('target')) then return true end
    if (UnitChannelInfo('target')) then return true end
    return false
end
