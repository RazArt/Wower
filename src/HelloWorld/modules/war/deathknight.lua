-- GetRuneCooldown()
function HelloWorld.war.deathknight:update()
    if (self.parent:can_cast('Рунический удар')) then
        Keystroke:show_2(7)
        return
    end
end

function HelloWorld.war.deathknight:heal()
    if ((self.parent:get_health_on_percent() < 30) and
        self.parent:can_cast('Кровь вампира')) then Keystroke:show(11) end

    -- if ((self.parent:get_health_on_percent() < 40) and
    --     (self.parent:can_cast('Воскрешение мертвых') or
    --         self.parent:can_cast('Смертельный союз'))) then Keystroke:show(10) end

    -- if ((self.parent:get_health_on_percent() < 60) and self.parent:can_cast('Захват рун')) then
    --     Keystroke:show(9)
    -- end
end

function HelloWorld.war.deathknight:rotation_1()
    self:heal()

    if ((self.parent:get_player_buff_time('Зимний горн') == 0) and
        (self.parent:can_cast('Зимний горн'))) then
        Keystroke:show(9, false, true)
        return
    end

    if (InCombatLockdown() ~= 1) then return end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Заморозка разума')) then
        Keystroke:show(34)
        return
    end

    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Удушение')) then
        Keystroke:show(34, false, true)
        return
    end

    -- if ((self.parent:get_ememy_debuff_time('Озноб', true) == 0) and
    --     (self.parent:can_cast_on_enemy('Ледяное прикосновение'))) then
    --     Keystroke:show(5)
    --     return
    -- end

    -- if ((self.parent:get_ememy_debuff_time('Кровавая чума', true) == 0) and
    --     (self.parent:can_cast_on_enemy('Удар чумы'))) then
    --     Keystroke:show(4)
    --     return
    -- end

    -- if (((self.parent:get_ememy_debuff_time('Кровавая чума', true) <= 2) or
    --     (self.parent:get_ememy_debuff_time('Озноб', true) <= 2)) and
    --     (self.parent:can_cast_on_enemy('Мор'))) then
    --     Keystroke:show(2)
    --     return
    -- end

    if (self.parent:can_cast_on_enemy('Ледяное прикосновение')) then
        Keystroke:show(5)
        return
    end

    if (self.parent:can_cast_on_enemy('Удар чумы')) then
        Keystroke:show(4)
        return
    end

    -- if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
    --     (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
    --     (self.parent:can_cast_on_enemy('Удар смерти'))) then
    --     Keystroke:show(6)
    --     return
    -- end

    if (self.parent:can_cast('Кровоотвод')) then
        Keystroke:show(2, false, true)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
        (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (self.parent:can_cast_on_enemy('Удар в сердце'))) then
        Keystroke:show(6)
        return
    end

end

function HelloWorld.war.deathknight:rotation_2()
    self:heal()

    if ((self.parent:get_player_buff_time('Зимний горн') == 0) and
        (self.parent:can_cast('Зимний горн'))) then
        Keystroke:show(9, false, true)
        return
    end

    if (InCombatLockdown() ~= 1) then return end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Заморозка разума')) then
        Keystroke:show(34)
        return
    end

    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Удушение')) then
        Keystroke:show(34, false, true)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) == 0) and
        (self.parent:can_cast_on_enemy('Ледяное прикосновение'))) then
        Keystroke:show(5)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Кровавая чума', true) == 0) and
        (self.parent:can_cast_on_enemy('Удар чумы'))) then
        Keystroke:show(4)
        return
    end

    if (((self.parent:get_ememy_debuff_time('Кровавая чума', true) <= 2) or
        (self.parent:get_ememy_debuff_time('Озноб', true) <= 2)) and
        (self.parent:can_cast_on_enemy('Мор'))) then
        Keystroke:show(2)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) ~=
        self.parent:get_ememy_debuff_time('Кровавая чума', true)) and
        (self.parent:can_cast_on_enemy('Мор'))) then
        Keystroke:show(2)
        return
    end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
        (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (self.parent:can_cast('Вскипание крови'))) then
        Keystroke:show(8)
        return
    end

    -- if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
    --     (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
    --     (self.parent:can_cast_on_enemy('Удар в сердце'))) then
    --     Keystroke:show(6)
    --     return
    -- end

    if ((self.parent:get_ememy_debuff_time('Озноб', true) > 0) and
        (self.parent:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (self.parent:can_cast_on_enemy('Удар смерти'))) then
        Keystroke:show(4, false, true)
        return
    end

    -- if (self.parent:can_cast('Кровоотвод')) then
    --     Keystroke:show(2, false, true)
    --     return
    -- end
end
