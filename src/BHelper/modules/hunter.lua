function BHelper.modules.hunter:init()
    self.vars.mana_regeneration = false
    self.vars.mark = false
    self.vars.acrane_shot = false
end

function BHelper.modules.hunter:rotation_1()
    if ((self.parent:get_mana_on_percent('player') < 20) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((self.parent:get_mana_on_percent('player') > 60) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (self.parent:get_player_buff_time('Дух дракондора') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух дракондора'))) then
        Keystroke:show_spell(4, false, false, true)
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (self.parent:get_player_buff_time('Дух гадюки') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух гадюки'))) then
        Keystroke:show_spell(5, false, false, true)
        return
    end

    if ((self.parent:get_player_buff_time('Аура меткого выстрела') == 0) and
        (self.parent:can_cast('Аура меткого выстрела'))) then
        Keystroke:show_spell(3, false, false, true)
        return
    end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Глушащий выстрел')) then
        Keystroke:show_spell(34)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Метка охотника') == 0) and
        (self.parent:can_cast_on_enemy('Метка охотника')) and self.vars.mark) then
        Keystroke:show_spell(2, false, false, true)
        return
    end

    if ((self.vars.mana_regeneration == false) and
        (self.parent:get_ememy_debuff_time('Укус змеи', true) == 0) and
        (self.parent:can_cast_on_enemy('Укус змеи'))) then
        Keystroke:show_spell(2, false, false, false, true)
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (self.parent:get_ememy_debuff_time('Укус гадюки', true) == 0) and
        (self.parent:can_cast_on_enemy('Укус гадюки'))) then
        Keystroke:show_spell(3, false, false, false, true)
        return
    end

    if (self.parent:can_cast_on_enemy('Убийственный выстрел')) then
        Keystroke:show_spell(3)
        return
    end

    if (self.parent:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        Keystroke:show_spell(7, true)
        return
    end

    if (self.parent:can_cast_on_enemy('Выстрел химеры')) then
        Keystroke:show_spell(4)
        return
    end

    if (self.parent:can_cast_on_enemy('Прицельный выстрел')) then
        Keystroke:show_spell(6)
        return
    end

    if (self.parent:can_cast_on_enemy('Чародейский выстрел') and
        self.vars.acrane_shot) then
        Keystroke:show_spell(8)
        return
    end

    if (self.parent:can_cast_on_enemy('Верный выстрел')) then
        Keystroke:show_spell(5)
        return
    end
end

function BHelper.modules.hunter:rotation_2()
    if ((self.parent:get_mana_on_percent('player') < 20) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((self.parent:get_mana_on_percent('player') > 60) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (self.parent:get_player_buff_time('Дух дракондора') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух дракондора'))) then
        Keystroke:show_spell(4, false, false, true)
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (self.parent:get_player_buff_time('Дух гадюки') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух гадюки'))) then
        Keystroke:show_spell(5, false, false, true)
        return
    end

    if ((self.parent:get_player_buff_time('Аура меткого выстрела') == 0) and
        (self.parent:can_cast('Аура меткого выстрела'))) then
        Keystroke:show_spell(3, false, false, true)
        return
    end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Глушащий выстрел')) then
        Keystroke:show_spell(34)
        return
    end

    if (self.parent:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        Keystroke:show_spell(7, true)
        return
    end

    if (self.parent:can_cast_on_point('Град стрел')) then
        Keystroke:show_spell(33, true)
        return
    end
end
