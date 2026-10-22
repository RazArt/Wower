local auras = BHelper.auras
local core = BHelper.core
local keybinds = BHelper.keybinds
local macros = BHelper.macros
local modules = BHelper.modules
local pet = BHelper.pet
local player = BHelper.player
local target = BHelper.target
local threat = BHelper.threat
local timers = BHelper.timers
local module = BHelper.modules.paladin

function BHelper.modules.paladin.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.JoW == nil) then self.vars.JoW = true end
    if (self.vars.JoL == nil) then self.vars.JoL = false end
    if (self.vars.silence == nil) then self.vars.silence = false end

    keybinds:bind_spell('Свет небес')
    keybinds:bind_spell('Вспышка Света')
    keybinds:bind_spell('Правосудие мудрости')
    keybinds:bind_spell('Правосудие света')
    keybinds:bind_spell('Божественная буря')
    keybinds:bind_spell('Удар воина света')
    keybinds:bind_spell('Молот гнева')
    keybinds:bind_spell('Освящение')
    keybinds:bind_spell('Экзорцизм')
    keybinds:bind_spell('Гнев небес')
    keybinds:bind_spell('Благословение могущества')
    keybinds:bind_spell('Печать повиновения')
end

function BHelper.modules.paladin.default:macros()
    macros:create('JoW', '#showtooltip Правосудие мудрости\n/bh tv JoL\n/bh tv JoW', 40)
end

function BHelper.modules.paladin.default:execute()
    if ((player:aura('Печать повиновения') == 0) and
        (player:can_cast('Печать повиновения'))) then
        return keybinds:show_spell('Печать повиновения')
    end

    if ((player:aura('Боевой крик') == 0) and
        (player:aura('Благословение могущества') == 0) and
        (player:aura('Великое благословение могущества') == 0) and
        (player:can_cast('Благословение могущества'))) then
        return keybinds:show_spell('Благословение могущества')
    end

    if ((player:get_health_on_percent() < 20) and (not player:check_moving()) and
        player:can_cast('Вспышка Света')) then return keybinds:show_spell('Вспышка Света') end

    if ((player:get_health_on_percent() < 40) and (not player:check_moving()) and player:can_cast('Свет небес')) then
        return keybinds:show_spell('Свет небес')
    end
end

function BHelper.modules.paladin.default:rotation_single()
    if (player:can_cast_on_enemy('Правосудие мудрости') and (self.vars.JoW)) then
        return keybinds:show_spell('Правосудие мудрости')
    end

    if (player:can_cast_on_enemy('Правосудие света') and (self.vars.JoL)) then
        return keybinds:show_spell('Правосудие света')
    end

    if (player:can_cast('Божественная буря')) then
        return keybinds:show_spell('Божественная буря')
    end

    if (player:can_cast_on_enemy('Удар воина света')) then
        return keybinds:show_spell('Удар воина света')
    end

    if (player:can_cast_on_enemy('Молот гнева')) then return keybinds:show_spell('Молот гнева') end

    -- if ((player:check_spell_range('Удар воина света')) and
    --     (player:can_cast('Освящение'))) then
    --     return keybinds:show_spell('Освящение')
    -- end

    if ((player:aura('Искусство войны') > 0) and (player:can_cast_on_enemy('Экзорцизм'))) then
        return keybinds:show_spell('Экзорцизм')
    end

    -- if (player:can_cast('Гнев небес')) then
    --     return keybinds:show_spell('Гнев небес')
    -- end
end

function BHelper.modules.paladin.default:rotation_multiple()
    if ((player:check_spell_range('Удар воина света')) and (player:can_cast('Освящение'))) then
        return keybinds:show_spell('Освящение')
    end

    return BHelper.modules.paladin.default:rotation_single()
end
