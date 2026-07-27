function BHelper.modules.druid:init()
    BHelper.keybinds:unbind_all()
    BHelper.keybinds:bind_macro('BH: Цель')
    BHelper.keybinds:bind_spell('Калечение')
    BHelper.keybinds:bind_spell('Оглушить')
    BHelper.keybinds:bind_spell('Волшебный огонь (зверь)')
    BHelper.keybinds:bind_spell('Дикий рев')
    BHelper.keybinds:bind_spell('Тигриное неистовство')
    BHelper.keybinds:bind_spell('Размах (кошка)')
    BHelper.keybinds:bind_spell('Размах (медведь)')
    BHelper.keybinds:bind_spell('Увечье (кошка)')
    BHelper.keybinds:bind_spell('Увечье (медведь)')
    BHelper.keybinds:bind_spell('Глубокая рана')
    BHelper.keybinds:bind_spell('Полоснуть')
    BHelper.keybinds:bind_spell('Разорвать')
    BHelper.keybinds:bind_spell('Свирепый укус')
    BHelper.keybinds:bind_spell('Растерзать')
    BHelper.keybinds:bind_spell('Трепка')
end

function BHelper.modules.druid:macros()
    BHelper.macros:delete_all()

    BHelper.macros:create('Цель',
                          '/target [@focustarget,harm,nodead]\n/targetenemy [@focus,noexists]\n/targetenemy [@focus,harm]')
    BHelper.macros:create('Инвиз',
                          '#showtooltip Крадущийся зверь\n/bh stop\n/cast [form:0/1/2/4/5/6] !Облик кошки(Смена облика)\n/cast [form:3] Крадущийся зверь')
    BHelper.macros:create('Накинуться',
                          '#showtooltip\n/bh start\n/cast Накинуться')
    BHelper.macros:create('Чардж',
                          '#showtooltip\n/cast [form:1] Звериная атака - медведь\n/cast [form:3] Звериная атака - кошка')
    BHelper.macros:create('Сало',
                          '#showtooltip\n/cast [form:1/2] Оглушить\n/cast [form:3] Калечение')
    BHelper.macros:create('Озарение',
                          '#showtooltip Озарение\n/bh c 1\n/cast [@focus,help,nodead] Озарение\n/cast [@target,help,nodead] Озарение\n/cast [@mouseover,help,nodead] Озарение')
    BHelper.macros:create('Атака',
                          '#showtooltip\n/startattack\n/cast [form:0/2/4/5/6] !Облик кошки(Смена облика)\n/cast Волшебный огонь (зверь)')
    BHelper.macros:create('Смерч', '#showtooltip Смерч\n/bh c 1\n/cast Смерч')
    BHelper.macros:create('Дубовая кожа',
                          '#showtooltip Дубовая кожа\n/bh c 1\n/cast Дубовая кожа')
    BHelper.macros:create('Возрождение',
                          '#showtooltip Возрождение\n/bh c 1\n/cast Возрождение')
    BHelper.macros:create('Неистовое восстановление',
                          '#showtooltip Неистовое восстановление\n/bh c 1\n/cast Неистовое восстановление')
    BHelper.macros:create('Исступление',
                          '#showtooltip Исступление\n/bh c 1\n/cast Исступление')
    BHelper.macros:create('Берсерк',
                          '#showtooltip Берсерк\n/bh c 1\n/cast Берсерк\n/cast Берсерк(Расовая)')

    BHelper.macros:create('S', '/startattack\n/bh sa rotation_single\n/bh')
    BHelper.macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh')
end

function BHelper.modules.druid:rotation_single()
    if (InCombatLockdown() ~= 1) then return end

    if (BHelper:get_player_buff_time('Облик кошки') > 0) then self:cat_single() end

    if ((BHelper:get_player_buff_time('Облик медведя') > 0) or
        (BHelper:get_player_buff_time('Облик лютого медведя') > 0)) then
        self:bear_single()
    end
end

function BHelper.modules.druid:rotation_multiple()
    if (InCombatLockdown() ~= 1) then return end

    if (BHelper:get_player_buff_time('Облик кошки') > 0) then self:cat_multiple() end

    if ((BHelper:get_player_buff_time('Облик медведя') > 0) or
        (BHelper:get_player_buff_time('Облик лютого медведя') > 0)) then
        self:bear_multiple()
    end
end

function BHelper.modules.druid:cat_single()
    if (UnitCanAttack('player', 'target') ~= 1) then BHelper.keybinds:show_spell('BH: Цель') end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Калечение')) then
        BHelper.keybinds:show_spell('Калечение')
        return
    end

    if ((BHelper:get_player_buff_time('Дикий рев') == 0) and
        (BHelper:can_cast('Дикий рев'))) then
        BHelper.keybinds:show_spell('Дикий рев')
        return
    end

    if ((BHelper:get_player_buff_time('Дикий рев') <= 3) and
        (BHelper:can_cast('Дикий рев')) and (BHelper:check_combo_points(4))) then
        BHelper.keybinds:show_spell('Дикий рев')
        return
    end

    if ((BHelper:get_player_buff_time('Дикий рев') <= 8) and
        (((BHelper:get_ememy_debuff_time('Разорвать') + 2) >
            BHelper:get_player_buff_time('Дикий рев')) and
            ((BHelper:get_ememy_debuff_time('Разорвать') - 2) <
                BHelper:get_player_buff_time('Дикий рев'))) and
        (BHelper:can_cast('Дикий рев')) and (BHelper:check_combo_points(1))) then
        BHelper.keybinds:show_spell('Дикий рев')
        return
    end

    if ((BHelper:get_player_buff_time('Ясность мысли') == 0) and
        (BHelper:can_cast_on_enemy('Волшебный огонь (зверь)')) and
        (BHelper:get_player_buff_time(50334) == 0)) then
        BHelper.keybinds:show_spell('Волшебный огонь (зверь)')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Увечье (кошка)') == 0) and
        (BHelper:get_ememy_debuff_time('Увечье (медведь)') == 0) and
        (BHelper:can_cast_on_enemy('Увечье (кошка)'))) then
        BHelper.keybinds:show_spell('Увечье (кошка)')
        return
    end

    if (BHelper:get_player_buff_time('Ясность мысли') > 0) then
        if (BHelper:can_cast_on_enemy('Полоснуть')) then
            BHelper.keybinds:show_spell('Полоснуть')
            return
        end
    end

    if ((BHelper:get_power() <= 30) and
        (BHelper:can_cast('Тигриное неистовство'))) then
        BHelper.keybinds:show_spell('Тигриное неистовство')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Разорвать', true) == 0) and
        (BHelper:can_cast_on_enemy('Разорвать')) and (BHelper:check_combo_points(5))) then
        BHelper.keybinds:show_spell('Разорвать')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Разорвать', true) >= 8) and -- 6 в бис шмоте
        ((BHelper:get_player_buff_time('Дикий рев') >= 8)) and
        (BHelper:can_cast_on_enemy('Свирепый укус')) and
        ((BHelper:get_power() <= 50) or (BHelper:get_player_buff_time(50334) > 0)) and
        (BHelper:check_combo_points(5))) then
        BHelper.keybinds:show_spell('Свирепый укус')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Глубокая рана', true) == 0) and
        (BHelper:can_cast_on_enemy('Глубокая рана'))) then
        BHelper.keybinds:show_spell('Глубокая рана')
        return
    end

    if (BHelper:can_cast_on_enemy('Полоснуть')) then
        BHelper.keybinds:show_spell('Полоснуть')
        return
    end
end

function BHelper.modules.druid:bear_single()
    if (UnitCanAttack('player', 'target') ~= 1) then BHelper.keybinds:show_spell('BH: Цель') end

    if (BHelper:can_cast('Трепка')) then BHelper.keybinds:show_attack('Трепка') end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Оглушить')) then
        BHelper.keybinds:show_spell('Оглушить')
        return
    end

    if ((BHelper:get_player_buff_time('Ясность мысли') == 0) and
        (BHelper:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        BHelper.keybinds:show_spell('Волшебный огонь (зверь)')
        return
    end

    if (BHelper:can_cast_on_enemy('Увечье (медведь)')) then
        BHelper.keybinds:show_spell('Увечье (медведь)')
        return
    end

    if (((BHelper:get_ememy_debuff_time('Растерзать', true) <= 2) or
        (BHelper:get_ememy_debuff_count('Растерзать', true) < 5)) and
        (BHelper:can_cast_on_enemy('Растерзать'))) then
        BHelper.keybinds:show_spell('Растерзать')
        return
    end

    if (BHelper:can_cast('Размах (медведь)')) then
        BHelper.keybinds:show_spell('Размах (медведь)')
        return
    end
end

function BHelper.modules.druid:cat_multiple()
    if (UnitCanAttack('player', 'target') ~= 1) then BHelper.keybinds:show_spell('BH: Цель') end

    if ((BHelper:get_player_buff_time('Ясность мысли') == 0) and
        (BHelper:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        BHelper.keybinds:show_spell('Волшебный огонь (зверь)')
        return
    end

    if ((BHelper:get_power() <= 30) and
        (BHelper:can_cast('Тигриное неистовство'))) then
        BHelper.keybinds:show_spell('Тигриное неистовство')
        return
    end

    if ((BHelper:get_player_buff_time('Дикий рев') == 0)) then
        if (BHelper:can_cast('Дикий рев')) then
            BHelper.keybinds:show_spell('Дикий рев')
            return
        end

        if (BHelper:can_cast_on_enemy('Глубокая рана')) then
            BHelper.keybinds:show_spell('Глубокая рана')
            return
        end
    else
        if (BHelper:can_cast_on_enemy('Размах (кошка)')) then
            BHelper.keybinds:show_spell('Размах (кошка)')
            return
        end
    end
end

function BHelper.modules.druid:bear_multiple()
    if (UnitCanAttack('player', 'target') ~= 1) then BHelper.keybinds:show_spell('BH: Цель') end

    if (BHelper:can_cast('Трепка')) then BHelper.keybinds:show_attack('Трепка') end

    if ((BHelper:get_player_buff_time('Ясность мысли') == 0) and
        (BHelper:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        BHelper.keybinds:show_spell('Волшебный огонь (зверь)')
        return
    end

    if (BHelper:can_cast('Размах (медведь)')) then
        BHelper.keybinds:show_spell('Размах (медведь)')
        return
    end
end
