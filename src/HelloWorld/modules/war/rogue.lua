function HelloWorld.war.rogue:rotation_1()
    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Пинок')) then
        Keystroke:show(2)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Ослабление доспеха') == 0) and
        (self.parent:can_cast_on_enemy('Ослабление доспеха'))) then
        Keystroke:show(3)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Ослабление доспеха') <= 3) and
        (self.parent:can_cast_on_enemy('Ослабление доспеха')) and
        (self.parent:check_combo_points(4))) then
        Keystroke:show(3)
        return
    end

    if ((self.parent:get_player_buff_time('Мясорубка') == 0) and
        (self.parent:can_cast('Мясорубка'))) then
        Keystroke:show(4)
        return
    end

    if ((self.parent:get_player_buff_time('Мясорубка') < 5) and
        (self.parent:can_cast('Мясорубка')) and (self.parent:check_combo_points(5))) then
        Keystroke:show(4)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Рваная рана', true) < 2) and
        (self.parent:can_cast_on_enemy('Рваная рана')) and
        (self.parent:check_combo_points(5))) then
        Keystroke:show(6)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Рваная рана', true) > 4) and
        (self.parent:can_cast_on_enemy('Потрошение')) and
        (self.parent:check_combo_points(3))) then
        Keystroke:show(7)
        return
    end

    if (self.parent:can_cast_on_enemy('Коварный удар')) then
        Keystroke:show(5)
        return
    end
end

function HelloWorld.war.rogue:rotation_2()
    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Пинок')) then
        Keystroke:show(2)
    end

    if (self.parent:can_cast('Веер клинков')) then
        Keystroke:show(33)
        return
    end
end
