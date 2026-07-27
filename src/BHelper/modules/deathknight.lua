function BHelper.modules.deathknight:init()
    BHelper.keybinds:unbind_all()
    BHelper.keybinds:bind_spell('Кровь вампира')
    BHelper.keybinds:bind_spell('Кровоотвод')
    BHelper.keybinds:bind_spell('Захват рун')
    BHelper.keybinds:bind_macro('BH: Смертельный союз')
    BHelper.keybinds:bind_spell('Зимний горн')
    BHelper.keybinds:bind_spell('Рунический удар')
    BHelper.keybinds:bind_spell('Заморозка разума')
    BHelper.keybinds:bind_spell('Удушение')
    BHelper.keybinds:bind_spell('Ледяное прикосновение')
    BHelper.keybinds:bind_spell('Удар чумы')
    BHelper.keybinds:bind_spell('Удар в сердце')
    BHelper.keybinds:bind_spell('Удар смерти')
    BHelper.keybinds:bind_spell('Мор')
    BHelper.keybinds:bind_spell('Вскипание крови')
end

function BHelper.modules.deathknight:macros()
    BHelper.macros:delete_all()

    BHelper.macros:create('Истерия',
                          '#showtooltip Истерия\n/bh c 1\n/cast [@focus,help,nodead] Истерия\n/cast [@target,help,nodead] Истерия\n/cast [@mouseover,help,nodead] Истерия')
    BHelper.macros:create('Смертельный союз',
                          '#showtooltip Смертельный союз\n/castsequence reset=120 Воскрешение мертвых, Смертельный союз')
    BHelper.macros:create('Незыблемость льда',
                          '#showtooltip\n/bh c 1\n/cast Незыблемость льда')
    BHelper.macros:create('Антимагический панцирь',
                          '#showtooltip\n/bh c 1\n/cast Антимагический панцирь')
    BHelper.macros:create('Кровь вампира',
                          '#showtooltip\n/bh c 1\n/cast Кровь вампира')
    BHelper.macros:create('Захват рун', '#showtooltip\n/bh c 1\n/cast Захват рун')
    BHelper.macros:create('Кровоотвод',
                          '#showtooltip\n/bh c 1\n/cast Кровоотвод')

    BHelper.macros:create('S', '/startattack\n/bh sa rotation_single\n/bh')
    BHelper.macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh')
end

function BHelper.modules.deathknight:heal()
    if ((BHelper:get_health_on_percent() < 30) and BHelper:can_cast('Кровь вампира')) then
        BHelper.keybinds:show_spell('Кровь вампира')
        return true
    end

    if ((BHelper:get_health_on_percent() < 40) and
        (BHelper:can_cast('Воскрешение мертвых') or
            BHelper:can_cast('Смертельный союз'))) then
        BHelper.keybinds:show_spell('BH: Смертельный союз')
        return true
    end

    if ((BHelper:get_health_on_percent() < 60) and BHelper:can_cast('Захват рун')) then
        BHelper.keybinds:show_spell('Захват рун')
        return true
    end

    if ((BHelper:get_health_on_percent() < 80) and
        ((BHelper:get_ememy_debuff_time('Озноб', true) > 0) or
            (BHelper:get_ememy_debuff_time('Кровавая чума', true) > 0)) and
        (BHelper:can_cast_on_enemy('Удар смерти'))) then
        BHelper.keybinds:show_spell('Удар смерти')
        return true
    end

    return false
end

function BHelper.modules.deathknight:rotation_single()
    if (self:heal()) then return end

    if ((BHelper:get_player_buff_time('Зимний горн') == 0) and
        (BHelper:can_cast('Зимний горн'))) then
        BHelper.keybinds:show_spell('Зимний горн')
        return
    end

    if (InCombatLockdown() ~= 1) then return end

    if (BHelper:can_cast('Рунический удар')) then
        BHelper.keybinds:show_attack('Рунический удар')
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Заморозка разума')) then
        BHelper.keybinds:show_spell('Заморозка разума')
        return
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Удушение')) then
        BHelper.keybinds:show_spell('Удушение')
        return
    end

    if (BHelper:can_cast_on_enemy('Ледяное прикосновение')) then
        BHelper.keybinds:show_spell('Ледяное прикосновение')
        return
    end

    if (BHelper:can_cast_on_enemy('Удар чумы')) then
        BHelper.keybinds:show_spell('Удар чумы')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) > 0) and
        (BHelper:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (BHelper:can_cast_on_enemy('Удар в сердце'))) then
        BHelper.keybinds:show_spell('Удар в сердце')
        return
    end
end

function BHelper.modules.deathknight:rotation_multiple()
    if (self:heal()) then return end

    if ((BHelper:get_player_buff_time('Зимний горн') == 0) and
        (BHelper:can_cast('Зимний горн'))) then
        BHelper.keybinds:show_spell('Зимний горн')
        return
    end

    if (InCombatLockdown() ~= 1) then return end

    if (BHelper:can_cast('Рунический удар')) then
        BHelper.keybinds:show_attack('Рунический удар')
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Заморозка разума')) then
        BHelper.keybinds:show_spell('Заморозка разума')
        return
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Удушение')) then
        BHelper.keybinds:show_spell('Удушение')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) == 0) and
        (BHelper:can_cast_on_enemy('Ледяное прикосновение'))) then
        BHelper.keybinds:show_spell('Ледяное прикосновение')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Кровавая чума', true) == 0) and
        (BHelper:can_cast_on_enemy('Удар чумы'))) then
        BHelper.keybinds:show_spell('Удар чумы')
        return
    end

    if (((BHelper:get_ememy_debuff_time('Кровавая чума', true) <= 2) or
        (BHelper:get_ememy_debuff_time('Озноб', true) <= 2)) and
        (BHelper:can_cast_on_enemy('Мор'))) then
        BHelper.keybinds:show_spell('Мор')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) ~=
        BHelper:get_ememy_debuff_time('Кровавая чума', true)) and
        (BHelper:can_cast_on_enemy('Мор'))) then
        BHelper.keybinds:show_spell('Мор')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) > 0) and
        (BHelper:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (BHelper:can_cast('Вскипание крови'))) then
        BHelper.keybinds:show_spell('Вскипание крови')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) > 0) and
        (BHelper:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (BHelper:can_cast_on_enemy('Удар смерти'))) then
        BHelper.keybinds:show_spell('Удар смерти')
        return
    end
end

-- if ((BHelper:get_health_on_percent() < 40) and
--     (BHelper:can_cast('Воскрешение мертвых') or
--         BHelper:can_cast('Смертельный союз'))) then BHelper.keybinds:show_spell(10) end

-- if ((BHelper:get_health_on_percent() < 60) and BHelper:can_cast('Захват рун')) then
--     BHelper.keybinds:show_spell(9)
-- end

-- if ((BHelper:get_ememy_debuff_time('Озноб', true) == 0) and
--     (BHelper:can_cast_on_enemy('Ледяное прикосновение'))) then
--     BHelper.keybinds:show_spell(5)
--     return
-- end

-- if ((BHelper:get_ememy_debuff_time('Кровавая чума', true) == 0) and
--     (BHelper:can_cast_on_enemy('Удар чумы'))) then
--     BHelper.keybinds:show_spell(4)
--     return
-- end

-- if (((BHelper:get_ememy_debuff_time('Кровавая чума', true) <= 2) or
--     (BHelper:get_ememy_debuff_time('Озноб', true) <= 2)) and
--     (BHelper:can_cast_on_enemy('Мор'))) then
--     BHelper.keybinds:show_spell(2)
--     return
-- end

-- if ((BHelper:get_ememy_debuff_time('Озноб', true) > 0) and
--     (BHelper:get_ememy_debuff_time('Кровавая чума', true) > 0) and
--     (BHelper:can_cast_on_enemy('Удар смерти'))) then
--     BHelper.keybinds:show_spell(6)
--     return
-- end

-- if (BHelper:can_cast('Кровоотвод')) then
--     BHelper.keybinds:show_spell(2, false, true)
--     return
-- end
