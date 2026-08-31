function BHelper.modules.paladin.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.JoW == nil) then self.vars.JoW = true end
    if (self.vars.JoL == nil) then self.vars.JoL = false end
    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Свет небес')
    BHelper.keybinds:bind_spell('Вспышка Света')
    BHelper.keybinds:bind_spell('Правосудие мудрости')
    BHelper.keybinds:bind_spell('Правосудие света')
    BHelper.keybinds:bind_spell('Божественная буря')
    BHelper.keybinds:bind_spell('Удар воина света')
    BHelper.keybinds:bind_spell('Молот гнева')
    BHelper.keybinds:bind_spell('Освящение')
    BHelper.keybinds:bind_spell('Экзорцизм')
    BHelper.keybinds:bind_spell('Гнев небес')
    BHelper.keybinds:bind_spell('Благословение могущества')
    BHelper.keybinds:bind_spell('Печать повиновения')

    -- BHelper.keybinds:bind_item('')
end

function BHelper.modules.paladin.default:macros()
    BHelper.macros:create('JoW',
                          '#showtooltip Правосудие мудрости\n/bh tv JoL\n/bh tv JoW',
                          40)
end

function BHelper.modules.paladin.default:rotation_single()
    if ((BHelper.player:get_buff_time('Печать повиновения') == 0) and
        (BHelper.player:can_cast('Печать повиновения'))) then
        BHelper.keybinds:show_spell('Печать повиновения')
        return true
    end

    if ((BHelper.player:get_buff_time('Боевой крик') == 0) and
        (BHelper.player:get_buff_time('Благословение могущества') == 0) and
        (BHelper.player:get_buff_time(
            'Великое благословение могущества') == 0) and
        (BHelper.player:can_cast('Благословение могущества'))) then
        BHelper.keybinds:show_spell('Благословение могущества')
        return true
    end

    if ((BHelper.player:get_health_on_percent() < 20) and (not BHelper.player:check_moving()) and
        BHelper.player:can_cast('Вспышка Света')) then
        BHelper.keybinds:show_spell('Вспышка Света')
        return true
    end

    if ((BHelper.player:get_health_on_percent() < 40) and (not BHelper.player:check_moving()) and
        BHelper.player:can_cast('Свет небес')) then
        BHelper.keybinds:show_spell('Свет небес')
        return true
    end

    if (BHelper.player:can_cast_on_enemy('Правосудие мудрости') and
        (self.vars.JoW)) then
        BHelper.keybinds:show_spell('Правосудие мудрости')
        return true
    end

    if (BHelper.player:can_cast_on_enemy('Правосудие света') and (self.vars.JoL)) then
        BHelper.keybinds:show_spell('Правосудие света')
        return true
    end

    if (BHelper.player:can_cast('Божественная буря')) then
        BHelper.keybinds:show_spell('Божественная буря')
        return true
    end

    if (BHelper.player:can_cast_on_enemy('Удар воина света')) then
        BHelper.keybinds:show_spell('Удар воина света')
        return true
    end

    if (BHelper.player:can_cast_on_enemy('Молот гнева')) then
        BHelper.keybinds:show_spell('Молот гнева')
        return true
    end

    -- if ((BHelper.player:check_spell_range('Удар воина света')) and
    if ((BHelper.player:check_spell_range('Правосудие мудрости')) and
        (BHelper.player:can_cast('Освящение'))) then
        BHelper.keybinds:show_spell('Освящение')
        return true
    end

    if ((not BHelper.player:check_moving()) and
        (BHelper.player:can_cast_on_enemy('Экзорцизм'))) then
        BHelper.keybinds:show_spell('Экзорцизм')
        return true
    end

    if (BHelper.player:can_cast('Гнев небес')) then
        BHelper.keybinds:show_spell('Гнев небес')
        return true
    end
end
