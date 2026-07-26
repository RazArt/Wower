function HelloWorld.war.deathknight:heal()
    if ((self.parent:get_health_on_percent() < 30) and
        self.parent:can_cast('Кровь вампира')) then Keystroke:show_spell(61) end
end

function HelloWorld.war.deathknight:rotation_1()
    self:heal()

    if ((self.parent:get_player_buff_time('Зимний горн') == 0) and
        (self.parent:can_cast('Зимний горн'))) then
        Keystroke:show_spell(3, false, false, false, true)
        return
    end

    if (InCombatLockdown() ~= 1) then return end

    if (self.parent:can_cast('Рунический удар')) then
        Keystroke:show_attack(2, true)
    end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Заморозка разума')) then
        Keystroke:show_spell(34)
        return
    end

    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Удушение')) then
        Keystroke:show_spell(34, false, true)
        return
    end

    if (self.parent:can_cast_on_enemy('Ледяное прикосновение')) then
        Keystroke:show_spell(5)
        return
    end

    if (self.parent:can_cast_on_enemy('Удар чумы')) then
        Keystroke:show_spell(4)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
        (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (self.parent:can_cast_on_enemy('Удар в сердце'))) then
        Keystroke:show_spell(6)
        return
    end
end

function HelloWorld.war.deathknight:rotation_2()
    self:heal()

    if ((self.parent:get_player_buff_time('Зимний горн') == 0) and
        (self.parent:can_cast('Зимний горн'))) then
        Keystroke:show_spell(3, false, false, false, true)
        return
    end

    if (InCombatLockdown() ~= 1) then return end

    if (self.parent:can_cast('Рунический удар')) then
        Keystroke:show_attack(2, true)
    end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Заморозка разума')) then
        Keystroke:show_spell(34)
        return
    end

    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Удушение')) then
        Keystroke:show_spell(34, false, true)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) == 0) and
        (self.parent:can_cast_on_enemy('Ледяное прикосновение'))) then
        Keystroke:show_spell(5)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Кровавая чума', true) == 0) and
        (self.parent:can_cast_on_enemy('Удар чумы'))) then
        Keystroke:show_spell(4)
        return
    end

    if (((self.parent:get_ememy_debuff_time('Кровавая чума', true) <= 2) or
        (self.parent:get_ememy_debuff_time('Озноб', true) <= 2)) and
        (self.parent:can_cast_on_enemy('Мор'))) then
        Keystroke:show_spell(2)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) ~=
        self.parent:get_ememy_debuff_time('Кровавая чума', true)) and
        (self.parent:can_cast_on_enemy('Мор'))) then
        Keystroke:show_spell(2)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
        (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (self.parent:can_cast('Вскипание крови'))) then
        Keystroke:show_spell(7)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
        (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (self.parent:can_cast_on_enemy('Удар смерти'))) then
        Keystroke:show_spell(4, false, true)
        return
    end
end

-- if ((self.parent:get_health_on_percent() < 40) and
--     (self.parent:can_cast('Воскрешение мертвых') or
--         self.parent:can_cast('Смертельный союз'))) then Keystroke:show_spell(10) end

-- if ((self.parent:get_health_on_percent() < 60) and self.parent:can_cast('Захват рун')) then
--     Keystroke:show_spell(9)
-- end

-- if ((self.parent:get_ememy_debuff_time('Озноб', true) == 0) and
--     (self.parent:can_cast_on_enemy('Ледяное прикосновение'))) then
--     Keystroke:show_spell(5)
--     return
-- end

-- if ((self.parent:get_ememy_debuff_time('Кровавая чума', true) == 0) and
--     (self.parent:can_cast_on_enemy('Удар чумы'))) then
--     Keystroke:show_spell(4)
--     return
-- end

-- if (((self.parent:get_ememy_debuff_time('Кровавая чума', true) <= 2) or
--     (self.parent:get_ememy_debuff_time('Озноб', true) <= 2)) and
--     (self.parent:can_cast_on_enemy('Мор'))) then
--     Keystroke:show_spell(2)
--     return
-- end

-- if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
--     (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
--     (self.parent:can_cast_on_enemy('Удар смерти'))) then
--     Keystroke:show_spell(6)
--     return
-- end

-- if (self.parent:can_cast('Кровоотвод')) then
--     Keystroke:show_spell(2, false, true)
--     return
-- end
