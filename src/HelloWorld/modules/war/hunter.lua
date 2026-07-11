function HelloWorld.war.hunter:init()
    self.vars.mana_regeneration = false
    self:stop()
end

function HelloWorld.war.hunter:update()
    self.parent:general_update()
end

function HelloWorld.war.hunter:rotation_1()
    if ((self.parent:get_mana_on_percent('player') < 20) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((self.parent:get_mana_on_percent('player') > 60) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (self.parent:get_player_buff_time('Дух дракондора') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух дракондора'))) then
        Keystroke:show(10, 0, 0, 0, 1)
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (self.parent:get_player_buff_time('Дух гадюки') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух гадюки'))) then
        Keystroke:show(11, 0, 0, 0, 1)
        return
    end

    if ((self.parent:get_player_buff_time('Аура меткого выстрела') == 0) and
        (self.parent:can_cast('Аура меткого выстрела'))) then
        Keystroke:show(9, 0, 0, 0, 1)
        return
    end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Глушащий выстрел')) then
        Keystroke:show(11)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Метка охотника') == 0) and
        (self.parent:can_cast_on_enemy('Метка охотника')) and (IsShiftKeyDown() ~= 1)) then
        Keystroke:show(8, 0, 0, 0, 1)
        return
    end

    if ((self.vars.mana_regeneration == false) and
        (self.parent:get_ememy_debuff_time('Укус змеи', true) == 0) and
        (self.parent:can_cast_on_enemy('Укус змеи'))) then
        Keystroke:show(3)
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (self.parent:get_ememy_debuff_time('Укус гадюки', true) == 0) and
        (self.parent:can_cast_on_enemy('Укус гадюки'))) then
        Keystroke:show(4)
        return
    end

    if (self.parent:can_cast_on_enemy('Убийственный выстрел')) then
        Keystroke:show(5)
        return
    end

    if (self.parent:can_cast_on_enemy('Выстрел химеры')) then
        Keystroke:show(6)
        return
    end

    if (self.parent:can_cast_on_enemy('Прицельный выстрел')) then
        Keystroke:show(7)
        return
    end

    if (self.parent:can_cast_on_enemy('Чародейский выстрел')) then
        Keystroke:show(8)
        return
    end

    if (self.parent:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        Keystroke:show(9, 1)
        return
    end

    if (self.parent:can_cast_on_enemy('Верный выстрел')) then
        Keystroke:show(10)
        return
    end
end

function HelloWorld.war.hunter:rotation_2()
    if ((self.parent:get_mana_on_percent('player') < 20) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((self.parent:get_mana_on_percent('player') > 60) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (self.parent:get_player_buff_time('Дух дракондора') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух дракондора'))) then
        Keystroke:show(10, 0, 0, 0, 1)
        return
    end

    if ((self.vars.mana_regeneration == true) and
        (self.parent:get_player_buff_time('Дух гадюки') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух гадюки'))) then
        Keystroke:show(11, 0, 0, 0, 1)
        return
    end

    if ((self.parent:get_player_buff_time('Аура меткого выстрела') == 0) and
        (self.parent:can_cast('Аура меткого выстрела'))) then
        Keystroke:show(9, 0, 0, 0, 1)
        return
    end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Глушащий выстрел')) then
        Keystroke:show(11)
        return
    end

    if (self.parent:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        Keystroke:show(9, 1)
        return
    end

    if (self.parent:can_cast_on_point('Град стрел')) then
        Keystroke:show(33, 1)
        return
    end
end
