BHelper.common = {}

function BHelper.common:reload()
    self:print('loaded ->', self.DB:get_profile_name(), self.DB().module_name, self.DB().action_name)
    self:global_macros()

    local module = self:get_module()
    if (module) then
        self.DB:reload()
        self.keybinds:unbind_all()
        self.macros:delete_all()
        module:_init()
        module:_macros()
    else
        self:set_module(self:get_player_class())
        self:reload()
    end
end

function BHelper.common:get_module()
    local module_name = self.DB().module_name
    if (rawget(self.modules, module_name)) then
        return self.modules[module_name]
    else
        return nil
    end
end

function BHelper.common:set_module(module_name)
    print()
    if ((rawget(self.modules, module_name)) and (self.DB().module_name ~= module_name)) then
        self:print('set_module -> ', module_name)
        self.DB().action_name = nil
        self.DB().module_name = module_name
        self:reload()
    end
end

function BHelper.common:get_action()
    local module = self:get_module()
    local profile_name = self.DB:get_profile_name()
    local action_name = self.DB().action_name

    if (module) then
        if ((module[profile_name]) and (module[profile_name][action_name])) then
            return module[profile_name][action_name]
        end
        if ((module['common']) and (module['common'][action_name])) then
            return module['common'][action_name]
        end
        return nil
    else
        return nil
    end
end

function BHelper.common:set_action(action_name)
    local module = self:get_module()
    local profile_name = self.DB:get_profile_name()
    if ((module) and (self.DB().action_name ~= action_name)) then
        if (((module[profile_name]) and (module[profile_name][action_name])) or
            ((module['common']) and (module['common'][action_name]))) then
            self:print('set_action -> ', action_name)
            self.DB().action_name = action_name
        end
        return nil
    else
        return nil
    end
end

function BHelper.common:set_var(var, value)
    if (self.DB:get_vars()[var] ~= nil) then self.DB:get_vars()[var] = value end
end

function BHelper.common:toggle_var(var)
    if (self.DB:get_vars()[var] ~= nil) then
        if (self.DB:get_vars()[var]) then
            self:print('var_toggle <', var, '>', false)
            self.DB:get_vars()[var] = false
        else
            self:print('var_toggle <', var, '>', true)
            self.DB:get_vars()[var] = true
        end
    end
end

function BHelper.common:toggle()
    if (self._runing) then
        self:stop()
    else
        self:start()
    end
end

function BHelper.common:start()
    -- print(self.DB().only_combat_start)
    -- print(self.vars._combat_state)
    -- print(self:enemy_in_combat())
    if ((self.DB().only_combat_start) and (not self.vars._combat_state) and
        (not self:enemy_in_combat())) then return end

    self:print('start')

    self.vars.cooldown_berserker = true
    self.timers:create(5, function()
        self.vars.cooldown_berserker = false
    end, 'cooldown_berserker')

    self._runing = true
    self.state_frame:Show()
end

function BHelper.common:stop()
    self:print('stop')
    self._runing = false
    self._cooldown = false
    self.state_frame:Hide()
    self.keybinds:show_macro('Stop', 0.1)
end

function BHelper.common:print(...)
    if (self._debug) then print('\124cffff00ffBHelper\124r', '->', ...) end
end

function BHelper.common:cooldown(count)
    self:print('cooldown <', count, '>')
    self._cooldown = true
    self.timers:create(count, function()
        self:print('cooldown < off >')
        self._cooldown = false
    end, 'cooldown')
end

function BHelper.common:global_macros()
    self.macros:delete_all(true)
    self.macros:create('Цель',
                       '/targetlasttarget [exists,harm,nodead]\n/target [@focustarget,harm,nodead]\n/targetenemy [@focus,noexists]\n/targetenemy [@focus,harm]',
                       0, true, 711)
    self.macros:create('Stop', '/stopcasting\n/stopattack\n/petfollow\n/cleartarget', 0, true)
    self.macros:create('Аук', '/s .i au', 60, true, 1935)
    self.macros:create('Банк', '/s .i b', 59, true, 1933)
    self.macros:create('Почта', '/s .i m', 58, true, 1931)
    self.macros:create('Магазин', '/s .i v', 57, true, 1929)
    self.macros:create('Воскрешение', '/s .i massrevive', 56, true, 1927)
    self.macros:create('Макросы', '/macro', 55, true, 1123)
    self.macros:create('Тренер', '/s .i t', 0, true, 1930)
    self.macros:create('Roll', '/roll', 52, true, 1836)
    self.macros:create('Reload', '/reload', 49, true, 1838)
    self.macros:create('Focus', '/focus', 53, true, 921)
    self.macros:create('Баджи',
                       '/script local function buy (n,q) for i=1,100 do if n==GetMerchantItemInfo(i) then BuyMerchantItem(i,q) end end end buy (\'Эмблема героизма\',80)',
                       0, true, 1374)

    self.macros:create('S', '/startattack\n/bh sa rotation_single\n/bh', 13, true, 1263)
    self.macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh', 14, true, 1264)
end

function BHelper.common:get_player_name()
    if (self.vars._player.name) then return self.vars._player.name end
    self.vars._player.name = (select(1, UnitName('player')))
    return self.vars._player.name
end

function BHelper.common:get_player_class()
    if (self.vars._player.class) then return self.vars._player.class end

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

    self.vars._player.class = (select(2, UnitClass('player'))):lower()
    return self.vars._player.class
end

function BHelper.common:get_player_spec()
    return GetSpecialization('player')
end

function BHelper.common:get_player_level()
    return UnitLevel('player')
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
    local start, duration = GetSpellCooldown(spellname)
    return (start + duration - GetTime() - 0.2 > 0) and true or false
end

function BHelper.common:is_item_cooldown(item)
    local start, duration = GetItemCooldown(item)
    return (start + duration - GetTime() - 0.2 > 0) and true or false
end

function BHelper.common:is_player_cast()
    local _, _, _, _, _, endTime = UnitCastingInfo('player')
    if (endTime) then return (endTime / 1000 - GetTime() - 0.2 > 0) and true or false end

    local _, _, _, _, _, endTime = UnitChannelInfo('player')
    if (endTime) then return (endTime / 1000 - GetTime() - 0.2 > 0) and true or false end

    return false
end

function BHelper.common:is_enemy_cast()
    if (UnitCastingInfo('target')) then return true end
    if (UnitChannelInfo('target')) then return true end
end

function BHelper.common:enemy_in_combat()
    if (UnitCanAttack('player', 'target') ~= 1) then return false end
    if (UnitCanAttack('target', 'targettarget') == 1) then return true end
    if (UnitAffectingCombat('target') ~= nil) then return true end
    return false
end

function BHelper.common:can_use_item(item)
    if (self:get_item_count(item) == 0) then return false end
    if (self:is_item_cooldown(item)) then return false end
    return true
end

function BHelper.common:is_equipped_item(item)
    if (not IsEquippedItem(item)) then return false end
    return true
end

function BHelper.common:get_item_count(item)
    return GetItemCount(item)
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
    if (not self:can_attack()) then return false end
    if (IsSpellInRange(spellname, 'target') ~= 1) then return false end
    return true
end

function BHelper.common:can_cast_on_point(spellname)
    if (not self:can_cast(spellname)) then return false end
    if (UnitExists('mouseover') ~= 1) then return false end
    return true
end

function BHelper.common:can_attack()
    if (UnitCanAttack('player', 'target') ~= 1) then return false end
    if (self:get_ememy_debuff_time('Спячка') > 0) then return false end
    if (self:get_ememy_debuff_time('Смерч') > 0) then return false end
    if (self:get_ememy_debuff_time('Превращение') > 0) then return false end
    if (self:get_ememy_debuff_time('Страх') > 0) then return false end
    if (self:get_ememy_debuff_time('Ослепление') > 0) then return false end
    return true
end

function BHelper.common:get_combat_state()
    return self._combat_state
end

function BHelper.common:is_player_moving()
    if (GetUnitSpeed('player') > 0) then return true end
    return false
end

function BHelper.common:player_is_target()
    if (UnitName("playertargettarget") == self.vars.player_name) then
        return true
    else
        return false
    end
end

function BHelper.common:is_player_hight_treat() -- has
    local threat = (select(3, UnitDetailedThreatSituation('player', 'target')))

    if ((threat ~= nil) and (threat >= 100)) then
        return true
    else
        return false
    end
end

function BHelper.common:target_is_boss()
    if ((UnitClassification('target') == 'worldboss') or UnitLevel('target') == -1) then
        return true
    end
    return false
end

function BHelper.common:target_is_player()
    if (UnitIsPlayer('target')) then return true end
    return false
end

function BHelper.common:exist_heroism_buff()
    if (self:get_player_buff_time('Героизм') > 0) then return true end
    if (self:get_player_buff_time('Жажда крови') > 0) then return true end
    return false
end

function BHelper.common:is_burst_mode()
    if (self:exist_heroism_buff()) then return true end
    if (self:target_is_boss()) then return true end
    return false
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

function BHelper.common:get_player_debuff_time(spell, player)
    player = player or false
    for i = 1, 40 do
        local name, _, _, _, _, _, expirationTime, unitCaster, _, _, spellId = UnitDebuff('player',
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

function BHelper.common:get_player_debuff_count(spell, player)
    player = player or false
    for i = 1, 40 do
        local name, _, _, count, _, _, _, unitCaster, _, _, spellId = UnitDebuff('player', i)
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

function BHelper.common:init()
    setmetatable(BHelper, {__index = BHelper.common})
end
BHelper.common:init()
