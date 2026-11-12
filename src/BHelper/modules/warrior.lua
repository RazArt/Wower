local auras = BHelper.auras
local core = BHelper.core
local keybinds = BHelper.keybinds
local macros = BHelper.macros
local modules = BHelper.modules
local pet = BHelper.pet
local player = BHelper.player
local target = BHelper.target
local threat = BHelper.threat
local timers = BHelper.timers
local module = BHelper.modules.warrior

local vars = nil

local multiple_attack = false

function BHelper.modules.warrior:init()

end

function BHelper.modules.warrior:macros()
    macros:create('Деморализующий крик',
                  '#showtooltip Деморализующий крик\n/bh tv demoralizing_shout')
    keybinds:place_macro('Деморализующий крик', 41)

    macros:create('Боевой крик', '#showtooltip Боевой крик\n/bh tv battle_shout')
    keybinds:place_macro('Боевой крик', 42)

    macros:create('Командирский крик',
                  '#showtooltip Командирский крик\n/bh tv commanding_shout')
    keybinds:place_macro('Командирский крик', 43)

    macros:create('Возмездие',
                  '#showtooltip Возмездие\n/cast [stance:2/3] Боевая стойка\n/cast [stance:1] Возмездие') -- 96 24
end

function BHelper.modules.warrior:execute()
    if (not multiple_attack) then
        if (player:can_cast('Удар героя')) then keybinds:show_attack('Удар героя') end
    else
        if (player:can_cast('Рассекающий удар')) then
            keybinds:show_attack('Рассекающий удар')
        end
    end

    if ((target:check_cast()) and (vars.silence)) then
        if (player:can_cast_on_enemy('Зуботычина')) then
            return keybinds:show_spell('Зуботычина')
        end
        if (player:can_cast_on_enemy('Удар щитом')) then
            return keybinds:show_spell('Удар щитом')
        end
    end
end

function BHelper.modules.warrior.default:init()
    vars = self.vars

    self.settings.usable_equip = 'DPS'

    if (not vars.battle_shout) then vars.battle_shout = false end
    if (not vars.commanding_shout) then vars.commanding_shout = false end
    if (not vars.demoralizing_shout) then vars.demoralizing_shout = false end
end

function BHelper.modules.warrior.default:macros()
    macros:create('Рывок',
                  '#showtooltip\n/cast [noharm]Вмешательство;[stance:2]Рывок;Перехват')
    macros:create('Глухая оборона',
                  '#showtooltip Глухая оборона\n/cast [stance:1/3] Оборонительная стойка\n/cast Глухая оборона')
end

function BHelper.modules.warrior.default:put()
    keybinds:place_spell('Устрашающий крик', 85)
    keybinds:place_spell('Деморализующий крик', 86)
    keybinds:place_spell('Вихрь', 87)
    keybinds:place_spell('Кровожадность', 88)
    keybinds:place_spell('Мощный удар', 89)
    keybinds:place_spell('Казнь', 90)
    keybinds:place_spell('Кровавая ярость', 91)
    keybinds:place_spell('Ярость берсерка', 92)
    if (player:know_spell('Берсерк(Расовая)')) then
        keybinds:place_spell('Берсерк(Расовая)', 93)
    end
    if (player:know_spell('Кровавое неистовство(Расовая)')) then
        keybinds:place_spell('Кровавое неистовство(Расовая)', 93)
    end
    keybinds:place_spell('Жажда смерти', 94)
    keybinds:place_spell('Безрассудство', 95)
    keybinds:place_macro('Рывок', 15)
    keybinds:place_spell('Раскол брони', 16)
    keybinds:place_spell('Зуботычина', 17)
    keybinds:place_spell('Сокрушительный бросок', 18)
    keybinds:place_spell('Безудержное восстановление', 19)
    keybinds:place_spell('Боевой крик', 20)
    keybinds:place_spell('Командирский крик', 21)
    keybinds:place_macro('Глухая оборона', 23)
    keybinds:place_macro('Возмездие', 24)
end

function BHelper.modules.warrior.default:rotation_single()
    multiple_attack = false
    return self:rotation()
end

function BHelper.modules.warrior.default:rotation_multiple()
    multiple_attack = true
    return self:rotation()
end

function BHelper.modules.warrior.default:rotation()
    if ((player:health_on_percent() < 50) and (player:spell_cooldown('Глухая оборона') == 0)) then
        if ((not player:form('Оборонительная стойка')) and
            (player:can_cast('Оборонительная стойка'))) then
            return keybinds:show_help('Оборонительная стойка')
        end
        if (not player:is_equipped_type('Щиты')) then player:equip_set('TANK') end
        return keybinds:show_spell('Глухая оборона')
    end

    if ((target:me_on_target()) and (player:spell_cooldown('Возмездие') == 0)) then
        if ((not player:form('Боевая стойка')) and (player:can_cast('Боевая стойка'))) then
            return keybinds:show_help('Боевая стойка')
        end
        return keybinds:show_spell('Возмездие')
    end

    if (player:is_equipped_type('Щиты')) then player:equip_set('DPS') end

    if ((target:aura('Сокрушительный бросок') == 0) and
        (player:spell_casttime('Сокрушительный бросок') == 0) and
        (player:can_cast_on_enemy('Сокрушительный бросок'))) then
        return keybinds:show_spell('Сокрушительный бросок')
    end

    if ((not player:form('Стойка берсерка')) and (player:can_cast('Стойка берсерка'))) then
        return keybinds:show_spell('Стойка берсерка')
    end

    if ((player:health_on_percent() < 30) and (player:can_cast('Безудержное восстановление'))) then
        return keybinds:show_spell('Безудержное восстановление')
    end

    if ((target:aura('Деморализующий крик') < 2) and (vars.demoralizing_shout) and
        (player:can_cast('Деморализующий крик', true))) then
        return keybinds:show_spell('Деморализующий крик')
    end

    if (player:power() <= 30) then
        if (player:can_cast('Ярость берсерка')) then
            return keybinds:show_spell('Ярость берсерка')
        end
        if (player:can_cast('Кровавая ярость')) then
            return keybinds:show_spell('Кровавая ярость')
        end
    end

    if ((player:is_burst()) and (not self.burst_cooldown)) then
        local item = player:item_name(INVSLOT_TRINKET1)
        if ((player:is_equipped_item(item)) and (player:can_use_item(item))) then keybinds:show_item(item) end

        local item = player:item_name(INVSLOT_TRINKET2)
        if ((player:is_equipped_item(item)) and (player:can_use_item(item))) then keybinds:show_item(item) end

        if ((player:can_cast('Безрассудство'))) then
            return keybinds:show_spell('Безрассудство')
        end

        if ((player:can_cast('Жажда смерти'))) then
            return keybinds:show_spell('Жажда смерти')
        end

        if (player:can_cast('Берсерк(Расовая)')) then
            return keybinds:show_spell('Берсерк(Расовая)')
        end

        if (player:can_cast('Кровавое неистовство(Расовая)')) then
            return keybinds:show_spell('Кровавое неистовство(Расовая)')
        end
    end

    local item = player:item_name(INVSLOT_HAND)
    if ((player:is_equipped_item(item)) and (player:can_use_item(item))) then keybinds:show_item(item) end

    if (player:can_cast_on_enemy('Кровожадность')) then
        return keybinds:show_spell('Кровожадность')
    end

    if ((player:aura('Сокрушить!') > 0) and (player:can_cast_on_enemy('Мощный удар'))) then
        return keybinds:show_spell('Мощный удар')
    end

    if ((target:name() ~= 'Принц Келесет') and (player:can_cast('Вихрь', true))) then
        return keybinds:show_spell('Вихрь')
    end

    if ((player:aura('Боевой крик') == 0) and
        (player:aura('Благословение могущества') == 0) and
        (player:aura('Великое благословение могущества') == 0) and (vars.battle_shout) and
        (player:can_cast('Боевой крик'))) then return keybinds:show_spell('Боевой крик') end

    if ((player:aura('Командирский крик') == 0) and (vars.commanding_shout) and
        (player:can_cast('Командирский крик'))) then
        return keybinds:show_spell('Командирский крик')
    end

    if ((target:aura('Раскол брони') > 0) and (target:aura('Раскол брони') <= 2) and
        (player:can_cast_on_enemy('Раскол брони'))) then
        return keybinds:show_spell('Раскол брони')
    end

    if ((not player:can_cast_on_enemy('Кровожадность', 1)) and (player:can_cast_on_enemy('Казнь'))) then
        return keybinds:show_spell('Казнь')
    end

    if ((not player:can_cast_on_enemy('Кровожадность', 1)) and
        (target:aura_count('Раскол брони') < 5) and (player:can_cast_on_enemy('Раскол брони'))) then
        return keybinds:show_spell('Раскол брони')
    end
end

function BHelper.modules.warrior.proto:init()
    vars = self.vars

    self.settings.usable_equip = 'TANK'

    if (not vars.battle_shout) then vars.battle_shout = false end
    if (not vars.commanding_shout) then vars.commanding_shout = false end
    if (not vars.demoralizing_shout) then vars.demoralizing_shout = false end
end

function BHelper.modules.warrior.proto:macros()
    macros:create('Рывок',
                  '#showtooltip\n/cast [stance:2] Боевая стойка\n/cast [noharm]Вмешательство; Рывок; Перехват\n/cast [stance:1] Оборонительная стойка')
    -- macros:create('Рывок',
    --               '#showtooltip\n/cast [noharm]Вмешательство; Рывок; Перехват', 15)
    macros:create('Провокация',
                  '#showtooltip\n/cast [stance:1/3] Оборонительная стойка\n/cast Провокация\n/cast Дразнящий удар')
end

function BHelper.modules.warrior.proto:put()
    keybinds:place_spell('Дразнящий удар', 97)
    keybinds:place_spell('Удар грома', 98)
    keybinds:place_spell('Мощный удар щитом', 99)
    keybinds:place_spell('Реванш', 100)
    keybinds:place_spell('Сокрушение', 101)
    keybinds:place_spell('Ударная волна', 102)
    keybinds:place_spell('Деморализующий крик', 103)
    keybinds:place_spell('Глухая оборона', 105)
    keybinds:place_spell('Ни шагу назад', 106)
    keybinds:place_spell('Блок щитом', 107)
    keybinds:place_spell('Отражение заклинания', 108)
    keybinds:place_macro('Рывок', 15)
    keybinds:place_spell('Провокация', 16)
    keybinds:place_spell('Удар щитом', 17)
    keybinds:place_spell('Героический бросок', 18)
    keybinds:place_spell('Безудержное восстановление', 19)
    keybinds:place_spell('Боевой крик', 20)
    keybinds:place_spell('Командирский крик', 21)
    keybinds:place_macro('Возмездие', 24)
end

function BHelper.modules.warrior.proto:rotation_single()
    multiple_attack = false
    return self:rotation()
end

function BHelper.modules.warrior.proto:rotation_multiple()
    multiple_attack = true
    return self:rotation()
end

function BHelper.modules.warrior.proto:rotation()
    if (not player:is_equipped_type('Щиты')) then player:equip_set('TANK') end

    if ((not player:form('Оборонительная стойка')) and
        (player:can_cast('Оборонительная стойка'))) then
        return keybinds:show_help('Оборонительная стойка')
    end

    if ((player:health_on_percent() < 10) and player:can_cast('Глухая оборона')) then
        return keybinds:show_spell('Глухая оборона')
    end

    if ((player:health_on_percent() < 20) and player:can_cast('Ни шагу назад')) then
        return keybinds:show_spell('Ни шагу назад')
    end

    if ((player:health_on_percent() < 20) and player:can_cast('Безудержное восстановление')) then
        return keybinds:show_spell('Безудержное восстановление')
    end

    if ((target:aura('Раскол брони') > 0) and (target:aura('Раскол брони') <= 2) and
        (player:can_cast_on_enemy('Сокрушение'))) then return keybinds:show_spell('Сокрушение') end

    if (player:power() <= 30) then
        if (player:can_cast('Ярость берсерка')) then
            return keybinds:show_spell('Ярость берсерка')
        end
        if (player:can_cast('Кровавая ярость')) then
            return keybinds:show_spell('Кровавая ярость')
        end
    end

    if (player:has_stable_threat()) then
        if ((target:aura('Удар грома', true) < 2) and (player:can_cast('Удар грома', true))) then
            return keybinds:show_spell('Удар грома')
        end

        if ((target:aura('Деморализующий крик') < 2) and (vars.demoralizing_shout) and
            (player:can_cast('Деморализующий крик', true))) then
            return keybinds:show_spell('Деморализующий крик')
        end

        if ((player:aura('Боевой крик') == 0) and
            (player:aura('Благословение могущества') == 0) and
            (player:aura('Великое благословение могущества') == 0) and (vars.battle_shout) and
            (player:can_cast('Боевой крик'))) then return keybinds:show_spell('Боевой крик') end

        if ((player:aura('Командирский крик') == 0) and (vars.commanding_shout) and
            (player:can_cast('Командирский крик'))) then
            return keybinds:show_spell('Командирский крик')
        end
    end

    if (((multiple_attack) or (not player:has_stable_threat())) and (player:can_cast('Блок щитом'))) then
        return keybinds:show_spell('Блок щитом')
    end

    if ((not player:has_stable_threat()) and (target:is_boss()) and
        (player:can_cast_on_enemy('Героический бросок'))) then
        return keybinds:show_spell('Героический бросок')
    end

    if ((not multiple_attack) and (target:aura('Кровопускание', true) == 0) and
        (player:can_cast_on_enemy('Кровопускание'))) then
        return keybinds:show_spell('Кровопускание')
    end

    if ((multiple_attack) and (player:can_cast('Удар грома', true))) then
        return keybinds:show_spell('Удар грома')
    end

    if (player:can_cast_on_enemy('Реванш')) then return keybinds:show_spell('Реванш') end

    if (player:can_cast_on_enemy('Мощный удар щитом')) then
        return keybinds:show_spell('Мощный удар щитом')
    end

    if ((not player:can_cast_on_enemy('Реванш', 1)) and
        (not player:can_cast_on_enemy('Мощный удар щитом', 1)) and
        (player:can_cast('Ударная волна', true))) then
        return keybinds:show_spell('Ударная волна')
    end

    if ((not player:can_cast_on_enemy('Реванш', 1)) and
        (not player:can_cast_on_enemy('Мощный удар щитом', 1)) and
        (player:can_cast_on_enemy('Сокрушение'))) then return keybinds:show_spell('Сокрушение') end
end
