BHelper.player = {}

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

function BHelper.player:namespace_init()
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

function BHelper.player:GUID()
    if (player._GUID) then return player._GUID end
    player._GUID = UnitGUID('player')
    return player._GUID
end

function BHelper.player:name()
    if (player._name) then return player._name end
    player._name = UnitName('player')
    return player._name
end

function BHelper.player:class()
    if (player._class) then return player._class end
    player._class = select(2, UnitClass('player')):lower()
    return player._class
end

function BHelper.player:spec()
    return (GetActiveTalentGroup()) or 1
end

function BHelper.player:level()
    return (UnitLevel('player')) or 1
end

function BHelper.player:alive()
    return (not UnitIsDeadOrGhost('player')) and true or false
end

function BHelper.player:on_combat()
    return (UnitAffectingCombat('player')) and true or false
end

function BHelper.player:moving()
    return (GetUnitSpeed('player') > 0) and true or false
end

function BHelper.player:has_control()
    return (HasFullControl()) and true or false
end

function BHelper.player:health()
    return UnitHealth('player') or 0
end

function BHelper.player:mana()
    return UnitMana('player') or 0
end

function BHelper.player:health_max()
    return UnitHealthMax('player') or 0
end

function BHelper.player:mana_max()
    return UnitManaMax('player') or 0
end

function BHelper.player:health_on_percent()
    return player:health() / player:health_max() * 100
end

function BHelper.player:mana_on_percent()
    return player:mana() / player:mana_max() * 100
end

function BHelper.player:power()
    return UnitPower('player') or 0
end

function BHelper.player:power_max()
    return UnitPowerMax('player') or 0
end

function BHelper.player:has_combo_points(count)
    return (GetComboPoints('player', 'target') >= count)
end

function BHelper.player:can_target_attack()
    if (not player:alive()) then return false end
    if (not target:exist()) then return false end
    if (not target:alive()) then return false end
    if (not target:is_enemy()) then return false end

    if (target:aura('Спячка') > 0) then return false end
    if (target:aura('Смерч') > 0) then return false end
    if (target:aura('Превращение') > 0) then return false end
    if (target:aura('Страх') > 0) then return false end
    if (target:aura('Ослепление') > 0) then return false end

    if (target:name() == 'Малый слизнюк') then return false end
    -- if (target:name() == 'Дарнаван') then return false end
    -- if (target:name() == 'Большой слизнюк') then return false end
    -- if (target:name() == 'Темное ядро') then return false end
    -- if (((target:name() == 'Принц Валанар') or
    --     (target:name() == 'Принц Келесет') or
    --     (target:name() == 'Принц Талдарам')) and (target:health() == 1) and
    --     (player:aura('Перенаправление') == 0)) then return false end

    return true
end

function BHelper.player:aura(aura, cast_by_player)
    return auras:get('player', aura, cast_by_player)
end

function BHelper.player:aura_count(aura, cast_by_player)
    return select(2, auras:get('player', aura, cast_by_player))
end

function BHelper.player:can_cast(spellname, check_time)
    if (not player:alive()) then return false end
    if (not IsUsableSpell(spellname)) then return false end
    if (player:spell_is_targeting()) then return false end
    if (player:check_cast()) then return false end
    if (player:check_spell_cooldown(spellname, check_time)) then return false end
    if (not player:has_control()) then return false end
    if ((player:moving()) and (player:spell_casttime(spellname) > 0)) then return false end
    return true
end

function BHelper.player:can_cast_on_enemy(spellname, check_time)
    if (not player:can_cast(spellname, check_time)) then return false end
    if (not player:can_target_attack()) then return false end
    if (not player:check_spell_range(spellname)) then return false end
    return true
end

-- function BHelper.player:can_cast_on_friend(spellname, unit_id, check_time)
--     unit_id = unit_id or 'target'
--     if (not player:can_cast(spellname, check_time)) then return false end
--     if (not UnitExists(unit_id)) then return false end
--     if (UnitIsDeadOrGhost(unit_id)) then return false end
--     if (not UnitCanAssist('player', unit_id)) then return false end
--     if (not player:check_spell_range(spellname, unit_id)) then return false end
--     return true
-- end

function BHelper.player:can_cast_on_point(spellname, check_time)
    if (not player:can_cast(spellname, check_time)) then return false end
    if (not UnitExists('mouseover')) then return false end
    if (player:moving()) then return false end
    if (IsMouseButtonDown('RightButton')) then return false end
    if (IsMouseButtonDown('LeftButton')) then return false end
    if (IsMouseButtonDown('MiddleButton')) then return false end
    return true
end

function BHelper.player:spell_is_targeting()
    return (SpellIsTargeting()) and true or false
end

function BHelper.player:check_spell_range(spellname, unit_id)
    unit_id = unit_id or 'target'
    return (IsSpellInRange(spellname, unit_id) == 1) and true or false
end

function BHelper.player:spell_casttime(spellname)
    local castTime = select(7, GetSpellInfo(spellname))
    return (castTime > 0) and (castTime / 1000) or 0
end

function BHelper.player:spell_cooldown(spellname)
    local start, duration = GetSpellCooldown(spellname)
    if (not start) or (start == 0) then return 0 end
    return start + duration - GetTime() - 0.2
end

function BHelper.player:check_spell_cooldown(spellname, check_time)
    check_time = check_time or 0
    return (player:spell_cooldown(spellname) > check_time) and true or false
end

function BHelper.player:check_cast()
    local time = select(6, UnitCastingInfo('player'))
    if (time) then return (time / 1000 - GetTime() - 0.2 > 0) and true or false end
    local time = select(6, UnitChannelInfo('player'))
    if (time) then return (time / 1000 - GetTime() - 0.2 > 0) and true or false end
    return false
end

function BHelper.player:can_use_item(item)
    if (player:item_count(item) == 0) then return false end
    if (player:check_item_cooldown(item)) then return false end
    if (player:is_mounted()) then return false end
    if (not player:has_control()) then return false end
    return true
end

function BHelper.player:item_count(item)
    return GetItemCount(item)
end

function BHelper.player:check_item_cooldown(item)
    local start, duration = GetItemCooldown(item)
    if ((not start) or (start == 0)) then return false end
    return (start + duration - GetTime() - 0.2 > 0) and true or false
end

function BHelper.player:is_equipped_item(item)
    return (IsEquippedItem(item)) and true or false
end

function BHelper.player:equip_set(equip_name)
    return UseEquipmentSet(equip_name)
end

function BHelper.player:has_safety_threat(limit)
    limit = limit or 85

    if (not target:exist()) then return true end
    if (not player:in_party_or_raid()) then return true end
    if (not target:should_evade()) then return true end
    if (threat:get_tank_GUID() == player:GUID()) then return false end
    if ((threat:get_DD_GUID() == player:GUID()) and (threat:get_DD_threat() >= limit)) then return false end
    return true
end

function BHelper.player:has_stable_threat(limit)
    limit = limit or 80

    if (not target:exist()) then return true end
    if (not player:in_party_or_raid()) then return true end
    if (threat:get_tank_GUID() ~= player:GUID()) then return false end
    if (threat:get_DD_threat() >= limit) then return false end
    return true
end

function BHelper.player:has_heroism_buff()
    return ((player:aura('Героизм') > 0) or (player:aura('Жажда крови') > 0)) and true or false
end

function BHelper.player:is_burst()
    return ((player:has_heroism_buff()) or (target:is_boss())) and true or false
end

function BHelper.player:is_mounted()
    return IsMounted()
end

function BHelper.player:location_is_icc()
    return (GetCurrentMapAreaID() == 605) and true or false
end

function BHelper.player:in_party_or_raid()
    return ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) and true or false
end
