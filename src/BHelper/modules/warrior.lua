function BHelper.modules.warrior.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.attack_type == nil) then self.vars.attack_type = '1' end
    if (self.vars.battle_shout == nil) then self.vars.battle_shout = false end
    if (self.vars.commanding_shout == nil) then self.vars.commanding_shout = false end
    if (self.vars.demoralizing_shout == nil) then self.vars.demoralizing_shout = false end
    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Удар героя')
    BHelper.keybinds:bind_spell('Рассекающий удар')
    BHelper.keybinds:bind_spell('Безудержное восстановление')
    BHelper.keybinds:bind_spell('Деморализующий крик')
    BHelper.keybinds:bind_spell('Боевой крик')
    BHelper.keybinds:bind_spell('Командирский крик')
    BHelper.keybinds:bind_spell('Зуботычина')
    BHelper.keybinds:bind_spell('Ярость берсерка')
    BHelper.keybinds:bind_spell('Кровавая ярость')
    BHelper.keybinds:bind_spell('Раскол брони')
    BHelper.keybinds:bind_spell('Кровожадность')
    BHelper.keybinds:bind_spell('Мощный удар')
    BHelper.keybinds:bind_spell('Вихрь')
    BHelper.keybinds:bind_spell('Казнь')
    BHelper.keybinds:bind_spell('Безрассудство')
    BHelper.keybinds:bind_spell('Жажда смерти')
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')
    BHelper.keybinds:bind_item('Душители Плети')

    BHelper.core.action:set('rotation')
end

function BHelper.modules.warrior.default:macros()
    BHelper.macros:create('Деморализующий крикTV',
                          '#showtooltip Деморализующий крик\n/bh tv demoralizing_shout', 41)
    BHelper.macros:create('Боевой крикTV', '#showtooltip Боевой крик\n/bh tv battle_shout', 42)
    BHelper.macros:create('Командирский крикTV',
                          '#showtooltip Командирский крик\n/bh tv commanding_shout', 43)
    BHelper.macros:create('ЗуботычинаTV', '#showtooltip Зуботычина\n/bh tv silence', 44)
    BHelper.macros:create('Берсерк(Расовая)', '#showtooltip\n/bh c\n/cast Берсерк(Расовая)',
                          93)
    BHelper.macros:create('Жажда смерти', '#showtooltip\n/bh c\n/cast Жажда смерти', 94)
    BHelper.macros:create('Безрассудство', '#showtooltip\n/bh c\n/cast Безрассудство', 95)
    BHelper.macros:create('Возмездие',
                          '#showtooltip Возмездие\n/bh c\n/cast [stance:2/3] Боевая стойка\n/cast [stance:1] Возмездие',
                          96)
    BHelper.macros:create('Рывок',
                          '#showtooltip\n/bh c\n/cast [noharm]Вмешательство;[stance:2]Рывок;Перехват',
                          15)

    BHelper.macros:create('S', '/startattack\n/bh sv attack_type 1\n/bh', 13, 1263)
    BHelper.macros:create('M', '/startattack\n/bh sv attack_type 2\n/bh', 14, 1264)
end

function BHelper.modules.warrior.default:rotation()
    if (self.vars.attack_type == '1') then
        if (BHelper.player:can_cast('Удар героя')) then
            BHelper.keybinds:show_attack('Удар героя')
        end
    elseif (self.vars.attack_type == '2') then
        if (BHelper.player:can_cast('Рассекающий удар')) then
            BHelper.keybinds:show_attack('Рассекающий удар')
        end
    end

    if ((BHelper.player:get_health_on_percent() < 30) and
        BHelper.player:can_cast('Безудержное восстановление')) then
        return BHelper.keybinds:show_spell('Безудержное восстановление')
    end

    if ((BHelper.auras:target('Деморализующий крик') == 0) and (self.vars.demoralizing_shout) and
        (BHelper.player:can_cast('Деморализующий крик'))) then
        return BHelper.keybinds:show_spell('Деморализующий крик')
    end

    if ((BHelper.auras:player('Боевой крик') == 0) and
        (BHelper.auras:player('Благословение могущества') == 0) and
        (BHelper.auras:player('Великое благословение могущества') == 0) and
        (self.vars.battle_shout) and (BHelper.player:can_cast('Боевой крик'))) then
        return BHelper.keybinds:show_spell('Боевой крик')
    end

    if ((BHelper.auras:player('Командирский крик') == 0) and (self.vars.commanding_shout) and
        (BHelper.player:can_cast('Командирский крик'))) then
        return BHelper.keybinds:show_spell('Командирский крик')
    end

    if (BHelper.target:check_cast() and (self.vars.silence) and BHelper.player:can_cast_on_enemy('Зуботычина')) then
        return BHelper.keybinds:show_spell('Зуботычина')
    end

    if ((BHelper.player:get_power() <= 30) and (BHelper.player:can_cast('Ярость берсерка'))) then
        return BHelper.keybinds:show_spell('Ярость берсерка')
    end

    if ((BHelper.player:get_power() <= 30) and (BHelper.player:can_cast('Кровавая ярость'))) then
        return BHelper.keybinds:show_spell('Кровавая ярость')
    end

    if ((BHelper.player:check_burst_mode()) and (not BHelper.vars.cooldown_berserker)) then
        if ((BHelper.player:can_cast('Безрассудство'))) then
            return BHelper.keybinds:show_spell('Безрассудство')
        end

        if ((BHelper.player:can_cast('Жажда смерти'))) then
            return BHelper.keybinds:show_spell('Жажда смерти')
        end

        if (BHelper.player:can_cast('Берсерк(Расовая)')) then
            return BHelper.keybinds:show_spell('Берсерк(Расовая)')
        end
    end

    if ((BHelper.player:check_equipped_item('Душители Плети')) and
        (BHelper.player:can_use_item('Душители Плети'))) then
        BHelper.keybinds:show_item('Душители Плети')
    end

    if (BHelper.player:can_cast_on_enemy('Кровожадность')) then
        return BHelper.keybinds:show_spell('Кровожадность')
    end

    if ((not BHelper.player:can_cast_on_enemy('Кровожадность', 1)) and
        (BHelper.auras:player('Сокрушить!') > 0) and
        (BHelper.player:can_cast_on_enemy('Мощный удар'))) then
        return BHelper.keybinds:show_spell('Мощный удар')
    end

    if ((BHelper.target:get_name() ~= 'Принц Келесет') and (BHelper.player:can_cast('Вихрь'))) then
        return BHelper.keybinds:show_spell('Вихрь')
    end

    if ((not BHelper.player:can_cast_on_enemy('Кровожадность', 1)) and
        (BHelper.player:can_cast_on_enemy('Казнь'))) then return BHelper.keybinds:show_spell('Казнь') end

    if ((not BHelper.player:can_cast_on_enemy('Кровожадность', 1)) and
        ((BHelper.auras:target('Раскол брони') <= 5) or
            (BHelper.target:get_aura_count('Раскол брони') < 5)) and
        (BHelper.player:can_cast_on_enemy('Раскол брони'))) then
        return BHelper.keybinds:show_spell('Раскол брони')
    end
end

function BHelper.modules.warrior.proto:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.attack_type == nil) then self.vars.attack_type = '1' end
    if (self.vars.battle_shout == nil) then self.vars.battle_shout = false end
    if (self.vars.commanding_shout == nil) then self.vars.commanding_shout = false end
    if (self.vars.demoralizing_shout == nil) then self.vars.demoralizing_shout = false end
    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Удар героя')
    BHelper.keybinds:bind_spell('Рассекающий удар')
    BHelper.keybinds:bind_spell('Безудержное восстановление')
    BHelper.keybinds:bind_spell('Деморализующий крик')
    BHelper.keybinds:bind_spell('Боевой крик')
    BHelper.keybinds:bind_spell('Командирский крик')
    BHelper.keybinds:bind_spell('Удар щитом')
    BHelper.keybinds:bind_spell('Ярость берсерка')
    BHelper.keybinds:bind_spell('Кровавая ярость')
    BHelper.keybinds:bind_spell('Дразнящий удар')
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')

    BHelper.keybinds:bind_spell('Героический бросок')
    BHelper.keybinds:bind_spell('Героический бросок', 'BUTTON5')
    BHelper.keybinds:bind_spell('Мощный удар щитом')
    BHelper.keybinds:bind_spell('Реванш')
    BHelper.keybinds:bind_spell('Удар грома')
    BHelper.keybinds:bind_spell('Сокрушение')
    BHelper.keybinds:bind_spell('Ударная волна')

    BHelper.keybinds:bind_spell('Глухая оборона')
    BHelper.keybinds:bind_spell('Ни шагу назад')
    BHelper.keybinds:bind_spell('Блок щитом')
    BHelper.keybinds:bind_spell('Отражение заклинания')

    BHelper.core.action:set('rotation')
end

function BHelper.modules.warrior.proto:macros()
    BHelper.macros:create('Удар щитомTV', '#showtooltip Удар щитом\n/bh tv silence', 41)
    BHelper.macros:create('Командирский крикTV',
                          '#showtooltip Командирский крик\n/bh tv commanding_shout', 42)
    BHelper.macros:create('Рывок',
                          '#showtooltip\n/bh c\n/cast [noharm]Вмешательство;Рывок;Перехват',
                          15)
    BHelper.macros:create('Провокация',
                          '#showtooltip\n/bh c\n/cast Провокация\n/cast Дразнящий удар', 16)
    BHelper.macros:create('Возмездие',
                          '#showtooltip Возмездие\n/bh c\n/cast [stance:2/3] Боевая стойка\n/cast [stance:1] Возмездие',
                          24)

    BHelper.macros:create('Глухая оборона', '#showtooltip\n/bh c\n/cast Глухая оборона', 79)
    BHelper.macros:create('Ни шагу назад', '#showtooltip\n/bh c\n/cast Ни шагу назад', 80)
    BHelper.macros:create('Блок щитом', '#showtooltip\n/bh c\n/cast Блок щитом', 81)
    BHelper.macros:create('Отражение заклинания',
                          '#showtooltip\n/bh c\n/cast Отражение заклинания', 82)

    BHelper.macros:create('S', '/startattack\n/bh sv attack_type 1\n/bh', 13, 1263)
    BHelper.macros:create('M', '/startattack\n/bh sv attack_type 2\n/bh', 14, 1264)
end

function BHelper.modules.warrior.proto:rotation()
    if ((self.vars.attack_type == '1') and (BHelper.player:get_power() >= 20) and
        (BHelper.player:can_cast('Удар героя'))) then
        BHelper.keybinds:show_attack('Удар героя')
    elseif ((self.vars.attack_type == '2') and (BHelper.player:get_power() >= 30) and
        (BHelper.player:can_cast('Рассекающий удар'))) then
        BHelper.keybinds:show_attack('Рассекающий удар')
    end

    if ((BHelper.player:get_health_on_percent() < 10) and BHelper.player:can_cast('Глухая оборона')) then
        return BHelper.keybinds:show_spell('Глухая оборона')
    end

    if ((BHelper.player:get_health_on_percent() < 20) and
        BHelper.player:can_cast('Безудержное восстановление')) then
        return BHelper.keybinds:show_spell('Безудержное восстановление')
    end

    if ((BHelper.player:get_health_on_percent() < 20) and BHelper.player:can_cast('Ни шагу назад')) then
        return BHelper.keybinds:show_spell('Ни шагу назад')
    end

    if (BHelper.target:check_cast() and (self.vars.silence) and BHelper.player:can_cast_on_enemy('Удар щитом')) then
        return BHelper.keybinds:show_spell('Удар щитом')
    end

    if ((BHelper.player:get_power() <= 30) and (BHelper.player:can_cast('Ярость берсерка'))) then
        return BHelper.keybinds:show_spell('Ярость берсерка')
    end

    if ((BHelper.player:get_power() <= 30) and (BHelper.player:can_cast('Кровавая ярость'))) then
        return BHelper.keybinds:show_spell('Кровавая ярость')
    end

    if ((self.vars.attack_type == '1') and (BHelper.player:check_low_threat()) and (BHelper.target:is_boss()) and
        (BHelper.player:can_cast_on_enemy('Героический бросок'))) then
        return BHelper.keybinds:show_spell('Героический бросок')
    end

    if (((self.vars.attack_type == '2')) and (BHelper.player:check_spell_range('Сокрушение')) and
        (BHelper.player:can_cast('Удар грома'))) then
        return BHelper.keybinds:show_spell('Удар грома')
    end

    if (not BHelper.player:check_low_threat()) then
        if ((BHelper.auras:target('Деморализующий крик') < 2) and
            (BHelper.player:check_spell_range('Сокрушение')) and
            (BHelper.player:can_cast('Деморализующий крик'))) then
            return BHelper.keybinds:show_spell('Деморализующий крик')
        end

        if ((BHelper.auras:target('Удар грома') < 2) and
            (BHelper.player:check_spell_range('Сокрушение')) and
            (BHelper.player:can_cast('Удар грома'))) then
            return BHelper.keybinds:show_spell('Удар грома')
        end

        if ((BHelper.auras:player('Командирский крик') == 0) and (self.vars.commanding_shout) and
            (BHelper.player:can_cast('Командирский крик'))) then
            return BHelper.keybinds:show_spell('Командирский крик')
        end
    end

    if ((BHelper.player:can_cast_on_enemy('Реванш'))) then return BHelper.keybinds:show_spell('Реванш') end

    if ((BHelper.player:can_cast_on_enemy('Мощный удар щитом'))) then
        return BHelper.keybinds:show_spell('Мощный удар щитом')
    end

    if (((self.vars.attack_type == '2') or (BHelper.player:check_low_threat())) and
        (BHelper.player:can_cast('Блок щитом'))) then
        return BHelper.keybinds:show_spell('Блок щитом')
    end

    if ((BHelper.player:check_spell_range('Сокрушение')) and
        (BHelper.player:get_spell_cooldown('Мощный удар щитом') > 1.5) and
        (BHelper.player:can_cast('Ударная волна'))) then
        return BHelper.keybinds:show_spell('Ударная волна')
    end

    if ((BHelper.player:get_spell_cooldown('Мощный удар щитом') > 1.5) and
        (BHelper.player:can_cast_on_enemy('Сокрушение'))) then
        return BHelper.keybinds:show_spell('Сокрушение')
    end
end

function BHelper.modules.warrior.proto_farm:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.attack_type == nil) then self.vars.attack_type = '1' end
    if (self.vars.battle_shout == nil) then self.vars.battle_shout = false end
    if (self.vars.commanding_shout == nil) then self.vars.commanding_shout = false end
    if (self.vars.demoralizing_shout == nil) then self.vars.demoralizing_shout = false end
    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Удар героя')
    BHelper.keybinds:bind_spell('Рассекающий удар')
    BHelper.keybinds:bind_spell('Безудержное восстановление')
    BHelper.keybinds:bind_spell('Деморализующий крик')
    BHelper.keybinds:bind_spell('Боевой крик')
    BHelper.keybinds:bind_spell('Командирский крик')
    BHelper.keybinds:bind_spell('Удар щитом')
    BHelper.keybinds:bind_spell('Ярость берсерка')
    BHelper.keybinds:bind_spell('Кровавая ярость')
    BHelper.keybinds:bind_spell('Дразнящий удар')
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')
    BHelper.keybinds:bind_spell('Героический бросок')
    BHelper.keybinds:bind_spell('Героический бросок', 'BUTTON5')
    BHelper.keybinds:bind_spell('Мощный удар щитом')
    BHelper.keybinds:bind_spell('Реванш')
    BHelper.keybinds:bind_spell('Удар грома')
    BHelper.keybinds:bind_spell('Сокрушение')
    BHelper.keybinds:bind_spell('Ударная волна')
    BHelper.keybinds:bind_spell('Глухая оборона')
    BHelper.keybinds:bind_spell('Ни шагу назад')
    BHelper.keybinds:bind_spell('Блок щитом')
    BHelper.keybinds:bind_spell('Отражение заклинания')

    BHelper.keybinds:bind_spell('Кровопускание')

    BHelper.core.action:set('rotation')
end

function BHelper.modules.warrior.proto_farm:macros()
    BHelper.macros:create('Удар щитомTV', '#showtooltip Удар щитом\n/bh tv silence', 41)
    BHelper.macros:create('Командирский крикTV',
                          '#showtooltip Командирский крик\n/bh tv commanding_shout', 42)
    BHelper.macros:create('Рывок',
                          '#showtooltip\n/bh c\n/cast [noharm]Вмешательство;Рывок;Перехват',
                          15)
    BHelper.macros:create('Провокация',
                          '#showtooltip\n/bh c\n/cast Провокация\n/cast Дразнящий удар', 16)
    BHelper.macros:create('Возмездие',
                          '#showtooltip Возмездие\n/bh c\n/cast [stance:2/3] Боевая стойка\n/cast [stance:1] Возмездие',
                          24)

    BHelper.macros:create('Глухая оборона', '#showtooltip\n/bh c\n/cast Глухая оборона', 79)
    BHelper.macros:create('Ни шагу назад', '#showtooltip\n/bh c\n/cast Ни шагу назад', 80)
    BHelper.macros:create('Блок щитом', '#showtooltip\n/bh c\n/cast Блок щитом', 81)
    BHelper.macros:create('Отражение заклинания',
                          '#showtooltip\n/bh c\n/cast Отражение заклинания', 82)

    BHelper.macros:create('S', '/startattack\n/bh sv attack_type 1\n/bh', 13, 1263)
    BHelper.macros:create('M', '/startattack\n/bh sv attack_type 2\n/bh', 14, 1264)
end

function BHelper.modules.warrior.proto_farm:rotation()
    if ((self.vars.attack_type == '1') and (BHelper.player:can_cast('Удар героя'))) then
        BHelper.keybinds:show_attack('Удар героя')
    elseif ((self.vars.attack_type == '2') and (BHelper.player:can_cast('Рассекающий удар'))) then
        BHelper.keybinds:show_attack('Рассекающий удар')
    end

    if ((BHelper.player:get_health_on_percent() < 10) and BHelper.player:can_cast('Глухая оборона')) then
        return BHelper.keybinds:show_spell('Глухая оборона')
    end

    if ((BHelper.player:get_health_on_percent() < 20) and
        BHelper.player:can_cast('Безудержное восстановление')) then
        return BHelper.keybinds:show_spell('Безудержное восстановление')
    end

    if ((BHelper.player:get_health_on_percent() < 20) and BHelper.player:can_cast('Ни шагу назад')) then
        return BHelper.keybinds:show_spell('Ни шагу назад')
    end

    if (BHelper.target:check_cast() and (self.vars.silence) and BHelper.player:can_cast_on_enemy('Удар щитом')) then
        return BHelper.keybinds:show_spell('Удар щитом')
    end

    if ((BHelper.player:get_power() <= 30) and (BHelper.player:can_cast('Ярость берсерка'))) then
        return BHelper.keybinds:show_spell('Ярость берсерка')
    end

    if ((BHelper.player:get_power() <= 30) and (BHelper.player:can_cast('Кровавая ярость'))) then
        return BHelper.keybinds:show_spell('Кровавая ярость')
    end

    if ((self.vars.attack_type == '1') and (BHelper.player:check_low_threat()) and (BHelper.target:is_boss()) and
        (BHelper.player:can_cast_on_enemy('Героический бросок'))) then
        return BHelper.keybinds:show_spell('Героический бросок')
    end

    if (((self.vars.attack_type == '2')) and (BHelper.player:check_spell_range('Сокрушение')) and
        (BHelper.player:can_cast('Удар грома'))) then
        return BHelper.keybinds:show_spell('Удар грома')
    end

    if (not BHelper.player:check_low_threat()) then
        if ((BHelper.auras:target('Деморализующий крик') < 2) and
            (BHelper.player:check_spell_range('Сокрушение')) and
            (BHelper.player:can_cast('Деморализующий крик'))) then
            return BHelper.keybinds:show_spell('Деморализующий крик')
        end

        if ((BHelper.auras:target('Удар грома') < 2) and
            (BHelper.player:check_spell_range('Сокрушение')) and
            (BHelper.player:can_cast('Удар грома'))) then
            return BHelper.keybinds:show_spell('Удар грома')
        end

        if ((BHelper.auras:player('Командирский крик') == 0) and (self.vars.commanding_shout) and
            (BHelper.player:can_cast('Командирский крик'))) then
            return BHelper.keybinds:show_spell('Командирский крик')
        end
    end

    BHelper.keybinds:bind_spell('Кровопускание')

    if ((BHelper.auras:target('Кровопускание') == 0) and
        (BHelper.player:can_cast_on_enemy('Кровопускание'))) then
        return BHelper.keybinds:show_spell('Кровопускание')
    end
    if ((BHelper.player:can_cast_on_enemy('Реванш'))) then return BHelper.keybinds:show_spell('Реванш') end

    if ((BHelper.player:can_cast_on_enemy('Мощный удар щитом'))) then
        return BHelper.keybinds:show_spell('Мощный удар щитом')
    end

    if (((self.vars.attack_type == '2') or (BHelper.player:check_low_threat())) and
        (BHelper.player:can_cast('Блок щитом'))) then
        return BHelper.keybinds:show_spell('Блок щитом')
    end

    if ((BHelper.player:check_spell_range('Сокрушение')) and
        (BHelper.player:get_spell_cooldown('Мощный удар щитом') > 1.5) and
        (BHelper.player:can_cast('Ударная волна'))) then
        return BHelper.keybinds:show_spell('Ударная волна')
    end

    if ((BHelper.player:get_spell_cooldown('Мощный удар щитом') > 1.5) and
        (BHelper.player:can_cast_on_enemy('Сокрушение'))) then
        return BHelper.keybinds:show_spell('Сокрушение')
    end
end
