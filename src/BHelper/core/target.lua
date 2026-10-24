BHelper.target = {}

local auras = {}
local core = {}
local keybinds = {}
local macros = {}
local modules = {}
local pet = {}
local player = {}
local tables = {}
local target = {}
local threat = {}
local timers = {}

function BHelper.target:namespace_init()
    auras = BHelper.auras
    core = BHelper.core
    keybinds = BHelper.keybinds
    macros = BHelper.macros
    modules = BHelper.modules
    pet = BHelper.pet
    player = BHelper.player
    tables = BHelper.tables
    target = BHelper.target
    threat = BHelper.threat
    timers = BHelper.timers
end

function BHelper.target:exist()
    return (UnitExists('target')) and true or false
end

function BHelper.target:get_name()
    return target._name
end

function BHelper.target:alive()
    return (not UnitIsDeadOrGhost('target')) and true or false
end

function BHelper.target:on_combat()
    return (UnitAffectingCombat('target')) and true or false
end

function BHelper.target:moving()
    return (GetUnitSpeed('target') > 0) and true or false
end

function BHelper.target:get_health()
    return UnitHealth('target') or 0
end

function BHelper.target:get_mana()
    return UnitMana('target') or 0
end

function BHelper.target:get_health_max()
    return UnitHealthMax('target') or 0
end

function BHelper.target:get_mana_max()
    return UnitManaMax('target') or 0
end

function BHelper.target:get_health_on_percent()
    return UnitHealth('target') / UnitHealthMax('target') * 100
end

function BHelper.target:get_mana_on_percent()
    return UnitMana('target') / UnitManaMax('target') * 100
end

function BHelper.target:get_power()
    return UnitPower('target') or 0
end

function BHelper.target:get_power_max()
    return UnitPowerMax('target') or 0
end

function BHelper.target:aura(aura, cast_by_player)
    return auras:get('target', aura, cast_by_player)
end

function BHelper.target:aura_count(aura, cast_by_player)
    return select(2, auras:get('target', aura, cast_by_player))
end

function BHelper.target:is_enemy()
    return (UnitCanAttack('player', 'target')) and true or false
end

function BHelper.target:is_friend()
    return (UnitCanAssist('player', 'target')) and true or false
end

function BHelper.target:is_boss()
    return ((UnitClassification('target') == 'worldboss') or (UnitLevel('target') == -1)) and true or false
end

function BHelper.target:is_player()
    return (UnitIsPlayer('target')) and true or false
end

function BHelper.target:should_evade()
    if (string.find(target:get_name():lower(), 'манекен')) then return false end
    if (target:get_name() == 'Кровавая королева Лана\'тель') then return false end
    if (target:get_name() == 'Леди Смертный Шепот') then return false end
    return true
end

function BHelper.target:check_cast()
    return ((UnitCastingInfo('target')) or (UnitChannelInfo('target'))) and true or false
end

function BHelper.target:check_casting_spellname(spellname)
    return ((spellname == UnitCastingInfo('target')) or (spellname == UnitChannelInfo('target'))) and true or false
end

