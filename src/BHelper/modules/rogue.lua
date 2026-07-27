function BHelper.modules.rogue:init()
    self.vars.sunder = false
end

function BHelper.modules.rogue:rotation_1()
    if (InCombatLockdown() ~= 1) then return end

    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Пинок')) then
        Keystroke:show_spell(34)
        return
    end

    if (self.vars.sunder) then
        if ((self.parent:get_ememy_debuff_time('Ослабление доспеха') == 0) and
            (self.parent:can_cast_on_enemy('Ослабление доспеха'))) then
            Keystroke:show_spell(3)
            return
        end

        if ((self.parent:get_ememy_debuff_time('Ослабление доспеха') <= 3) and
            (self.parent:can_cast_on_enemy('Ослабление доспеха')) and
            (self.parent:check_combo_points(4))) then
            Keystroke:show_spell(3)
            return
        end
    end

    if ((self.parent:get_player_buff_time('Мясорубка') == 0) and
        (self.parent:can_cast('Мясорубка'))) then
        Keystroke:show_spell(4)
        return
    end

    if ((self.parent:get_player_buff_time('Мясорубка') <= 3) and
        (self.parent:can_cast('Мясорубка')) and (self.parent:check_combo_points(5))) then
        Keystroke:show_spell(4)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Рваная рана', true) <= 2) and
        (self.parent:can_cast_on_enemy('Рваная рана')) and
        (self.parent:check_combo_points(5))) then
        Keystroke:show_spell(6)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Рваная рана', true) > 4) and
        (self.parent:can_cast_on_enemy('Потрошение')) and
        (self.parent:check_combo_points(3))) then
        Keystroke:show_spell(7)
        return
    end

    -- if ((self.parent:can_cast_on_enemy('Потрошение')) and
    --     (self.parent:check_combo_points(4))) then
    --     Keystroke:show_spell(7)
    --     return
    -- end

    if (self.parent:can_cast_on_enemy('Коварный удар')) then
        Keystroke:show_spell(5)
        return
    end
end

function BHelper.modules.rogue:rotation_2()
    if (InCombatLockdown() ~= 1) then return end

    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Пинок')) then
        Keystroke:show_spell(34)
    end

    if (self.parent:can_cast('Веер клинков')) then
        Keystroke:show_spell(33)
        return
    end
end
