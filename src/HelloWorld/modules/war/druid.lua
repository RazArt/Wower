function HelloWorld.war.druid:init()
    self:stop()
end

function HelloWorld.war.druid:update()
    self.parent:general_update()
end

function HelloWorld.war.druid:rotation_1()
    if (self.parent:get_player_buff_time('Облик кошки') < 0) then
        if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Калечение')) then
            Keystroke:show(16)
            return
        end

        if ((self.parent:get_player_buff_time('Ясность мысли') > 0) and
            (self.parent:can_cast_on_enemy('Полоснуть'))) then
            Keystroke:show(6)
            return
        end

        if ((self.parent:get_power() <= 30) and
            (self.parent:can_cast('Тигриное неистовство'))) then
            Keystroke:show(12)
            return
        end

        if ((self.parent:get_player_buff_time('Дикий рев') == 0) and
            (self.parent:can_cast('Дикий рев'))) then
            Keystroke:show(2)
            return
        end

        if ((self.parent:get_player_buff_time('Дикий рев') <= 3) and
            (self.parent:can_cast('Дикий рев')) and (self.parent:check_combo_points(4))) then
            Keystroke:show(2)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Разорвать', true) <= 2) and
            (self.parent:can_cast_on_enemy('Разорвать')) and
            (self.parent:check_combo_points(5))) then
            Keystroke:show(7)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Разорвать', true) >= 8) and
            ((self.parent:get_player_buff_time('Дикий рев') >= 8)) and
            (self.parent:can_cast_on_enemy('Свирепый укус')) and
            (self.parent:check_combo_points(5))) then
            Keystroke:show(5)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Увечье (кошка)') == 0) and
            (self.parent:get_ememy_debuff_time('Увечье (медведь)') == 0) and
            (self.parent:can_cast_on_enemy('Увечье (кошка)'))) then
            Keystroke:show(3)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Глубокая рана', true) == 0) and
            (self.parent:can_cast_on_enemy('Глубокая рана'))) then
            Keystroke:show(4)
            return
        end

        if (self.parent:can_cast_on_enemy('Полоснуть')) then
            Keystroke:show(6)
            return
        end
    end
end
