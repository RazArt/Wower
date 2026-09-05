BHelper.core = {}
BHelper.core.module = {}
BHelper.core.profile = {}
BHelper.core.action = {}
BHelper.player = {}
BHelper.pet = {}
BHelper.target = {}

function BHelper.core:start()
    if ((BHelper.core.profile:get().settings.only_combat_start) and
        (not BHelper.player:check_combat_state()) and (not BHelper.target:enemy_on_combat())) then
        return
    end

    BHelper.vars.cooldown_berserker = true
    BHelper.timers:create(5, function()
        BHelper.vars.cooldown_berserker = false
    end, 'cooldown_berserker')

    BHelper._runing = true
    BHelper.state_frame:Show()
end

function BHelper.core:stop()
    BHelper._runing = false
    BHelper._cooldown = false
    BHelper.vars.cooldown_berserker = false

    BHelper.state_frame:Hide()

    BHelper.keybinds:show_macro('Stop', 0.1)
    if (BHelper.pet:check_control()) then BHelper.keybinds:show_pet('Follow', 0.1) end
end

function BHelper.core:toggle()
    if (BHelper._runing) then
        BHelper.core:stop()
    else
        BHelper.core:start()
    end
end

function BHelper.core:init_DB()
    if ((not BHelperDB) or (type(BHelperDB) ~= 'table')) then BHelperDB = {} end
    if ((not BHelperDB[BHelper.player:get_spec()]) or
        (type(BHelperDB[BHelper.player:get_spec()]) ~= 'table')) then
        BHelperDB[BHelper.player:get_spec()] = {}
    end
end

function BHelper.core:reload()
    BHelper.core:init_DB()

    local module = BHelper.core.module:get()
    if (not module) then
        BHelper.core.module:set()
        return false
    end

    local profile = BHelper.core.profile:get()
    if (not profile) then
        BHelper.core.profile:set()
        return false
    end

    BHelper.core:print('loaded ->', BHelper.core.module:get_name(), BHelper.core.profile:get_name())

    BHelper.keybinds:unbind_all()
    BHelper.macros:delete_all()
    BHelper.core:create_shared_macros()

    local player_spec = BHelper.player:get_spec()
    local module_name = BHelper.core.module:get_name()
    local profile_name = BHelper.core.profile:get_name()

    if (not BHelperDB[player_spec]['modules']) then BHelperDB[player_spec]['modules'] = {} end
    if (not BHelperDB[player_spec]['modules'][module_name]) then
        BHelperDB[player_spec]['modules'][module_name] = {}
    end
    if (not BHelperDB[player_spec]['modules'][module_name][profile_name]) then
        BHelperDB[player_spec]['modules'][module_name][profile_name] = {}
    end
    if (not BHelperDB[player_spec]['modules'][module_name][profile_name].vars) then
        BHelperDB[player_spec]['modules'][module_name][profile_name].vars = {}
    end
    if (not BHelperDB[player_spec]['modules'][module_name][profile_name].settings) then
        BHelperDB[player_spec]['modules'][module_name][profile_name].settings = {}
    end

    profile.vars = BHelperDB[player_spec]['modules'][module_name][profile_name].vars
    profile.settings = BHelperDB[player_spec]['modules'][module_name][profile_name].settings

    module:_init()
    module:_macros()
end

function BHelper.core.module:get()
    local name = BHelper.core.module:get_name()
    if (BHelper.core.module:exist(name)) then return BHelper.modules[name] end
    return nil
end

function BHelper.core.module:set(name)
    name = name or BHelper.player:get_class()
    name = string.lower(name)
    if ((BHelper.core.module:exist(name)) and (BHelper.core.module:get_name() ~= name)) then
        BHelper.core:print('set_module -> ', name)
        local player_spec = BHelper.player:get_spec()
        BHelperDB[player_spec].module_name = name
        BHelperDB[player_spec].profile_name = nil
        BHelperDB[player_spec].action_name = nil
        BHelper.core:reload()
        return true
    end
    return false
end

function BHelper.core.module:get_name()
    return BHelperDB[BHelper.player:get_spec()].module_name
end

function BHelper.core.module:exist(name)
    name = name or ''
    if (rawget(BHelper.modules, string.lower(name))) then return true end
    return false
end

function BHelper.core.profile:get()
    local name = BHelper.core.profile:get_name()
    if (BHelper.core.profile:exist(name)) then return BHelper.core.module:get()[name] end
    return nil
end

function BHelper.core.profile:set(name)
    name = name or 'default'
    name = string.lower(name)
    if ((BHelper.core.profile:exist(name)) and (BHelper.core.profile:get_name() ~= name)) then
        BHelper.core:print('set_profile -> ', name)
        local player_spec = BHelper.player:get_spec()
        BHelperDB[player_spec].profile_name = name
        BHelperDB[player_spec].action_name = nil
        BHelper.core:reload()
        return true
    end
    return false
end

function BHelper.core.profile:get_name()
    return BHelperDB[BHelper.player:get_spec()].profile_name
end

function BHelper.core.profile:exist(name)
    name = name or ''
    if (rawget(BHelper.core.module:get(), string.lower(name))) then return true end
    return false
end

function BHelper.core.action:get()
    local name = BHelper.core.action:get_name()
    if (BHelper.core.action:exist(name)) then return BHelper.core.profile:get()[name] end
    return nil
end

function BHelper.core.action:set(name)
    name = name or 'default'
    name = string.lower(name)
    if ((BHelper.core.action:exist(name)) and (BHelper.core.action:get_name() ~= name)) then
        BHelper.core:print('set_action -> ', name)
        BHelperDB[BHelper.player:get_spec()].action_name = name
        return true
    end
    return false
end

function BHelper.core.action:get_name()
    return BHelperDB[BHelper.player:get_spec()].action_name
end

function BHelper.core.action:exist(name)
    name = name or ''
    if (rawget(BHelper.core.profile:get(), string.lower(name))) then return true end
    return false
end

function BHelper.core:set_var(var, value)
    local vars = BHelper.core.profile:get().vars
    if (vars[var] ~= nil) then vars[var] = value end
end

function BHelper.core:toggle_var(var)
    local vars = BHelper.core.profile:get().vars
    if (vars[var] ~= nil) then
        if (vars[var]) then
            BHelper.core:print('var_toggle <', var, '>', false)
            vars[var] = false
        else
            BHelper.core:print('var_toggle <', var, '>', true)
            vars[var] = true
        end
    end
end

function BHelper.core:cooldown(count)
    -- BHelper.core:print('cooldown <', count, '>')
    BHelper._cooldown = true
    BHelper.timers:create(count, function()
        -- BHelper.core:print('cooldown < off >')
        BHelper._cooldown = false
    end, 'cooldown')
end

function BHelper.core:print(...)
    if (BHelper._debug) then print('\124cffff00ffBHelper\124r', '->', ...) end
end

function BHelper.core:create_shared_macros()
    BHelper.macros:create('PetAttack', '/petattack [@target]', 19, 973)
    BHelper.macros:create('PetFollow', '/petfollow', 20, 970)
    BHelper.macros:create('Target', '/targetenemy\n/startattack\n/bh c', 0, 711)
    BHelper.macros:create('Stop', '/stopcasting\n/stopattack\n/cleartarget', 0)
    BHelper.macros:create('Аук', '/s .i au', 60, 1935)
    BHelper.macros:create('Банк', '/s .i b', 59, 1933)
    BHelper.macros:create('Почта', '/s .i m', 58, 1931)
    BHelper.macros:create('Магазин', '/s .i v', 57, 1929)
    BHelper.macros:create('Воскрешение', '/s .i massrevive', 56, 1927)
    BHelper.macros:create('Макросы', '/macro', 55, 1123)
    BHelper.macros:create('Тренер', '/s .i t', 0, 1930)
    BHelper.macros:create('Roll', '/roll', 52, 1836)
    BHelper.macros:create('Reload', '/reload', 49, 1838)
    BHelper.macros:create('Focus', '/focus', 53, 921)
    BHelper.macros:create('Баджи',
                          '/script local function buy (n,q) for i=1,100 do if n==GetMerchantItemInfo(i) then BuyMerchantItem(i,q) end end end buy (\'Эмблема героизма\',80)',
                          0, 1374)

    BHelper.macros:create('S', '/startattack\n/bh sa rotation_single\n/bh', 13, 1263)
    BHelper.macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh', 14, 1264)
end

function BHelper.player:get_name()
    if (BHelper.vars._player.name) then return BHelper.vars._player.name end
    BHelper.vars._player.name = (select(1, UnitName('player')))
    return BHelper.vars._player.name
end

function BHelper.player:get_class()
    if (BHelper.vars._player.class) then return BHelper.vars._player.class end

    local classes = {
        warrior = '1',
        paladin = '2',
        hunter = '3',
        rogue = '4',
        priest = '5',
        deathknight = '6',
        shaman = '7',
        mage = '8',
        warlock = '9',
        druid = '11'
    }

    BHelper.vars._player.class = (select(2, UnitClass('player'))):lower()
    return BHelper.vars._player.class
end

function BHelper.player:get_spec() -- Add cache
    return GetSpecialization('player') or 1
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

function BHelper.player:get_buff_time(spell, is_player_caster)
    return (select(1, BHelper:_get_aura_info('player', 'buff', spell, is_player_caster)))
end

function BHelper.player:get_debuff_time(spell, is_player_caster)
    return (select(1, BHelper:_get_aura_info('player', 'debuff', spell, is_player_caster)))
end

function BHelper.player:get_buff_count(spell, is_player_caster)
    return (select(2, BHelper:_get_aura_info('player', 'buff', spell, is_player_caster)))
end

function BHelper.player:get_debuff_count(spell, is_player_caster)
    return (select(2, BHelper:_get_aura_info('player', 'debuff', spell, is_player_caster)))
end

function BHelper.player:check_combo_points(count)
    return (GetComboPoints('player', 'target') >= count)
end

function BHelper.player:can_use_item(item)
    if (BHelper.player:get_item_count(item) == 0) then return false end
    if (BHelper.player:check_item_on_cooldown(item)) then return false end
    if (IsMounted()) then return false end
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
    if (not (select(1, IsUsableSpell(spellname)))) then return false end
    if (BHelper.player:spell_is_targeting()) then return false end
    if (BHelper.player:check_cast()) then return false end
    if (BHelper.player:check_spell_on_cooldown(spellname, check_time)) then return false end
    if (IsMounted()) then return false end
    if (not HasFullControl()) then return false end
    return true
end

function BHelper.player:can_cast_on_enemy(spellname, check_time)
    if (not BHelper.player:can_cast(spellname, check_time)) then return false end
    if (not BHelper.player:can_target_attack()) then return false end
    if (not BHelper.player:check_spell_range(spellname)) then return false end
    return true
end

function BHelper.player:can_cast_on_point(spellname, check_time)
    if (not BHelper.player:can_cast(spellname, check_time)) then return false end
    if (not UnitExists('mouseover')) then return false end
    if (IsMouseButtonDown('RightButton')) then return false end
    return true
end

function BHelper.player:can_target_attack()
    if (not UnitExists('target')) then return false end
    if (UnitIsDeadOrGhost('target')) then return false end
    if (UnitIsDeadOrGhost('player')) then return false end
    if (not UnitCanAttack('player', 'target')) then return false end

    if (BHelper.target:get_debuff_time('Спячка') > 0) then return false end
    if (BHelper.target:get_debuff_time('Смерч') > 0) then return false end
    if (BHelper.target:get_debuff_time('Превращение') > 0) then return false end
    if (BHelper.target:get_debuff_time('Страх') > 0) then return false end
    if (BHelper.target:get_debuff_time('Ослепление') > 0) then return false end

    local target_name = BHelper.target:get_name()
    if (target_name == 'Дарнаван') then return false end
    if (target_name == 'Большой слизнюк') then return false end
    if (target_name == 'Малый слизнюк') then return false end
    if (target_name == 'Темное ядро') then return false end
    if (((target_name == 'Принц Валанар') or
        (target_name == 'Принц Келесет') or
        (target_name == 'Принц Талдарам')) and (BHelper.target:get_health() == 1) and
        (BHelper.player:get_buff_time('Перенаправление') == 0)) then return false end

    return true
end

function BHelper.player:spell_is_targeting()
    if (not SpellIsTargeting()) then return false end
    return true
end

function BHelper.player:check_spell_range(spellname)
    if (IsSpellInRange(spellname, 'target') ~= 1) then return false end
    return true
end

function BHelper.player:get_spell_casttime(spellname)
    local castTime = (select(7, GetSpellInfo(spellname)))
    return (castTime > 0) and (castTime / 1000) or 0
end

function BHelper.player:get_spell_cooldown(spellname)
    local start, duration = GetSpellCooldown(spellname)
    return start + duration - GetTime() - 0.2
end

function BHelper.player:check_spell_on_cooldown(spellname, check_time)
    check_time = check_time or 0.2
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

function BHelper.player:check_moving()
    if (GetUnitSpeed('player') > 0) then return true end
    return false
end

function BHelper.player:check_hight_treat()
    if (not BHelper.target:should_evade()) then return false end

    local treat_level = UnitThreatSituation('player', 'target')
    if ((treat_level) and (treat_level > 0)) then return true end
    return false
end

function BHelper.player:check_heroism_buff()
    if (BHelper.player:get_buff_time('Героизм') > 0) then return true end
    if (BHelper.player:get_buff_time('Жажда крови') > 0) then return true end
    return false
end

function BHelper.player:check_burst_mode()
    if (BHelper.player:check_heroism_buff()) then return true end
    if (BHelper.target:is_boss()) then return true end
    return false
end

function BHelper.player:help_focus_exist()
    if (not UnitExists('focus')) then return false end
    if (UnitIsDeadOrGhost('focus')) then return false end
    if (not UnitCanAssist('player', 'focus')) then return false end
    return true
end

function BHelper.player:check_focus_treat()
    local treat_level = UnitThreatSituation('focus', 'target')
    print(treat_level)
    if ((treat_level) and (treat_level < 3)) then return true end
    return false
end

function BHelper.pet:can_target_attack()
    if (not BHelper.player:can_target_attack()) then return false end
    if (UnitIsUnit('pettarget', 'target')) then return false end

    local target_name = BHelper.target:get_name()
    if (target_name == 'Ледяная сфера') then return false end
    if (target_name == 'Ледяной шар') then return false end
    if (target_name == 'Зловещий дух') then return false end
    if (target_name == 'Волдырный зомби') then return false end
    if ((target_name == 'Имирьярская повелительница льда') and
        (BHelper.target:get_buff_time('Арктический холод') > 0)) then
        return false
    end

    return true
end

function BHelper.pet:check_control()
    if (not UnitExists('pet')) then return false end
    if (UnitIsDeadOrGhost('pet')) then return false end
    if (((select(1, UnitName('pet'))) == 'Вепрь')) then return false end
    return BHelper.core.profile:get().vars.pet_control
end

function BHelper.target:get_name()
    return (select(1, UnitName('target'))) or ''
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
    if ((UnitClassification('target') == 'worldboss') or UnitLevel('target') == -1) then
        return true
    end
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
    if (BHelper.target:get_name() == 'Кровавая королева Лана\'тель') then
        return false
    end
    if (BHelper.target:get_name() == 'Леди Смертный Шепот') then return false end
    return true
end

function BHelper.target:get_buff_time(spell, is_player_caster)
    return (select(1, BHelper:_get_aura_info('target', 'buff', spell, is_player_caster)))
end

function BHelper.target:get_debuff_time(spell, is_player_caster)
    return (select(1, BHelper:_get_aura_info('target', 'debuff', spell, is_player_caster)))
end

function BHelper.target:get_buff_count(spell, is_player_caster)
    return (select(2, BHelper:_get_aura_info('target', 'buff', spell, is_player_caster)))
end

function BHelper.target:get_debuff_count(spell, is_player_caster)
    return (select(2, BHelper:_get_aura_info('target', 'debuff', spell, is_player_caster)))
end

function BHelper.target:check_cast()
    if (UnitCastingInfo('target')) then return true end
    if (UnitChannelInfo('target')) then return true end
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

function BHelper:_get_aura_info(unit, class, spell, is_player_caster)
    unit = string.lower(unit)
    class = string.lower(class)
    if (type(spell) == 'string') then spell = string.lower(spell) end
    is_player_caster = is_player_caster or false

    local filter = class == 'buff' and 'HELPFUL' or 'HARMFUL'
    if (is_player_caster) then filter = filter .. '|PLAYER' end

    for i = 1, 200 do
        local name, _, _, count, _, _, expiration_time, _, _, _, spell_id =
            UnitAura(unit, i, filter)
        if (name == nil) then break end
        name = string.lower(name)
        if (((type(spell) == 'string') and (spell == name)) or
            ((type(spell) == 'number') and (spell == spell_id))) then
            if (expiration_time == 0) then
                expiration_time = 99999
            elseif (expiration_time == nil) then
                expiration_time = 0
            else
                expiration_time = expiration_time - GetTime()
            end
            return expiration_time, count
        end
    end
    return 0, 0
end

function BHelper:get_bag_free_slots()
    local free_slots_count = 0
    for bag_num = 0, 4 do
        free_slots_count = free_slots_count + (select(1, GetContainerNumFreeSlots(bag_num)))
    end
    return free_slots_count
end
