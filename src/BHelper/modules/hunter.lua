function BHelper.modules.hunter.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.mana_regeneration == nil) then self.vars.mana_regeneration = false end
    if (self.vars.mark == nil) then self.vars.mark = true end
    if (self.vars.acrane_shot == nil) then self.vars.acrane_shot = false end
    if (self.vars.misdirection == nil) then self.vars.acrane_shot = true end

    BHelper.keybinds:bind_macro('BH: Цель')
    BHelper.keybinds:bind_spell('Дух дракондора')
    BHelper.keybinds:bind_spell('Дух гадюки')
    BHelper.keybinds:bind_spell('Аура меткого выстрела')
    BHelper.keybinds:bind_spell('Глушащий выстрел')
    BHelper.keybinds:bind_spell('Усмиряющий выстрел')
    BHelper.keybinds:bind_spell('Метка охотника')
    BHelper.keybinds:bind_spell('Укус змеи')
    BHelper.keybinds:bind_spell('Укус гадюки')
    BHelper.keybinds:bind_spell('Убийственный выстрел')
    BHelper.keybinds:bind_spell('Бросок ловушки: взрывная ловушка', true)
    BHelper.keybinds:bind_spell('Выстрел химеры')
    BHelper.keybinds:bind_spell('Прицельный выстрел')
    BHelper.keybinds:bind_spell('Чародейский выстрел')
    BHelper.keybinds:bind_spell('Верный выстрел')
    BHelper.keybinds:bind_spell('Град стрел', true)
    BHelper.keybinds:bind_spell('Ледяная ловушка')
    BHelper.keybinds:bind_spell('Команда "Взять!"')
    BHelper.keybinds:bind_spell('Быстрая стрельба')
    BHelper.keybinds:bind_spell('Зов дикой природы')
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')
    BHelper.keybinds:bind_item('Знак превосходства')
    BHelper.keybinds:bind_macro('Перенаправление')
end

function BHelper.modules.hunter.default:macros()
    BHelper.macros:create('Атака', '/petattack [@target]', 19, false, 973)
    BHelper.macros:create('Назад', '/petfollow', 20, false, 970)
    BHelper.macros:create('Отрыв', '#showtooltip\n/bh c\n/stopcasting\n/cast Отрыв', 1)
    BHelper.macros:create('Дух дикой природы',
                          '#showtooltip Дух дикой природы\n/bh c\n/stopcasting\n/cast Дух дикой природы',
                          21)
    BHelper.macros:create('Ледяная ловушка',
                          '#showtooltip Ледяная ловушка\n/bh c\n/stopcasting\n/cast Ледяная ловушка',
                          22)
    BHelper.macros:create('Метка охотникаTV',
                          '#showtooltip Метка охотника\n/bh tv mark', 41)
    BHelper.macros:create('Чародейский выстрелTV',
                          '#showtooltip Чародейский выстрел\n/bh tv acrane_shot',
                          42)
    BHelper.macros:create('Быстрая стрельба',
                          '#showtooltip Быстрая стрельба\n/bh c\n/stopcasting\n/cast Берсерк\n/cast Быстрая стрельба\n/cast Зов дикой природы',
                          9)
    BHelper.macros:create('Готовность',
                          '#showtooltip Готовность\n/bh c\n/stopcasting\n/cast Готовность',
                          10)
    BHelper.macros:create('Притвориться мертвым',
                          '#showtooltip Притвориться мертвым\n/bh c\n/stopcasting\n/cast Притвориться мертвым',
                          11)
    BHelper.macros:create('Сдерживание',
                          '#showtooltip Сдерживание\n/bh c\n/stopcasting\n/cast Сдерживание',
                          12)
    BHelper.macros:create('Перенаправление',
                          '#showtooltip Перенаправление\n/bh c\n/stopcasting\n/cast [@focus,help,nodead] Перенаправление\n/cast [@target,help,nodead] Перенаправление\n/cast [@mouseover,help,nodead] Перенаправление',
                          15)
    BHelper.macros:create('Глушащий выстрел',
                          '#showtooltip\n/bh c\n/stopcasting\n/cast Глушащий выстрел',
                          17)
    BHelper.macros:create('Усмиряющий выстрел',
                          '#showtooltip\n/bh c\n/stopcasting\n/cast Усмиряющий выстрел',
                          18)
    BHelper.macros:create('S', '/startattack\n/petattack [@target]\n/bh sa rotation_single\n/bh',
                          13, true, 1263)
    BHelper.macros:create('M', '/startattack\n/petattack [@target]\n/bh sa rotation_multiple\n/bh',
                          14, true, 1264)
end

function BHelper.modules.hunter.default:update()
    if ((BHelper.player:get_mana_on_percent('player') < 10) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((BHelper.player:get_mana_on_percent('player') > 40) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (BHelper.player:get_buff_time('Дух дракондора') == 0) and
        (BHelper.player:get_buff_time('Дух дикой природы') == 0) and
        (BHelper.player:can_cast('Дух дракондора'))) then
        return BHelper.keybinds:show_spell('Дух дракондора')
    end

    if ((self.vars.mana_regeneration == true) and
        (BHelper.player:get_buff_time('Дух гадюки') == 0) and
        (BHelper.player:get_buff_time('Дух дикой природы') == 0) and
        (BHelper.player:can_cast('Дух гадюки'))) then
        return BHelper.keybinds:show_spell('Дух гадюки')
    end

    if ((BHelper.player:get_buff_time('Аура меткого выстрела') == 0) and
        (BHelper.player:can_cast('Аура меткого выстрела'))) then
        return BHelper.keybinds:show_spell('Аура меткого выстрела')
    end

    if (BHelper.target:check_cast() and
        BHelper.player:can_cast_on_enemy('Глушащий выстрел')) then
        return BHelper.keybinds:show_spell('Глушащий выстрел')
    end
end

function BHelper.modules.hunter.default:rotation_single()
    if (BHelper.player:can_cast_on_enemy('Убийственный выстрел')) then
        return BHelper.keybinds:show_spell('Убийственный выстрел')
    end

    if ((BHelper.target:get_debuff_time('Метка охотника') == 0) and
        (BHelper.player:can_cast_on_enemy('Метка охотника')) and self.vars.mark) then
        return BHelper.keybinds:show_spell('Метка охотника')
    end

    if (BHelper.player:can_cast('Команда "Взять!"')) then
        return BHelper.keybinds:show_help('Команда "Взять!"')
    end

    if ((self.vars.mana_regeneration == false) and
        (BHelper.target:get_debuff_time('Укус змеи', true) == 0) and
        (BHelper.player:can_cast_on_enemy('Укус змеи'))) then
        return BHelper.keybinds:show_spell('Укус змеи')
    end

    if ((self.vars.mana_regeneration == true) and
        (BHelper.target:get_debuff_time('Укус гадюки', true) == 0) and
        (BHelper.player:can_cast_on_enemy('Укус гадюки'))) then
        return BHelper.keybinds:show_spell('Укус гадюки')
    end

    if (BHelper.player:check_burst_mode()) then
        if ((BHelper.player:get_buff_time('Быстрая стрельба') == 0) and
            (BHelper.player:can_cast('Быстрая стрельба'))) then
            return BHelper.keybinds:show_spell('Быстрая стрельба')
        end

        if ((BHelper.player:get_buff_time('Зов дикой природы') == 0) and
            (BHelper.player:can_cast('Зов дикой природы'))) then
            return BHelper.keybinds:show_spell('Зов дикой природы')
        end

        if ((BHelper.player:get_buff_time(50334) > 0) and
            (BHelper.player:check_equipped_item('Знак превосходства')) and
            (BHelper.player:can_use_item('Знак превосходства'))) then
            return BHelper.keybinds:show_item('Знак превосходства')
        end

        if ((BHelper.player:get_buff_time('Быстрая стрельба') == 0) and
            (not BHelper.player:check_heroism_buff()) and (not BHelper.vars.cooldown_berserker) and
            (BHelper.player:can_cast('Берсерк(Расовая)'))) then
            return BHelper.keybinds:show_spell('Берсерк(Расовая)')
        end
    end

    if (BHelper.player:can_cast_on_point(
        'Бросок ловушки: взрывная ловушка') and
        (not BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell(
                   'Бросок ловушки: взрывная ловушка')
    end

    if (BHelper.player:can_cast_on_enemy('Перенаправление') and
        (self.vars.misdirection)) then
        return BHelper.keybinds:show_macro('Перенаправление')
    end

    if (BHelper.player:can_cast_on_enemy('Выстрел химеры')) then
        return BHelper.keybinds:show_spell('Выстрел химеры')
    end

    if (BHelper.player:can_cast_on_enemy('Прицельный выстрел')) then
        return BHelper.keybinds:show_spell('Прицельный выстрел')
    end

    if (BHelper.player:can_cast_on_enemy('Чародейский выстрел') and
        (self.vars.acrane_shot)) then
        return BHelper.keybinds:show_spell('Чародейский выстрел')
    end

    if (BHelper.player:can_cast_on_enemy('Верный выстрел') and
        (not BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell('Верный выстрел')
    end
end

function BHelper.modules.hunter.default:rotation_multiple()
    if (BHelper.player:can_cast_on_point(
        'Бросок ловушки: взрывная ловушка') and
        (not BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell(
                   'Бросок ловушки: взрывная ловушка')
    end

    if (BHelper.player:can_cast_on_point('Град стрел') and
        (not BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell('Град стрел')
    end
end
