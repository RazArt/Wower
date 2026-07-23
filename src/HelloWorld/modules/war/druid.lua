function HelloWorld.war.druid:rotation_1()
    -- if (InCombatLockdown() ~= 1) then return end

    if (self.parent:get_player_buff_time('Облик кошки') > 0) then
        if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Калечение')) then
            Keystroke:show(34)
            return
        end

        if ((self.parent:get_player_buff_time('Дикий рев') == 0) and
            (self.parent:can_cast('Дикий рев'))) then
            Keystroke:show(8)
            return
        end

        if ((self.parent:get_player_buff_time('Дикий рев') <= 3) and
            (self.parent:can_cast('Дикий рев')) and (self.parent:check_combo_points(4))) then
            Keystroke:show(8)
            return
        end

        if ((self.parent:get_player_buff_time('Ясность мысли') == 0) and
            (self.parent:can_cast_on_enemy('Волшебный огонь (зверь)')) and
            (self.parent:get_player_buff_time(50334) == 0)) then
            Keystroke:show(33)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Увечье (кошка)') == 0) and
            (self.parent:get_ememy_debuff_time('Увечье (медведь)') == 0) and
            (self.parent:can_cast_on_enemy('Увечье (кошка)'))) then
            Keystroke:show(3)
            return
        end

        if (self.parent:get_player_buff_time('Ясность мысли') > 0) then
            if (self.parent:can_cast_on_enemy('Полоснуть')) then
                Keystroke:show(5)
                return
            end
        end

        if ((self.parent:get_power() <= 30) and
            (self.parent:can_cast('Тигриное неистовство'))) then
            Keystroke:show(12)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Разорвать', true) == 0) and
            (self.parent:can_cast_on_enemy('Разорвать')) and
            (self.parent:check_combo_points(5))) then
            Keystroke:show(6)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Разорвать', true) >= 8) and -- 6 в бис шмоте
            ((self.parent:get_player_buff_time('Дикий рев') >= 8)) and
            (self.parent:can_cast_on_enemy('Свирепый укус')) and
            ((self.parent:get_power() <= 40) or (self.parent:get_player_buff_time(50334) > 0)) and
            (self.parent:check_combo_points(5))) then
            Keystroke:show(7)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Глубокая рана', true) == 0) and
            (self.parent:can_cast_on_enemy('Глубокая рана'))) then
            Keystroke:show(4)
            return
        end

        if (self.parent:can_cast_on_enemy('Полоснуть')) then
            Keystroke:show(5)
            return
        end
    end

    if ((self.parent:get_player_buff_time('Облик медведя') > 0) or
        (self.parent:get_player_buff_time('Облик лютого медведя') > 0)) then
        if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Оглушить')) then
            Keystroke:show(34)
            return
        end

        if ((self.parent:get_player_buff_time('Ясность мысли') == 0) and
            (self.parent:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
            Keystroke:show(33)
            return
        end

        if (self.parent:can_cast_on_enemy('Увечье (медведь)')) then
            Keystroke:show(4)
            return
        end

        if (((self.parent:get_ememy_debuff_time('Растерзать', true) <= 2) or
            (self.parent:get_ememy_debuff_count('Растерзать', true) < 5)) and
            (self.parent:can_cast_on_enemy('Растерзать'))) then
            Keystroke:show(6)
            return
        end

        if (self.parent:can_cast('Размах (медведь)')) then
            Keystroke:show(5)
            return
        end
    end
end

function HelloWorld.war.druid:rotation_2()
    -- if (InCombatLockdown() ~= 1) then return end

    if (self.parent:get_player_buff_time('Облик кошки') > 0) then
        if ((self.parent:get_player_buff_time('Ясность мысли') == 0) and
            (self.parent:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
            Keystroke:show(33)
            return
        end

        if ((self.parent:get_power() <= 30) and
            (self.parent:can_cast('Тигриное неистовство'))) then
            Keystroke:show(12)
            return
        end

        if ((self.parent:get_player_buff_time('Дикий рев') == 0)) then
            if (self.parent:can_cast('Дикий рев')) then
                Keystroke:show(8)
                return
            end

            if (self.parent:can_cast_on_enemy('Глубокая рана')) then
                Keystroke:show(4)
                return
            end
        else
            if (self.parent:can_cast_on_enemy('Размах (кошка)')) then
                Keystroke:show(2)
                return
            end
        end
    end

    if ((self.parent:get_player_buff_time('Облик медведя') > 0) or
        (self.parent:get_player_buff_time('Облик лютого медведя') > 0)) then
        if ((self.parent:get_player_buff_time('Ясность мысли') == 0) and
            (self.parent:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
            Keystroke:show(33)
            return
        end

        if (self.parent:can_cast('Размах (медведь)')) then
            Keystroke:show(5)
            return
        end
    end
end
