function BHelper.modules.deathknight.default:init()
    BHelper.keybinds:bind_spell('Кровь вампира')
    BHelper.keybinds:bind_spell('Кровоотвод')
    BHelper.keybinds:bind_spell('Захват рун')
    BHelper.keybinds:bind_macro('Смертельный союз')
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

function BHelper.modules.deathknight.default:macros()
    BHelper.macros:create('Истерия',
                          '#showtooltip Истерия\n/bh c 0.5\n/cast [@focus,help,nodead] Истерия\n/cast [@target,help,nodead] Истерия\n/cast [@mouseover,help,nodead] Истерия',
                          23)
    BHelper.macros:create('Смертельный союз',
                          '#showtooltip Смертельный союз\n/castsequence reset=120 Воскрешение мертвых, Смертельный союз')
    BHelper.macros:create('Незыблемость льда',
                          '#showtooltip\n/bh c 0.5\n/cast Незыблемость льда', 7)
    BHelper.macros:create('Антимагический панцирь',
                          '#showtooltip\n/bh c 0.5\n/cast Антимагический панцирь',
                          8)
    BHelper.macros:create('Кровь вампира',
                          '#showtooltip\n/bh c 0.5\n/cast Кровь вампира', 9)
    BHelper.macros:create('Захват рун',
                          '#showtooltip\n/bh c 0.5\n/cast Захват рун', 10)
    BHelper.macros:create('Кровоотвод',
                          '#showtooltip\n/bh c 0.5\n/cast Кровоотвод', 11)
    BHelper.macros:create('Хватка смерти',
                          '#showtooltip\n/bh c 0.5\n/cast Хватка смерти', 15)
    BHelper.macros:create('Темная власть',
                          '#showtooltip\n/bh c 0.5\n/cast Темная власть', 16)
    BHelper.macros:create('Ледяные оковы',
                          '#showtooltip\n/bh c 0.5\n/cast Ледяные оковы', 19)
    BHelper.macros:create('Войско мертвых',
                          '#showtooltip\n/bh c 0.5\n/cast Войско мертвых', 21)
    BHelper.macros:create('Усиление рунического оружия',
                          '#showtooltip\n/bh c 0.5\n/cast Усиление рунического оружия',
                          22)
    BHelper.macros:create('Смерть и разложение',
                          '#showtooltip\n/bh c 0.5\n/cast Смерть и разложение', 2)

    BHelper.macros:create('S', '/startattack\n/bh sa rotation_single\n/bh', 13, false, 1263)
    BHelper.macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh', 14, false, 1264)
end

function BHelper.modules.deathknight.default:update()
    if ((BHelper:get_health_on_percent() < 30) and BHelper:can_cast('Кровь вампира')) then
        BHelper.keybinds:show_spell('Кровь вампира')
        return true
    end

    if ((BHelper:get_health_on_percent() < 40) and
        (BHelper:can_cast('Воскрешение мертвых') or
            BHelper:can_cast('Смертельный союз'))) then
        BHelper.keybinds:show_macro('Смертельный союз')
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

    if ((BHelper:get_player_buff_time('Зимний горн') == 0) and
        (BHelper:can_cast('Зимний горн'))) then
        BHelper.keybinds:show_spell('Зимний горн')
        return true
    end
end

function BHelper.modules.deathknight.default:rotation_single()
    if (BHelper:can_cast('Рунический удар')) then
        BHelper.keybinds:show_attack('Рунический удар')
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Заморозка разума')) then
        BHelper.keybinds:show_spell('Заморозка разума')
        return true
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Удушение')) then
        BHelper.keybinds:show_spell('Удушение')
        return true
    end

    if (BHelper:can_cast_on_enemy('Ледяное прикосновение')) then
        BHelper.keybinds:show_spell('Ледяное прикосновение')
        return true
    end

    if (BHelper:can_cast_on_enemy('Удар чумы')) then
        BHelper.keybinds:show_spell('Удар чумы')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) > 0) and
        (BHelper:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (BHelper:can_cast_on_enemy('Удар в сердце'))) then
        BHelper.keybinds:show_spell('Удар в сердце')
        return true
    end
end

function BHelper.modules.deathknight.default:rotation_multiple()
    if (BHelper:can_cast('Рунический удар')) then
        BHelper.keybinds:show_attack('Рунический удар')
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Заморозка разума')) then
        BHelper.keybinds:show_spell('Заморозка разума')
        return true
    end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Удушение')) then
        BHelper.keybinds:show_spell('Удушение')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) == 0) and
        (BHelper:can_cast_on_enemy('Ледяное прикосновение'))) then
        BHelper.keybinds:show_spell('Ледяное прикосновение')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Кровавая чума', true) == 0) and
        (BHelper:can_cast_on_enemy('Удар чумы'))) then
        BHelper.keybinds:show_spell('Удар чумы')
        return true
    end

    if (((BHelper:get_ememy_debuff_time('Кровавая чума', true) <= 2) or
        (BHelper:get_ememy_debuff_time('Озноб', true) <= 2)) and
        (BHelper:can_cast_on_enemy('Мор'))) then
        BHelper.keybinds:show_spell('Мор')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) ~=
        BHelper:get_ememy_debuff_time('Кровавая чума', true)) and
        (BHelper:can_cast_on_enemy('Мор'))) then
        BHelper.keybinds:show_spell('Мор')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) > 0) and
        (BHelper:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (BHelper:can_cast('Вскипание крови'))) then
        BHelper.keybinds:show_spell('Вскипание крови')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Озноб', true) > 0) and
        (BHelper:get_ememy_debuff_time('Кровавая чума', true) > 0) and
        (BHelper:can_cast_on_enemy('Удар смерти'))) then
        BHelper.keybinds:show_spell('Удар смерти')
        return true
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
