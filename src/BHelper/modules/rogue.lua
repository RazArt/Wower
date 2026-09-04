function BHelper.modules.rogue.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true
    self.settings.auto_combat_start = true

    if (self.vars.sunder == nil) then self.vars.sunder = false end

    BHelper.keybinds:bind_macro('BH: Цель')
    BHelper.keybinds:bind_spell('Пинок')
    BHelper.keybinds:bind_spell('Ослабление доспеха')
    BHelper.keybinds:bind_spell('Мясорубка')
    BHelper.keybinds:bind_spell('Рваная рана')
    BHelper.keybinds:bind_spell('Потрошение')
    BHelper.keybinds:bind_spell('Коварный удар')
    BHelper.keybinds:bind_spell('Веер клинков')
end

function BHelper.modules.rogue.default:macros()
    BHelper.macros:create('Ослабление доспеха',
                          '#showtooltip Ослабление доспеха\n/bh tv sunder', 41)
    BHelper.macros:create('Маленькие хитрости',
                          '#showtooltip Маленькие хитрости\n/bh c\n/cancelaura Маленькие хитрости\n/cast [@focus,help,nodead] Маленькие хитрости\n/cast [@target,help,nodead] Маленькие хитрости\n/cast [@mouseover,help,nodead] Маленькие хитрости',
                          15)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip\n/bh c\n/cast Берсерк(Расовая)', 9)
    BHelper.macros:create('Шквал клинков',
                          '#showtooltip\n/bh c\n/cast Шквал клинков', 10)
    BHelper.macros:create('Выброс адреналина',
                          '#showtooltip\n/bh c\n/cast Выброс адреналина', 11)
    BHelper.macros:create('Череда убийств',
                          '#showtooltip\n/bh c\n/cast Череда убийств', 12)
end

function BHelper.modules.rogue.default:rotation_single()
    if (BHelper.target:check_cast() and BHelper.player:can_cast_on_enemy('Пинок')) then
        BHelper.keybinds:show_spell('Пинок')
        return true
    end

    if (self.vars.sunder) then
        if ((BHelper.target:get_debuff_time('Ослабление доспеха') == 0) and
            (BHelper.player:can_cast_on_enemy('Ослабление доспеха'))) then
            BHelper.keybinds:show_spell('Ослабление доспеха')
            return true
        end

        if ((BHelper.target:get_debuff_time('Ослабление доспеха') <= 3) and
            (BHelper.player:can_cast_on_enemy('Ослабление доспеха')) and
            (BHelper.player:check_combo_points(4))) then
            BHelper.keybinds:show_spell('Ослабление доспеха')
            return true
        end
    end

    if ((BHelper.player:get_buff_time('Мясорубка') == 0) and
        (BHelper.player:can_cast('Мясорубка'))) then
        BHelper.keybinds:show_spell('Мясорубка')
        return true
    end

    if ((BHelper.player:get_buff_time('Мясорубка') <= 3) and
        (BHelper.player:can_cast('Мясорубка')) and (BHelper.player:check_combo_points(5))) then
        BHelper.keybinds:show_spell('Мясорубка')
        return true
    end

    if ((BHelper.target:get_debuff_time('Рваная рана', true) <= 2) and
        (BHelper.player:can_cast_on_enemy('Рваная рана')) and
        (BHelper.player:check_combo_points(5))) then
        BHelper.keybinds:show_spell('Рваная рана')
        return true
    end

    if ((BHelper.target:get_debuff_time('Рваная рана', true) > 4) and
        (BHelper.player:can_cast_on_enemy('Потрошение')) and
        (BHelper.player:check_combo_points(3))) then
        BHelper.keybinds:show_spell('Потрошение')
        return true
    end

    if ((BHelper.player:can_cast_on_enemy('Потрошение')) and
        (BHelper.player:check_combo_points(4))) then
        BHelper.keybinds:show_spell('Потрошение')
        return true
    end

    if (BHelper.player:can_cast_on_enemy('Коварный удар')) then
        BHelper.keybinds:show_spell('Коварный удар')
        return true
    end
end

function BHelper.modules.rogue.default:rotation_multiple()
    if (BHelper.target:check_cast() and BHelper.player:can_cast_on_enemy('Пинок')) then
        BHelper.keybinds:show_spell('Пинок')
        return true
    end

    if (BHelper.player:can_cast('Веер клинков')) then
        BHelper.keybinds:show_spell('Веер клинков')
        return true
    end
end
