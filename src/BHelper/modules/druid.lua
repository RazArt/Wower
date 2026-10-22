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
local module = BHelper.modules.druid

function BHelper.modules.druid.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true
    self.behind_of_target = true

    if (self.vars.silence == nil) then self.vars.silence = false end

    keybinds:bind_spell('Калечение')
    keybinds:bind_spell('Оглушить')
    keybinds:bind_spell('Волшебный огонь (зверь)')
    keybinds:bind_spell('Дикий рев')
    keybinds:bind_spell('Тигриное неистовство')
    keybinds:bind_spell('Размах (кошка)')
    keybinds:bind_spell('Размах (медведь)')
    keybinds:bind_spell('Увечье (кошка)')
    keybinds:bind_spell('Увечье (медведь)')
    keybinds:bind_spell('Глубокая рана')
    keybinds:bind_spell('Полоснуть')
    keybinds:bind_spell('Разорвать')
    keybinds:bind_spell('Свирепый укус')
    keybinds:bind_spell('Растерзать')
    keybinds:bind_spell('Трепка')
    keybinds:bind_spell('Цапнуть')
    keybinds:bind_spell('Попятиться')
    keybinds:bind_spell('Берсерк')
    keybinds:bind_spell('Берсерк(Расовая)')
    keybinds:bind_spell('Облик лютого медведя')
    keybinds:bind_spell('Облик кошки')
    keybinds:bind_spell('Смерч')
    keybinds:bind_spell('Исступление')
    keybinds:bind_spell('Инстинкты выживания')
    keybinds:bind_spell('Неистовое восстановление')
    keybinds:bind_spell('Дубовая кожа')
    keybinds:bind_spell('Устрашающий рев')

    keybinds:bind_macro('Reform')
    keybinds:bind_macro('Reform', 'BUTTON5')

    keybinds:bind_item('Знак превосходства')

    self:register_event('UI_ERROR_MESSAGE')
end

function BHelper.modules.druid.default:macros()
    macros:create('Чардж',
                  '#showtooltip\n/cast [form:1] Звериная атака - медведь\n/cast [form:3] Звериная атака - кошка',
                  15)
    macros:create('Атака',
                  '#showtooltip\n/startattack\n/cast [form:0/2/4/5/6] !Облик кошки(Смена облика)\n/cast Волшебный огонь (зверь)',
                  16)
    macros:create('Reform',
                  '/bh c\n/cast [form:0/1/2/4/5/6] !Облик кошки(Смена облика)\n/cast [form:3] !Облик лютого медведя(Смена облика)\n')
    macros:create('Калечение',
                  '#showtooltip\n/bh c\n/cast [form:1/2] Оглушить\n/cast [form:3] Калечение', 17)
    macros:create('Возрождение', '#showtooltip Возрождение\n/bh c\n/cast Возрождение',
                  19)
    macros:create('Дубовая кожа',
                  '#showtooltip Дубовая кожа\n/bh c\n/cast Дубовая кожа', 20)
    macros:create('Смерч', '#showtooltip Смерч\n/bh c\n/cast Смерч', 21)
    macros:create('Озарение',
                  '#showtooltip Озарение\n/bh c\n/cast [@focus,help,nodead] Озарение\n/cast [@target,help,nodead] Озарение\n/cast [@mouseover,help,nodead] Озарение',
                  22)
    macros:create('Инстинкты выживания',
                  '#showtooltip Инстинкты выживания\n/bh c\n/cast Инстинкты выживания',
                  23)
    macros:create('Инвиз',
                  '#showtooltip Крадущийся зверь\n/bh stop\n/cast [form:0/1/2/4/5/6] !Облик кошки(Смена облика)\n/cast [form:3] Крадущийся зверь',
                  24)
    macros:create('Берсерк',
                  '#showtooltip Берсерк\n/bh c\n/cast Берсерк\n/use Знак превосходства',
                  69)
    macros:create('Берсерк(Расовая)',
                  '#showtooltip Берсерк(Расовая)\n/bh c\n/cast Берсерк(Расовая)', 70)
    macros:put_to_panel('Берсерк', 81)
    macros:put_to_panel('Берсерк(Расовая)', 82)
    macros:create('Неистовое восстановление',
                  '#showtooltip Неистовое восстановление\n/bh c\n/cast Неистовое восстановление',
                  71)
    macros:create('Исступление', '#showtooltip Исступление\n/bh c\n/cast Исступление',
                  72)
    macros:create('Порыв', '#showtooltip Порыв\n/bh c\n/cast Порыв', 83)
    macros:create('КалечениеTV', '#showtooltip Калечение\n/bh tv silence', 43)
end

function BHelper.modules.druid.default:execute()
    if ((player:get_health_on_percent() < 30) and (player:can_cast('Инстинкты выживания'))) then
        return keybinds:show_spell('Инстинкты выживания')
    end

    if ((player:get_health_on_percent() < 30) and (player:can_cast('Неистовое восстановление'))) then
        return keybinds:show_spell('Неистовое восстановление')
    end

    if ((player:get_health_on_percent() < 60) and (player:can_cast('Дубовая кожа'))) then
        return keybinds:show_spell('Дубовая кожа')
    end

    if ((player:get_health_on_percent() < 60) and (player:can_cast('Исступление'))) then
        return keybinds:show_spell('Исступление')
    end

    if ((player:check_location_is_icc()) and
        ((target:is_player()) or ((target:get_name() == 'Имирьярская охотница') and
            (target:check_casting_spellname('Быстрострел')))) and
        (player:aura('Облик лютого медведя') == 0) and (target:aura('Смерч') == 0) and
        (player:can_cast_on_enemy('Смерч'))) then return keybinds:show_spell('Смерч') end

    if ((player:aura('Облик кошки') == 0) and (player:aura('Облик лютого медведя') == 0)) then
        return keybinds:show_macro('Reform')
    end

    if ((player:check_hight_threat()) and (not target:is_player()) and (player:can_cast('Попятиться'))) then
        return keybinds:show_spell('Попятиться')
    end

    if (player:check_burst_mode() and (not BHelper.vars.cooldown_berserker)) then
        if (player:aura('Облик лютого медведя') > 0) and (player:can_cast('Берсерк')) then
            return keybinds:show_spell('Берсерк')
        end

        if ((player:aura('Тигриное неистовство') == 0) and (player:get_power() <= 80) and
            (player:can_cast('Берсерк'))) then return keybinds:show_spell('Берсерк') end

        if ((player:aura(50334) > 0) and (player:check_equipped_item('Знак превосходства')) and
            (player:can_use_item('Знак превосходства'))) then
            return keybinds:show_item('Знак превосходства')
        end

        if (player:can_cast('Берсерк(Расовая)')) then
            return keybinds:show_spell('Берсерк(Расовая)')
        end
    end
end

function BHelper.modules.druid.default:rotation_single()
    if (player:aura('Облик кошки') > 0) then return self:cat_single() end
    if (player:aura('Облик лютого медведя') > 0) then return self:bear_single() end
end

function BHelper.modules.druid.default:rotation_multiple()
    if (player:aura('Облик кошки') > 0) then return self:cat_multiple() end
    if (player:aura('Облик лютого медведя') > 0) then return self:bear_multiple() end
end

function BHelper.modules.druid.default:cat_single()
    if ((target:check_cast()) and (self.vars.silence) and (player:can_cast_on_enemy('Калечение'))) then
        return keybinds:show_spell('Калечение')
    end

    if ((player:get_power() <= 30) and (player:can_cast('Тигриное неистовство'))) then
        return keybinds:show_spell('Тигриное неистовство')
    end

    if ((player:aura('Дикий рев') == 0) and (player:can_cast('Дикий рев'))) then
        return keybinds:show_spell('Дикий рев')
    end

    if ((player:aura('Дикий рев') <= 2) and (player:can_cast('Дикий рев')) and
        (player:check_combo_points(4))) then return keybinds:show_spell('Дикий рев') end

    if ((player:aura('Дикий рев') <= 6) and
        (math.abs(target:aura('Разорвать') - player:aura('Дикий рев')) <= 1) and
        (player:check_combo_points(3)) and (player:can_cast('Дикий рев'))) then
        return keybinds:show_spell('Дикий рев')
    end

    if ((player:aura('Ясность мысли') == 0) and (target:aura('Глубокая рана') > 0) and
        (player:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        return keybinds:show_spell('Волшебный огонь (зверь)')
    end

    if ((target:aura('Увечье (кошка)') == 0) and (target:aura('Увечье (медведь)') == 0) and
        (target:aura('Травма') == 0) and (player:can_cast_on_enemy('Увечье (кошка)'))) then
        return keybinds:show_spell('Увечье (кошка)')
    end

    if (player:aura('Ясность мысли') > 0) then
        if ((self.behind_of_target) and (player:can_cast_on_enemy('Полоснуть'))) then
            return keybinds:show_spell('Полоснуть')
        end
        if ((not self.behind_of_target) and (player:can_cast_on_enemy('Увечье (кошка)'))) then
            return keybinds:show_spell('Увечье (кошка)')
        end
    end

    if ((target:aura('Разорвать', true) == 0) and (player:check_combo_points(5)) and
        (player:can_cast_on_enemy('Разорвать'))) then return keybinds:show_spell('Разорвать') end

    if ((player:aura('Дикий рев') >= 6) and
        ((target:aura('Разорвать', true) >= 6) or (player:aura(50334) > 0)) and
        ((player:get_power() <= 55) or (player:aura(50334) > 0)) and (player:check_combo_points(5)) and
        (player:can_cast_on_enemy('Свирепый укус'))) then
        return keybinds:show_spell('Свирепый укус')
    end

    if ((target:aura('Глубокая рана', true) == 0) and
        (player:can_cast_on_enemy('Глубокая рана'))) then
        return keybinds:show_spell('Глубокая рана')
    end

    if ((self.behind_of_target) and (player:can_cast_on_enemy('Полоснуть'))) then
        return keybinds:show_spell('Полоснуть')
    end

    if ((not self.behind_of_target) and (player:can_cast_on_enemy('Увечье (кошка)'))) then
        return keybinds:show_spell('Увечье (кошка)')
    end
end

function BHelper.modules.druid.default:cat_multiple()
    if ((player:aura('Ясность мысли') == 0) and
        (player:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        return keybinds:show_spell('Волшебный огонь (зверь)')
    end

    if ((player:get_power() <= 30) and (player:can_cast('Тигриное неистовство'))) then
        return keybinds:show_spell('Тигриное неистовство')
    end

    if ((player:aura('Дикий рев') == 0)) then
        if (player:can_cast('Дикий рев')) then return keybinds:show_spell('Дикий рев') end

        if (player:can_cast_on_enemy('Глубокая рана')) then
            return keybinds:show_spell('Глубокая рана')
        end
    else
        if (player:can_cast_on_enemy('Размах (кошка)')) then
            return keybinds:show_spell('Размах (кошка)')
        end
    end
end

function BHelper.modules.druid.default:bear_single()
    if (player:can_cast('Трепка')) then keybinds:show_attack('Трепка') end

    if ((target:check_cast()) and (self.vars.silence) and (player:can_cast_on_enemy('Оглушить'))) then
        return keybinds:show_spell('Оглушить')
    end

    if ((target:aura('Растерзать', true) > 0) and (target:aura('Растерзать', true) <= 2) and
        (player:can_cast_on_enemy('Растерзать'))) then return keybinds:show_spell('Растерзать') end

    if (player:can_cast_on_enemy('Увечье (медведь)')) then
        return keybinds:show_spell('Увечье (медведь)')
    end

    if ((target:aura('Устрашающий рев') == 0) and (player:can_cast('Устрашающий рев'))) then
        return keybinds:show_spell('Устрашающий рев')
    end

    if (((target:aura('Растерзать', true) <= 2) or (select(2, target:aura('Растерзать', true)) < 5)) and
        (player:can_cast_on_enemy('Растерзать'))) then return keybinds:show_spell('Растерзать') end

    if (player:can_cast('Размах (медведь)')) then
        return keybinds:show_spell('Размах (медведь)')
    end
end

function BHelper.modules.druid.default:bear_multiple()
    if (player:can_cast('Трепка')) then keybinds:show_attack('Трепка') end

    if ((target:check_cast()) and (self.vars.silence) and (player:can_cast_on_enemy('Оглушить'))) then
        return keybinds:show_spell('Оглушить')
    end

    if (player:can_cast_on_enemy('Увечье (медведь)')) then
        return keybinds:show_spell('Увечье (медведь)')
    end

    if ((target:aura('Устрашающий рев') == 0) and (player:can_cast('Устрашающий рев'))) then
        return keybinds:show_spell('Устрашающий рев')
    end

    if (player:can_cast('Размах (медведь)')) then
        return keybinds:show_spell('Размах (медведь)')
    end
end

function BHelper.modules.druid.default:stop()
    core.action:set('rotation_single')
end

function BHelper.modules.druid.default:UI_ERROR_MESSAGE(message)
    if (message == SPELL_FAILED_NOT_BEHIND) then
        self.behind_of_target = false
        timers:create(0.5, function()
            self.behind_of_target = true
        end, 'behind_of_target')
    end
end
