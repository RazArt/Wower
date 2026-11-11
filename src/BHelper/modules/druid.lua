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

local vars = nil

function BHelper.modules.druid.default:init()
    vars = self.vars

    if (player:spec() == 1) then self.settings.usable_equip = 'DPS' end
    if (player:spec() == 2) then self.settings.usable_equip = 'TANK' end

    self.behind_of_target = true

    keybinds:bind_macro('Reform', 'BUTTON5')

    keybinds:bind_item('Знак превосходства')

    self:register_event('UI_ERROR_MESSAGE')
end

function BHelper.modules.druid.default:macros()
    macros:create('Чардж',
                  '#showtooltip\n/cast [form:1] Звериная атака - медведь\n/cast [form:3] Звериная атака - кошка')
    macros:create('Волшебный огонь',
                  '#showtooltip\n/startattack\n/cast [form:0/2/4/5/6] !Облик кошки(Смена облика)\n/cast Волшебный огонь (зверь)')
    macros:create('Reform',
                  '/bh c\n/cast [form:0/1/2/4/5/6] !Облик кошки(Смена облика)\n/cast [form:3] !Облик лютого медведя(Смена облика)\n')
    macros:create('Калечение',
                  '#showtooltip\n/cast [form:1/2] Оглушить\n/cast [form:3] Калечение')
    macros:create('Озарение',
                  '#showtooltip Озарение\n/cast [@focus,help,nodead] Озарение\n/cast [@target,help,nodead] Озарение\n/cast [@mouseover,help,nodead] Озарение')
    macros:create('Крадущийся зверь',
                  '#showtooltip Крадущийся зверь\n/bh stop\n/cast [form:0/1/2/4/5/6] !Облик кошки(Смена облика)\n/cast [form:3] Крадущийся зверь')
end

function BHelper.modules.druid.default:put()
    keybinds:place_spell('Размах (кошка)', 73)
    keybinds:place_spell('Увечье (кошка)', 74)
    keybinds:place_spell('Глубокая рана', 75)
    keybinds:place_spell('Полоснуть', 76)
    keybinds:place_spell('Разорвать', 77)
    keybinds:place_spell('Свирепый укус', 78)
    keybinds:place_spell('Дикий рев', 79)
    keybinds:place_spell('Тигриное неистовство', 80)
    keybinds:place_spell('Берсерк', 81)
    keybinds:place_spell('Берсерк(Расовая)', 82)
    keybinds:place_spell('Порыв', 83)
    keybinds:place_spell('Попятиться', 84)
    keybinds:place_spell('Рык', 61)
    keybinds:place_spell('Устрашающий рев', 62)
    keybinds:place_spell('Размах (медведь)', 63)
    keybinds:place_spell('Увечье (медведь)', 64)
    keybinds:place_spell('Растерзать', 65)
    keybinds:place_spell('Вызывающий рев', 66)
    keybinds:place_spell('Берсерк', 69)
    keybinds:place_spell('Берсерк(Расовая)', 70)
    keybinds:place_spell('Неистовое восстановление', 71)
    keybinds:place_spell('Исступление', 72)
    keybinds:place_macro('Чардж', 15)
    keybinds:place_macro('Волшебный огонь', 16)
    keybinds:place_macro('Калечение', 17)
    keybinds:place_spell('Возрождение', 19)
    keybinds:place_spell('Дубовая кожа', 20)
    keybinds:place_spell('Смерч', 21)
    keybinds:place_macro('Озарение', 22)
    keybinds:place_spell('Инстинкты выживания', 23)
    keybinds:place_macro('Крадущийся зверь', 24)
    keybinds:place_spell('Снятие проклятия', 27)
    keybinds:place_spell('Устранение яда', 28)
    keybinds:place_spell('Омоложение', 29)
    keybinds:place_spell('Целительное прикосновение', 30)
    keybinds:place_spell('Спячка', 35)
    keybinds:place_spell('Гнев деревьев', 36)
    keybinds:place_spell('Оживление', 47)
    keybinds:place_spell('Шипы', 47)
    keybinds:place_spell('Дар дикой природы', 47)
end

function BHelper.modules.druid.default:execute()
    if ((player:health_on_percent() < 30) and (player:can_cast('Инстинкты выживания'))) then
        return keybinds:show_spell('Инстинкты выживания')
    end

    if ((player:health_on_percent() < 30) and (player:can_cast('Неистовое восстановление'))) then
        return keybinds:show_spell('Неистовое восстановление')
    end

    if ((player:health_on_percent() < 60) and (player:can_cast('Дубовая кожа'))) then
        return keybinds:show_spell('Дубовая кожа')
    end

    if ((player:health_on_percent() < 60) and (player:can_cast('Исступление'))) then
        return keybinds:show_spell('Исступление')
    end

    if ((player:location_is_icc()) and (not player:form('Облик лютого медведя'))) then
        if ((target:is_player()) and (player:can_cast_on_enemy('Смерч'))) then
            return keybinds:show_spell('Смерч')
        end
        if ((target:name() == 'Имирьярская охотница') and
            (target:check_cast('Быстрострел')) and (player:can_cast_on_enemy('Смерч'))) then
            return keybinds:show_spell('Смерч')
        end
    end

    if ((not player:form('Облик кошки')) and (not player:form('Облик лютого медведя'))) then
        return keybinds:show_macro('Reform')
    end

    if ((not player:has_safety_threat()) and (not target:is_player()) and (player:can_cast('Попятиться'))) then
        return keybinds:show_spell('Попятиться')
    end

    if (player:is_burst() and (not self.burst_cooldown)) then
        if ((player:form('Облик лютого медведя')) and (player:can_cast('Берсерк'))) then
            return keybinds:show_spell('Берсерк')
        end

        if ((player:form('Облик кошки')) and (player:aura('Тигриное неистовство') == 0) and
            (player:power() <= 80) and (player:can_cast('Берсерк'))) then
            return keybinds:show_spell('Берсерк')
        end

        if ((player:aura(50334) > 0) and (player:is_equipped_item('Знак превосходства')) and
            (player:can_use_item('Знак превосходства'))) then
            return keybinds:show_item('Знак превосходства')
        end

        if (player:can_cast('Берсерк(Расовая)')) then
            return keybinds:show_spell('Берсерк(Расовая)')
        end
    end

    if ((target:check_cast()) and (vars.silence) and (player:can_cast_on_enemy('Калечение'))) then
        return keybinds:show_spell('Калечение')
    end

    if ((target:check_cast()) and (vars.silence) and (player:can_cast_on_enemy('Оглушить'))) then
        return keybinds:show_spell('Оглушить')
    end

    if (player:can_cast('Трепка')) then keybinds:show_attack('Трепка') end
end

function BHelper.modules.druid.default:rotation_single()
    if (player:form('Облик кошки')) then return self:cat_single() end
    if (player:form('Облик лютого медведя')) then return self:bear_single() end
end

function BHelper.modules.druid.default:rotation_multiple()
    if (player:form('Облик кошки')) then return self:cat_multiple() end
    if (player:form('Облик лютого медведя')) then return self:bear_multiple() end
end

function BHelper.modules.druid.default:cat_single()
    if ((player:power() <= 30) and (player:can_cast('Тигриное неистовство'))) then
        return keybinds:show_spell('Тигриное неистовство')
    end

    if ((player:aura('Дикий рев') == 0) and (player:can_cast('Дикий рев'))) then
        return keybinds:show_spell('Дикий рев')
    end

    if ((player:aura('Дикий рев') <= 2) and (player:can_cast('Дикий рев')) and
        (player:has_combo_points(4))) then return keybinds:show_spell('Дикий рев') end

    if ((player:aura('Дикий рев') <= 6) and
        (math.abs(target:aura('Разорвать') - player:aura('Дикий рев')) <= 1) and
        (player:has_combo_points(3)) and (player:can_cast('Дикий рев'))) then
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
        elseif ((not self.behind_of_target) and (player:can_cast_on_enemy('Увечье (кошка)'))) then
            return keybinds:show_spell('Увечье (кошка)')
        end
    end

    if ((target:aura('Разорвать', true) == 0) and (player:has_combo_points(5)) and
        (player:can_cast_on_enemy('Разорвать'))) then return keybinds:show_spell('Разорвать') end

    if ((player:aura('Дикий рев') >= 6) and
        ((target:aura('Разорвать', true) >= 6) or (player:aura(50334) > 0)) and
        ((player:power() <= 55) or (player:aura(50334) > 0)) and (player:has_combo_points(5)) and
        (player:can_cast_on_enemy('Свирепый укус'))) then
        return keybinds:show_spell('Свирепый укус')
    end

    if ((target:aura('Глубокая рана', true) == 0) and
        (player:can_cast_on_enemy('Глубокая рана'))) then
        return keybinds:show_spell('Глубокая рана')
    end

    if ((self.behind_of_target) and (player:can_cast_on_enemy('Полоснуть'))) then
        return keybinds:show_spell('Полоснуть')
    elseif ((not self.behind_of_target) and (player:can_cast_on_enemy('Увечье (кошка)'))) then
        return keybinds:show_spell('Увечье (кошка)')
    end
end

function BHelper.modules.druid.default:cat_multiple()
    if ((player:aura('Ясность мысли') == 0) and
        (player:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        return keybinds:show_spell('Волшебный огонь (зверь)')
    end

    if ((player:power() <= 30) and (player:can_cast('Тигриное неистовство'))) then
        return keybinds:show_spell('Тигриное неистовство')
    end

    if ((player:aura('Дикий рев') == 0)) then
        if (player:can_cast('Дикий рев')) then return keybinds:show_spell('Дикий рев') end

        if (player:can_cast_on_enemy('Глубокая рана')) then
            return keybinds:show_spell('Глубокая рана')
        end
    end

    if (player:can_cast_on_enemy('Размах (кошка)')) then
        return keybinds:show_spell('Размах (кошка)')
    end
end

function BHelper.modules.druid.default:bear_single()
    if ((target:aura('Растерзать', true) > 0) and (target:aura('Растерзать', true) <= 2) and
        (player:can_cast_on_enemy('Растерзать'))) then return keybinds:show_spell('Растерзать') end

    if (player:can_cast_on_enemy('Увечье (медведь)')) then
        return keybinds:show_spell('Увечье (медведь)')
    end

    if ((target:aura('Устрашающий рев') == 0) and (player:can_cast('Устрашающий рев'))) then
        return keybinds:show_spell('Устрашающий рев')
    end

    if (((target:aura('Растерзать', true) <= 2) or (target:aura_count('Растерзать', true) < 5)) and
        (player:can_cast_on_enemy('Растерзать'))) then return keybinds:show_spell('Растерзать') end

    if (player:can_cast('Размах (медведь)', true)) then
        return keybinds:show_spell('Размах (медведь)')
    end
end

function BHelper.modules.druid.default:bear_multiple()
    if (player:can_cast_on_enemy('Увечье (медведь)')) then
        return keybinds:show_spell('Увечье (медведь)')
    end

    if ((target:aura('Устрашающий рев') == 0) and (player:can_cast('Устрашающий рев'))) then
        return keybinds:show_spell('Устрашающий рев')
    end

    if (player:can_cast('Размах (медведь)', true)) then
        return keybinds:show_spell('Размах (медведь)')
    end
end

function BHelper.modules.druid.default:UI_ERROR_MESSAGE(message)
    if (message == SPELL_FAILED_NOT_BEHIND) then
        self.behind_of_target = false
        timers:create(0.5, function()
            self.behind_of_target = true
        end, 'behind_of_target')
    end
end
