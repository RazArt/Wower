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

function BHelper.modules.warrior.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.attack_type == nil) then self.vars.attack_type = '1' end
    if (self.vars.battle_shout == nil) then self.vars.battle_shout = false end
    if (self.vars.commanding_shout == nil) then self.vars.commanding_shout = false end
    if (self.vars.demoralizing_shout == nil) then self.vars.demoralizing_shout = false end
    if (self.vars.silence == nil) then self.vars.silence = false end

    keybinds:bind_spell('Удар героя')
    keybinds:bind_spell('Рассекающий удар')
    keybinds:bind_spell('Безудержное восстановление')
    keybinds:bind_spell('Деморализующий крик')
    keybinds:bind_spell('Боевой крик')
    keybinds:bind_spell('Командирский крик')
    keybinds:bind_spell('Зуботычина')
    keybinds:bind_spell('Ярость берсерка')
    keybinds:bind_spell('Кровавая ярость')
    keybinds:bind_spell('Раскол брони')
    keybinds:bind_spell('Кровожадность')
    keybinds:bind_spell('Мощный удар')
    keybinds:bind_spell('Вихрь')
    keybinds:bind_spell('Казнь')
    keybinds:bind_spell('Безрассудство')
    keybinds:bind_spell('Жажда смерти')
    keybinds:bind_spell('Берсерк(Расовая)')
    keybinds:bind_item('Душители Плети')

    core.action:set('rotation')
end

function BHelper.modules.warrior.default:macros()
    macros:create('Деморализующий крикTV',
                  '#showtooltip Деморализующий крик\n/bh tv demoralizing_shout', 41)
    macros:create('Боевой крикTV', '#showtooltip Боевой крик\n/bh tv battle_shout', 42)
    macros:create('Командирский крикTV',
                  '#showtooltip Командирский крик\n/bh tv commanding_shout', 43)
    macros:create('ЗуботычинаTV', '#showtooltip Зуботычина\n/bh tv silence', 44)
    macros:create('Берсерк(Расовая)', '#showtooltip\n/bh c\n/cast Берсерк(Расовая)', 93)
    macros:create('Жажда смерти', '#showtooltip\n/bh c\n/cast Жажда смерти', 94)
    macros:create('Безрассудство', '#showtooltip\n/bh c\n/cast Безрассудство', 95)
    macros:create('Возмездие',
                  '#showtooltip Возмездие\n/bh c\n/cast [stance:2/3] Боевая стойка\n/cast [stance:1] Возмездие',
                  96)
    macros:create('Рывок',
                  '#showtooltip\n/bh c\n/cast [noharm]Вмешательство;[stance:2]Рывок;Перехват',
                  15)

    macros:create('S', '/startattack\n/bh sv attack_type 1\n/bh', 13, 1263)
    macros:create('M', '/startattack\n/bh sv attack_type 2\n/bh', 14, 1264)
end

function BHelper.modules.warrior.default:rotation()
    if (self.vars.attack_type == '1') then
        if (player:can_cast('Удар героя')) then keybinds:show_attack('Удар героя') end
    elseif (self.vars.attack_type == '2') then
        if (player:can_cast('Рассекающий удар')) then
            keybinds:show_attack('Рассекающий удар')
        end
    end

    if ((player:get_health_on_percent() < 30) and player:can_cast('Безудержное восстановление')) then
        return keybinds:show_spell('Безудержное восстановление')
    end

    if ((target:aura('Деморализующий крик') == 0) and (self.vars.demoralizing_shout) and
        (player:can_cast('Деморализующий крик'))) then
        return keybinds:show_spell('Деморализующий крик')
    end

    if ((player:aura('Боевой крик') == 0) and
        (player:aura('Благословение могущества') == 0) and
        (player:aura('Великое благословение могущества') == 0) and
        (self.vars.battle_shout) and (player:can_cast('Боевой крик'))) then
        return keybinds:show_spell('Боевой крик')
    end

    if ((player:aura('Командирский крик') == 0) and (self.vars.commanding_shout) and
        (player:can_cast('Командирский крик'))) then
        return keybinds:show_spell('Командирский крик')
    end

    if (target:check_cast() and (self.vars.silence) and player:can_cast_on_enemy('Зуботычина')) then
        return keybinds:show_spell('Зуботычина')
    end

    if ((target:aura('Раскол брони') > 0) and (target:aura('Раскол брони') <= 2) and
        (player:can_cast_on_enemy('Раскол брони'))) then
        return keybinds:show_spell('Раскол брони')
    end

    if ((player:get_power() <= 30) and (player:can_cast('Ярость берсерка'))) then
        return keybinds:show_spell('Ярость берсерка')
    end

    if ((player:get_power() <= 30) and (player:can_cast('Кровавая ярость'))) then
        return keybinds:show_spell('Кровавая ярость')
    end

    if ((player:check_burst_mode()) and (not BHelper.vars.cooldown_berserker)) then
        if ((player:can_cast('Безрассудство'))) then
            return keybinds:show_spell('Безрассудство')
        end

        if ((player:can_cast('Жажда смерти'))) then
            return keybinds:show_spell('Жажда смерти')
        end

        if (player:can_cast('Берсерк(Расовая)')) then
            return keybinds:show_spell('Берсерк(Расовая)')
        end
    end

    if ((player:check_equipped_item('Душители Плети')) and
        (player:can_use_item('Душители Плети'))) then keybinds:show_item('Душители Плети') end

    if (player:can_cast_on_enemy('Кровожадность')) then
        return keybinds:show_spell('Кровожадность')
    end

    if ((not player:can_cast_on_enemy('Кровожадность', 1)) and (player:aura('Сокрушить!') > 0) and
        (player:can_cast_on_enemy('Мощный удар'))) then return keybinds:show_spell('Мощный удар') end

    if ((target:get_name() ~= 'Принц Келесет') and (player:can_cast('Вихрь'))) then
        return keybinds:show_spell('Вихрь')
    end

    if ((not player:can_cast_on_enemy('Кровожадность', 1)) and (player:can_cast_on_enemy('Казнь'))) then
        return keybinds:show_spell('Казнь')
    end

    if (select(2, target:aura('Раскол брони', true)) < 5) and
        (player:can_cast_on_enemy('Раскол брони')) then
        return keybinds:show_spell('Раскол брони')
    end
end

function BHelper.modules.warrior.proto:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.attack_type == nil) then self.vars.attack_type = '1' end
    if (self.vars.commanding_shout == nil) then self.vars.commanding_shout = false end
    if (self.vars.demoralizing_shout == nil) then self.vars.demoralizing_shout = false end
    if (self.vars.silence == nil) then self.vars.silence = false end

    keybinds:bind_spell('Удар героя')
    keybinds:bind_spell('Рассекающий удар')
    keybinds:bind_spell('Безудержное восстановление')
    keybinds:bind_spell('Деморализующий крик')
    keybinds:bind_spell('Боевой крик')
    keybinds:bind_spell('Командирский крик')
    keybinds:bind_spell('Удар щитом')
    keybinds:bind_spell('Ярость берсерка')
    keybinds:bind_spell('Кровавая ярость')
    keybinds:bind_spell('Дразнящий удар')
    keybinds:bind_spell('Берсерк(Расовая)')

    keybinds:bind_spell('Героический бросок')
    keybinds:bind_spell('Героический бросок', 'BUTTON5')
    keybinds:bind_spell('Мощный удар щитом')
    keybinds:bind_spell('Реванш')
    keybinds:bind_spell('Удар грома')
    keybinds:bind_spell('Сокрушение')
    keybinds:bind_spell('Ударная волна')

    keybinds:bind_spell('Глухая оборона')
    keybinds:bind_spell('Ни шагу назад')
    keybinds:bind_spell('Блок щитом')
    keybinds:bind_spell('Отражение заклинания')

    core.action:set('rotation')
end

function BHelper.modules.warrior.proto:macros()
    macros:create('Удар щитомTV', '#showtooltip Удар щитом\n/bh tv silence', 41)
    macros:create('Командирский крикTV',
                  '#showtooltip Командирский крик\n/bh tv commanding_shout', 42)
    macros:create('Рывок',
                  '#showtooltip\n/bh c\n/cast [noharm]Вмешательство;Рывок;Перехват', 15)
    macros:create('Провокация',
                  '#showtooltip\n/bh c\n/cast Провокация\n/cast Дразнящий удар', 16)
    macros:create('Возмездие',
                  '#showtooltip Возмездие\n/bh c\n/cast [stance:2/3] Боевая стойка\n/cast [stance:1] Возмездие',
                  24)

    macros:create('Глухая оборона', '#showtooltip\n/bh c\n/cast Глухая оборона', 79)
    macros:create('Ни шагу назад', '#showtooltip\n/bh c\n/cast Ни шагу назад', 80)
    macros:create('Блок щитом', '#showtooltip\n/bh c\n/cast Блок щитом', 81)
    macros:create('Отражение заклинания',
                  '#showtooltip\n/bh c\n/cast Отражение заклинания', 82)

    macros:create('S', '/startattack\n/bh sv attack_type 1\n/bh', 13, 1263)
    macros:create('M', '/startattack\n/bh sv attack_type 2\n/bh', 14, 1264)
end

function BHelper.modules.warrior.proto:rotation()
    if ((self.vars.attack_type == '1') and (player:get_power() >= 20) and (player:can_cast('Удар героя'))) then
        keybinds:show_attack('Удар героя')
    elseif ((self.vars.attack_type == '2') and (player:get_power() >= 30) and
        (player:can_cast('Рассекающий удар'))) then
        keybinds:show_attack('Рассекающий удар')
    end

    if ((player:get_health_on_percent() < 10) and player:can_cast('Глухая оборона')) then
        return keybinds:show_spell('Глухая оборона')
    end

    if ((player:get_health_on_percent() < 20) and player:can_cast('Безудержное восстановление')) then
        return keybinds:show_spell('Безудержное восстановление')
    end

    if ((player:get_health_on_percent() < 20) and player:can_cast('Ни шагу назад')) then
        return keybinds:show_spell('Ни шагу назад')
    end

    if (target:check_cast() and (self.vars.silence) and player:can_cast_on_enemy('Удар щитом')) then
        return keybinds:show_spell('Удар щитом')
    end

    if ((target:aura('Раскол брони') > 0) and (target:aura('Раскол брони') <= 2) and
        (player:can_cast_on_enemy('Сокрушение'))) then return keybinds:show_spell('Сокрушение') end

    if ((player:get_power() <= 30) and (player:can_cast('Ярость берсерка'))) then
        return keybinds:show_spell('Ярость берсерка')
    end

    if ((player:get_power() <= 30) and (player:can_cast('Кровавая ярость'))) then
        return keybinds:show_spell('Кровавая ярость')
    end

    if ((self.vars.attack_type == '1') and (player:check_low_threat()) and (target:is_boss()) and
        (player:can_cast_on_enemy('Героический бросок'))) then
        return keybinds:show_spell('Героический бросок')
    end

    if (((self.vars.attack_type == '2')) and (player:check_spell_range('Сокрушение')) and
        (player:can_cast('Удар грома'))) then return keybinds:show_spell('Удар грома') end

    if (not player:check_low_threat()) then
        if ((target:aura('Деморализующий крик') < 2) and
            (player:check_spell_range('Сокрушение')) and
            (player:can_cast('Деморализующий крик'))) then
            return keybinds:show_spell('Деморализующий крик')
        end

        if ((target:aura('Удар грома') < 2) and (player:check_spell_range('Сокрушение')) and
            (player:can_cast('Удар грома'))) then return keybinds:show_spell('Удар грома') end

        if ((player:aura('Командирский крик') == 0) and (self.vars.commanding_shout) and
            (player:can_cast('Командирский крик'))) then
            return keybinds:show_spell('Командирский крик')
        end
    end

    if ((player:can_cast_on_enemy('Реванш'))) then return keybinds:show_spell('Реванш') end

    if ((player:can_cast_on_enemy('Мощный удар щитом'))) then
        return keybinds:show_spell('Мощный удар щитом')
    end

    if (((self.vars.attack_type == '2') or (player:check_low_threat())) and (player:can_cast('Блок щитом'))) then
        return keybinds:show_spell('Блок щитом')
    end

    if ((player:check_spell_range('Сокрушение')) and
        (player:get_spell_cooldown('Мощный удар щитом') > 1.5) and
        (player:can_cast('Ударная волна'))) then return keybinds:show_spell('Ударная волна') end

    if ((player:get_spell_cooldown('Мощный удар щитом') > 1.5) and
        (player:can_cast_on_enemy('Сокрушение'))) then return keybinds:show_spell('Сокрушение') end
end
