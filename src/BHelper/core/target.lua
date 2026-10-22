BHelper.target = {}

function BHelper.target:get_name()
    return BHelper.target._name
end

function BHelper.target:get_health_on_percent()
    return UnitHealth('target') / UnitHealthMax('target') * 100
end

function BHelper.target:get_mana_on_percent()
    return UnitMana('target') / UnitManaMax('target') * 100
end

function BHelper.target:get_health()
    return UnitHealth('target') or 0
end

function BHelper.target:get_mana()
    return UnitMana('target') or 0
end

function BHelper.target:get_power()
    return UnitPower('target') or 0
end

function BHelper.target:get_health_max()
    return UnitHealthMax('target') or 0
end

function BHelper.target:get_mana_max()
    return UnitManaMax('target') or 0
end

function BHelper.target:get_power_max()
    return UnitPowerMax('target') or 0
end

function BHelper.target:is_boss()
    if ((UnitClassification('target') == 'worldboss') or UnitLevel('target') == -1) then return true end
    return false
end

function BHelper.target:is_player()
    if (UnitIsPlayer('target')) then return true end
    return false
end

function BHelper.target:player_on_target()
    if (not BHelper.target:should_evade()) then return false end

    if (UnitIsUnit('player', 'targettarget')) then return true end
    return false
end

function BHelper.target:should_evade()
    if (string.find(string.lower(BHelper.target:get_name()), 'манекен')) then return false end
    if (BHelper.target:get_name() == 'Кровавая королева Лана\'тель') then return false end
    if (BHelper.target:get_name() == 'Леди Смертный Шепот') then return false end
    return true
end

function BHelper.target:check_cast()
    if (UnitCastingInfo('target')) then return true end
    if (UnitChannelInfo('target')) then return true end
    return false
end

function BHelper.target:check_casting_spellname(spellname)
    local spellname_1 = UnitCastingInfo('target')
    local spellname_2 = UnitChannelInfo('target')
    if ((spellname == spellname_1) or (spellname == spellname_2)) then return true end
    return false
end

function BHelper.target:enemy_on_combat()
    if (UnitCanAttack('player', 'target') ~= 1) then return false end
    if (UnitCanAttack('target', 'targettarget') == 1) then return true end
    if (UnitAffectingCombat('target') ~= nil) then return true end
    return false
end

function BHelper.target:check_moving()
    if (GetUnitSpeed('target') > 0) then return true end
    return false
end
