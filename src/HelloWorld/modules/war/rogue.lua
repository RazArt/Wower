function HelloWorld.war.rogue:init()
    self:stop()
end

function HelloWorld.war.rogue:update()
    self.parent:general_update()
end

function HelloWorld.war.rogue:rotation_1()
    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Пинок')) then
        Keystroke:show(2)
        return
    end

    if ((self.parent:get_player_buff_time('Мясорубка') < 2) and
        (self.parent:can_cast('Мясорубка')) and (self.parent:get_combo_points() > 3)) then
        Keystroke:show(4)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Рваная рана', true) == 0) and
        (self.parent:can_cast('Рваная рана')) and (self.parent:get_combo_points() > 4)) then
        Keystroke:show(6)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Рваная рана', true) > 4) and
        (self.parent:can_cast('Потрошение')) and (self.parent:get_combo_points() > 3)) then
        Keystroke:show(7)
        return
    end

    if (self.parent:can_cast('Коварный удар')) then
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
