function BHelper.modules.hunter.default:init()
    if (self.vars.mana_regeneration == nil) then self.vars.mana_regeneration = false end
    if (self.vars.mark == nil) then self.vars.mark = true end
    if (self.vars.acrane_shot == nil) then self.vars.acrane_shot = true end

    BHelper.keybinds:unbind_all()
    BHelper.keybinds:bind_macro('BH: Цель')
    BHelper.keybinds:bind_spell('Дух дракондора')
    BHelper.keybinds:bind_spell('Дух гадюки')
    BHelper.keybinds:bind_spell('Аура меткого выстрела')
    BHelper.keybinds:bind_spell('Глушащий выстрел')
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
    BHelper.keybinds:bind_spell('Команда "Взять!"')
end

function BHelper.modules.hunter.default:macros()
    BHelper.macros:delete_all()
    BHelper.macros:create('Атака', '/petattack [target=target]', 19, false, 827)
    BHelper.macros:create('Назад', '/petfollow', 20, false, 824)
    BHelper.macros:create('Метка охотника',
                          '#showtooltip Метка охотника\n/bh tv mark', 41)
    BHelper.macros:create('Чародейский выстрел',
                          '#showtooltip Чародейский выстрел\n/bh tv acrane_shot',
                          42)
    BHelper.macros:create('Быстрая стрельба',
                          '#showtooltip Быстрая стрельба\n/bh c 0.5\n/cast Берсерк\n/cast Быстрая стрельба\n/cast Зов дикой природы',
                          9)
    BHelper.macros:create('Готовность',
                          '#showtooltip Готовность\n/bh c 0.5\n/cast Готовность',
                          10)
    BHelper.macros:create('Притвориться мертвым',
                          '#showtooltip Притвориться мертвым\n/bh c 0.5\n/cast Притвориться мертвым',
                          11)
    BHelper.macros:create('Сдерживание',
                          '#showtooltip Сдерживание\n/bh c 0.5\n/cast Сдерживание',
                          12)
    BHelper.macros:create('Перенаправление',
                          '#showtooltip Перенаправление\n/bh c 0.5\n/cast [@focus,help,nodead] Перенаправление\n/cast [@target,help,nodead] Перенаправление\n/cast [@mouseover,help,nodead] Перенаправление',
                          15)
    BHelper.macros:create('S',
                          '/petattack [target=target]\n/startattack\n/bh sa rotation_single\n/bh',
                          13, false, 1093)
    BHelper.macros:create('M',
                          '/petattack [target=target]\n/startattack\n/bh sa rotation_multiple\n/bh',
                          14, false, 1094)
end

function BHelper.modules.hunter.default:rotation_single()
    if ((BHelper:get_mana_on_percent('player') < 20) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((BHelper:get_mana_on_percent('player') > 60) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (BHelper:get_player_buff_time('Дух дракондора') == 0) and
        (BHelper:get_player_buff_time('Дух дикой природы') == 0) and
        (BHelper:can_cast('Дух дракондора'))) then
        BHelper.keybinds:show_spell('Дух дракондора')
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (BHelper:get_player_buff_time('Дух гадюки') == 0) and
        (BHelper:get_player_buff_time('Дух дикой природы') == 0) and
        (BHelper:can_cast('Дух гадюки'))) then
        BHelper.keybinds:show_spell('Дух гадюки')
        return
    end

    if ((BHelper:get_player_buff_time('Аура меткого выстрела') == 0) and
        (BHelper:can_cast('Аура меткого выстрела'))) then
        BHelper.keybinds:show_spell('Аура меткого выстрела')
        return
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Глушащий выстрел')) then
        BHelper.keybinds:show_spell('Глушащий выстрел')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Метка охотника') == 0) and
        (BHelper:can_cast_on_enemy('Метка охотника')) and self.vars.mark) then
        BHelper.keybinds:show_spell('Метка охотника')
        return
    end

    if (BHelper:can_cast('Команда "Взять!"')) then
        BHelper.keybinds:show_help('Команда "Взять!"')
        return
    end

    if ((self.vars.mana_regeneration == false) and
        (BHelper:get_ememy_debuff_time('Укус змеи', true) == 0) and
        (BHelper:can_cast_on_enemy('Укус змеи'))) then
        BHelper.keybinds:show_spell('Укус змеи')
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (BHelper:get_ememy_debuff_time('Укус гадюки', true) == 0) and
        (BHelper:can_cast_on_enemy('Укус гадюки'))) then
        BHelper.keybinds:show_spell('Укус гадюки')
        return
    end

    if (BHelper:can_cast_on_enemy('Убийственный выстрел')) then
        BHelper.keybinds:show_spell('Убийственный выстрел')
        return
    end

    if (BHelper:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        BHelper.keybinds:show_spell('Бросок ловушки: взрывная ловушка')
        return
    end

    if (BHelper:can_cast_on_enemy('Выстрел химеры')) then
        BHelper.keybinds:show_spell('Выстрел химеры')
        return
    end

    if (BHelper:can_cast_on_enemy('Прицельный выстрел')) then
        BHelper.keybinds:show_spell('Прицельный выстрел')
        return
    end

    if (BHelper:can_cast_on_enemy('Чародейский выстрел') and self.vars.acrane_shot) then
        BHelper.keybinds:show_spell('Чародейский выстрел')
        return
    end

    if (BHelper:can_cast_on_enemy('Верный выстрел')) then
        BHelper.keybinds:show_spell('Верный выстрел')
        return
    end
end

function BHelper.modules.hunter.default:rotation_multiple()
    if ((BHelper:get_mana_on_percent('player') < 20) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((BHelper:get_mana_on_percent('player') > 60) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (BHelper:get_player_buff_time('Дух дракондора') == 0) and
        (BHelper:get_player_buff_time('Дух дикой природы') == 0) and
        (BHelper:can_cast('Дух дракондора'))) then
        BHelper.keybinds:show_spell('Дух дракондора')
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (BHelper:get_player_buff_time('Дух гадюки') == 0) and
        (BHelper:get_player_buff_time('Дух дикой природы') == 0) and
        (BHelper:can_cast('Дух гадюки'))) then
        BHelper.keybinds:show_spell('Дух гадюки')
        return
    end

    if ((BHelper:get_player_buff_time('Аура меткого выстрела') == 0) and
        (BHelper:can_cast('Аура меткого выстрела'))) then
        BHelper.keybinds:show_spell('Аура меткого выстрела')
        return
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Глушащий выстрел')) then
        BHelper.keybinds:show_spell('Глушащий выстрел')
        return
    end

    if (BHelper:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        BHelper.keybinds:show_spell('Бросок ловушки: взрывная ловушка')
        return
    end

    if (BHelper:can_cast_on_point('Град стрел')) then
        BHelper.keybinds:show_spell('Град стрел')
        return
    end
end
