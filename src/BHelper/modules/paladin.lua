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

function BHelper.modules.paladin.default:update()
    if ((BHelper.player:get_buff_time('Печать повиновения') == 0) and
        (BHelper.player:can_cast('Печать повиновения'))) then
        return BHelper.keybinds:show_spell('Печать повиновения')
    end

    if ((BHelper.player:get_buff_time('Боевой крик') == 0) and
        (BHelper.player:get_buff_time('Благословение могущества') == 0) and
        (BHelper.player:get_buff_time(
            'Великое благословение могущества') == 0) and
        (BHelper.player:can_cast('Благословение могущества'))) then
        return BHelper.keybinds:show_spell('Благословение могущества')
    end

    if ((BHelper.player:get_health_on_percent() < 20) and (not BHelper.player:check_moving()) and
        BHelper.player:can_cast('Вспышка Света')) then
        return BHelper.keybinds:show_spell('Вспышка Света')
    end

    if ((BHelper.player:get_health_on_percent() < 40) and (not BHelper.player:check_moving()) and
        BHelper.player:can_cast('Свет небес')) then
        return BHelper.keybinds:show_spell('Свет небес')
    end
end

function BHelper.modules.paladin.default:rotation_single()
    if (BHelper.player:can_cast_on_enemy('Правосудие мудрости') and
        (self.vars.JoW)) then
        return BHelper.keybinds:show_spell('Правосудие мудрости')
    end

    if (BHelper.player:can_cast_on_enemy('Правосудие света') and (self.vars.JoL)) then
        return BHelper.keybinds:show_spell('Правосудие света')
    end

    if (BHelper.player:can_cast('Божественная буря')) then
        return BHelper.keybinds:show_spell('Божественная буря')
    end

    if (BHelper.player:can_cast_on_enemy('Удар воина света')) then
        return BHelper.keybinds:show_spell('Удар воина света')
    end

    if (BHelper.player:can_cast_on_enemy('Молот гнева')) then
        return BHelper.keybinds:show_spell('Молот гнева')
    end

    -- if ((BHelper.player:check_spell_range('Удар воина света')) and
    --     (BHelper.player:can_cast('Освящение'))) then
    --     return BHelper.keybinds:show_spell('Освящение')
    -- end

    if ((BHelper.player:get_buff_time('Искусство войны') > 0) and
        (BHelper.player:can_cast_on_enemy('Экзорцизм'))) then
        return BHelper.keybinds:show_spell('Экзорцизм')
    end

    if (BHelper.player:can_cast('Гнев небес')) then
        return BHelper.keybinds:show_spell('Гнев небес')
    end
end

function BHelper.modules.paladin.default:rotation_multiple()
    if ((BHelper.player:check_spell_range('Удар воина света')) and
        (BHelper.player:can_cast('Освящение'))) then
        return BHelper.keybinds:show_spell('Освящение')
    end

    return BHelper.modules.paladin.default:rotation_single()
end
