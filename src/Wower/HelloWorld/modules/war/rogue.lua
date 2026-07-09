function HelloWorld.war.rogue:init()
    self:set_step(HelloWorld:get_player_spec())
end

function HelloWorld.war.rogue:step_1()
    self.parent:general_update()

    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Пинок')) then
        HelloWorld:show(10)
    else
        HelloWorld:hide(10)
    end

    if ((self.parent:get_player_buff_time('Мясорубка') < 2) and
        (self.parent:can_cast('Мясорубка')) and (self.parent:get_combo_points() > 3)) then
        HelloWorld:show(11)
    else
        HelloWorld:hide(11)
    end

    if ((self.parent:get_ememy_debuff_time('Рваная рана', true) == 0) and
        (self.parent:can_cast('Рваная рана')) and (self.parent:get_combo_points() > 4)) then
        HelloWorld:show(12)
    else
        HelloWorld:hide(12)
    end

    if ((self.parent:get_ememy_debuff_time('Рваная рана', true) > 4) and
        (self.parent:can_cast('Потрошение')) and (self.parent:get_combo_points() > 3)) then
        HelloWorld:show(13)
    else
        HelloWorld:hide(13)
    end

    if (self.parent:can_cast('Коварный удар')) then
        HelloWorld:show(14)
    else
        HelloWorld:hide(14)
    end

    if (self.parent:can_cast('Веер клинков')) then
        HelloWorld:show(15)
    else
        HelloWorld:hide(15)
    end
end
