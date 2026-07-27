function BHelper.modules.rogue:init()
    self.vars.sunder = false

    BHelper.keybinds:unbind_all()
    BHelper.keybinds:bind_macro('BH: Цель')
    BHelper.keybinds:bind_spell('Пинок')
    BHelper.keybinds:bind_spell('Ослабление доспеха')
    BHelper.keybinds:bind_spell('Мясорубка')
    BHelper.keybinds:bind_spell('Рваная рана')
    BHelper.keybinds:bind_spell('Потрошение')
    BHelper.keybinds:bind_spell('Коварный удар')
    BHelper.keybinds:bind_spell('Веер клинков')
end

function BHelper.modules.rogue:macros()
    BHelper.macros:delete_all()

    BHelper.macros:create('Цель',
                          '/target [@focustarget,harm,nodead]\n/targetenemy [@focus,noexists]\n/targetenemy [@focus,harm]')
    BHelper.macros:create('Ослабление доспеха',
                          '#showtooltip Ослабление доспеха\n/bh tv sunder')
    BHelper.macros:create('Маленькие хитрости',
                          '#showtooltip Маленькие хитрости\n/bh c 1\n/cancelaura Маленькие хитрости\n/cast [@focus,help,nodead] Маленькие хитрости\n/cast [@target,help,nodead] Маленькие хитрости\n/cast [@mouseover,help,nodead] Маленькие хитрости')
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip\n/bh c 1\n/cast Берсерк(Расовая)')
    BHelper.macros:create('Шквал клинков',
                          '#showtooltip\n/bh c 1\n/cast Шквал клинков')
    BHelper.macros:create('Выброс адреналина',
                          '#showtooltip\n/bh c 1\n/cast Выброс адреналина')
    BHelper.macros:create('Череда убийств',
                          '#showtooltip\n/bh c 1\n/cast Череда убийств')

    BHelper.macros:create('S', '/startattack\n/bh sa rotation_single\n/bh')
    BHelper.macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh')
end

function BHelper.modules.rogue:rotation_single()
    if (InCombatLockdown() ~= 1) then return end

    if (UnitCanAttack('player', 'target') ~= 1) then BHelper.keybinds:show_spell('BH: Цель') end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Пинок')) then
        BHelper.keybinds:show_spell('Пинок')
        return
    end

    if (self.vars.sunder) then
        if ((BHelper:get_ememy_debuff_time('Ослабление доспеха') == 0) and
            (BHelper:can_cast_on_enemy('Ослабление доспеха'))) then
            BHelper.keybinds:show_spell('Ослабление доспеха')
            return
        end

        if ((BHelper:get_ememy_debuff_time('Ослабление доспеха') <= 3) and
            (BHelper:can_cast_on_enemy('Ослабление доспеха')) and
            (BHelper:check_combo_points(4))) then
            BHelper.keybinds:show_spell('Ослабление доспеха')
            return
        end
    end

    if ((BHelper:get_player_buff_time('Мясорубка') == 0) and
        (BHelper:can_cast('Мясорубка'))) then
        BHelper.keybinds:show_spell('Мясорубка')
        return
    end

    if ((BHelper:get_player_buff_time('Мясорубка') <= 3) and
        (BHelper:can_cast('Мясорубка')) and (BHelper:check_combo_points(5))) then
        BHelper.keybinds:show_spell('Мясорубка')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Рваная рана', true) <= 2) and
        (BHelper:can_cast_on_enemy('Рваная рана')) and (BHelper:check_combo_points(5))) then
        BHelper.keybinds:show_spell('Рваная рана')
        return
    end

    if ((BHelper:get_ememy_debuff_time('Рваная рана', true) > 4) and
        (BHelper:can_cast_on_enemy('Потрошение')) and (BHelper:check_combo_points(3))) then
        BHelper.keybinds:show_spell('Потрошение')
        return
    end

    -- if ((BHelper:can_cast_on_enemy('Потрошение')) and
    --     (BHelper:check_combo_points(4))) then
    --     BHelper.keybinds:show_spell('Потрошение')
    --     return
    -- end

    if (BHelper:can_cast_on_enemy('Коварный удар')) then
        BHelper.keybinds:show_spell('Коварный удар')
        return
    end
end

function BHelper.modules.rogue:rotation_multiple()
    if (InCombatLockdown() ~= 1) then return end

    if (UnitCanAttack('player', 'target') ~= 1) then BHelper.keybinds:show_spell('BH: Цель') end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Пинок')) then
        BHelper.keybinds:show_spell('Пинок')
    end

    if (BHelper:can_cast('Веер клинков')) then
        BHelper.keybinds:show_spell('Веер клинков')
        return
    end
end
