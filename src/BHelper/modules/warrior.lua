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
    BHelper.macros:create('Деморализующий крик',
                          '#showtooltip Деморализующий крик\n/bh tv demoralizing_shout',
                          41)
    BHelper.macros:create('Боевой крик',
                          '#showtooltip Боевой крик\n/bh tv battle_shout', 42)
    BHelper.macros:create('Командирский крик',
                          '#showtooltip Командирский крик\n/bh tv commanding_shout',
                          43)
    BHelper.macros:create('Зуботычина',
                          '#showtooltip Зуботычина\n/bh tv silence', 44)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip\n/bh c\n/cast Берсерк(Расовая)', 93)
    BHelper.macros:create('Жажда смерти',
                          '#showtooltip\n/bh c\n/cast Жажда смерти', 94)
    BHelper.macros:create('Безрассудство',
                          '#showtooltip\n/bh c\n/cast Безрассудство', 95)
    BHelper.macros:create('Возмездие',
                          '#showtooltip Возмездие\n/bh c\n/cast [stance:2/3] Боевая стойка\n/cast [stance:1] Возмездие',
                          96)
    BHelper.macros:create('Рывок',
                          '#showtooltip\n/cast [noharm]Вмешательство;[stance:2]Рывок;Перехват',
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
        BHelper.keybinds:show_spell('Безудержное восстановление')
        return true
    end

    if ((BHelper.target:get_debuff_time('Деморализующий крик') == 0) and
        (self.vars.demoralizing_shout) and
        (BHelper.player:can_cast('Деморализующий крик'))) then
        BHelper.keybinds:show_spell('Деморализующий крик')
        return true
    end

    if ((BHelper.player:get_buff_time('Боевой крик') == 0) and
        (BHelper.player:get_buff_time('Благословение могущества') == 0) and
        (BHelper.player:get_buff_time(
            'Великое благословение могущества') == 0) and
        (self.vars.battle_shout) and (BHelper.player:can_cast('Боевой крик'))) then
        BHelper.keybinds:show_spell('Боевой крик')
        return true
    end

    if ((BHelper.player:get_buff_time('Командирский крик') == 0) and
        (self.vars.commanding_shout) and
        (BHelper.player:can_cast('Командирский крик'))) then
        BHelper.keybinds:show_spell('Командирский крик')
        return true
    end

    if (BHelper.target:check_cast() and (self.vars.silence) and
        BHelper.player:can_cast_on_enemy('Зуботычина')) then
        BHelper.keybinds:show_spell('Зуботычина')
        return true
    end

    if ((BHelper.player:get_power() <= 30) and
        (BHelper.player:can_cast('Ярость берсерка'))) then
        BHelper.keybinds:show_spell('Ярость берсерка')
        return true
    end

    if ((BHelper.player:get_power() <= 30) and
        (BHelper.player:can_cast('Кровавая ярость'))) then
        BHelper.keybinds:show_spell('Кровавая ярость')
        return true
    end

    if (BHelper.player:check_burst_mode()) then
        if ((BHelper.player:can_cast('Безрассудство'))) then
            return BHelper.keybinds:show_spell('Безрассудство')
        end

        if ((BHelper.player:can_cast('Жажда смерти'))) then
            return BHelper.keybinds:show_spell('Жажда смерти')
        end

        if ((not BHelper.player:check_heroism_buff()) and (not BHelper.vars.cooldown_berserker) and
            (BHelper.player:can_cast('Берсерк(Расовая)'))) then
            return BHelper.keybinds:show_spell('Берсерк(Расовая)')
        end
    end

    if ((BHelper.player:check_equipped_item('Душители Плети')) and
        (BHelper.player:can_use_item('Душители Плети'))) then
        BHelper.keybinds:show_item('Душители Плети')
        return true
    end

    if (BHelper.player:can_cast_on_enemy('Кровожадность')) then
        BHelper.keybinds:show_spell('Кровожадность')
        return true
    end

    if ((BHelper.player:get_spell_cooldown('Кровожадность') >= 1.3) and
        (BHelper.player:get_buff_time('Сокрушить!') > 0) and
        (BHelper.player:can_cast_on_enemy('Мощный удар'))) then
        BHelper.keybinds:show_spell('Мощный удар')
        return true
    end

    if ((BHelper.target:get_name() ~= 'Принц Келесет') and
        (BHelper.player:can_cast('Вихрь'))) then
        BHelper.keybinds:show_spell('Вихрь')
        return true
    end

    if ((BHelper.player:get_spell_cooldown('Кровожадность') >= 1.3) and
        (BHelper.player:can_cast_on_enemy('Казнь'))) then
        BHelper.keybinds:show_spell('Казнь')
        return true
    end

    if ((BHelper.player:get_spell_cooldown('Кровожадность') >= 1.3) and
        ((BHelper.target:get_debuff_time('Раскол брони') <= 3) or
            (BHelper.target:get_debuff_count('Раскол брони') < 5)) and
        (BHelper.player:can_cast_on_enemy('Раскол брони'))) then
        BHelper.keybinds:show_spell('Раскол брони')
        return true
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
    BHelper.keybinds:bind_spell('Ярость берсерка')
    BHelper.keybinds:bind_spell('Кровавая ярость')
    BHelper.keybinds:bind_spell('Безрассудство')
    BHelper.keybinds:bind_spell('Жажда смерти')
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')
    BHelper.keybinds:bind_spell('Удар грома)')
    BHelper.keybinds:bind_spell('Мощный удар щитом')
    BHelper.keybinds:bind_spell('Сокрушение')
    BHelper.keybinds:bind_spell('Удар щитом')
    BHelper.keybinds:bind_spell('Ударная волна')
    BHelper.keybinds:bind_spell('Реванш')
    BHelper.keybinds:bind_spell('Разоружение')

    BHelper.core.action:set('rotation')
end

function BHelper.modules.warrior.proto:macros()
    BHelper.macros:create('Деморализующий крик',
                          '#showtooltip Деморализующий крик\n/bh tv demoralizing_shout',
                          41)
    BHelper.macros:create('Боевой крик',
                          '#showtooltip Боевой крик\n/bh tv battle_shout', 42)
    BHelper.macros:create('Командирский крик',
                          '#showtooltip Командирский крик\n/bh tv commanding_shout',
                          43)
    BHelper.macros:create('Зуботычина',
                          '#showtooltip Зуботычина\n/bh tv silence', 44)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip\n/bh c\n/cast Берсерк(Расовая)', 93)
    BHelper.macros:create('Жажда смерти',
                          '#showtooltip\n/bh c\n/cast Жажда смерти', 94)
    BHelper.macros:create('Безрассудство',
                          '#showtooltip\n/bh c\n/cast Безрассудство', 95)
    BHelper.macros:create('Возмездие',
                          '#showtooltip Возмездие\n/bh c\n/cast [stance:2/3] Боевая стойка\n/cast [stance:1] Возмездие',
                          96)
    BHelper.macros:create('Рывок',
                          '#showtooltip\n/cast [noharm]Вмешательство;[stance:2]Рывок;Перехват',
                          15)

    BHelper.macros:create('S', '/startattack\n/bh sv attack_type 1\n/bh', 13, true, 1263)
    BHelper.macros:create('M', '/startattack\n/bh sv attack_type 2\n/bh', 14, true, 1264)
end
