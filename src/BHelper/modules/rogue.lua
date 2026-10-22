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
local module = BHelper.modules.rogue

function BHelper.modules.rogue.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.sunder == nil) then self.vars.sunder = false end

    keybinds:bind_spell('Пинок')
    keybinds:bind_spell('Ослабление доспеха')
    keybinds:bind_spell('Мясорубка')
    keybinds:bind_spell('Рваная рана')
    keybinds:bind_spell('Потрошение')
    keybinds:bind_spell('Коварный удар')
    keybinds:bind_spell('Веер клинков')
    keybinds:bind_spell('Шквал клинков')
    keybinds:bind_spell('Выброс адреналина')
    keybinds:bind_spell('Берсерк(Расовая)')

    keybinds:bind_item('Знак превосходства')
end

function BHelper.modules.rogue.default:macros()
    macros:create('Ослабление доспеха',
                  '#showtooltip Ослабление доспеха\n/bh tv sunder', 41)
    macros:create('Маленькие хитрости',
                  '#showtooltip Маленькие хитрости\n/bh c\n/cancelaura Маленькие хитрости\n/cast [@focus,help,nodead] Маленькие хитрости\n/cast [@target,help,nodead] Маленькие хитрости\n/cast [@mouseover,help,nodead] Маленькие хитрости',
                  15)
    macros:create('Берсерк(Расовая)', '#showtooltip\n/bh c\n/cast Берсерк(Расовая)', 9)
    macros:create('Шквал клинков', '#showtooltip\n/bh c\n/cast Шквал клинков', 10)
    macros:create('Выброс адреналина', '#showtooltip\n/bh c\n/cast Выброс адреналина',
                  11)
    macros:create('Череда убийств', '#showtooltip\n/bh c\n/cast Череда убийств', 12)
end

function BHelper.modules.rogue.default:rotation_single()
    if (target:check_cast() and player:can_cast_on_enemy('Пинок')) then return keybinds:show_spell('Пинок') end

    if (player:check_burst_mode() and (not BHelper.vars.cooldown_berserker)) then
        if ((player:check_equipped_item('Знак превосходства')) and
            (player:can_use_item('Знак превосходства'))) then
            return keybinds:show_item('Знак превосходства')
        end

        if (player:can_cast('Шквал клинков')) then
            return keybinds:show_spell('Шквал клинков')
        end

        if (player:can_cast('Выброс адреналина')) then
            return keybinds:show_spell('Выброс адреналина')
        end

        if (player:can_cast('Берсерк(Расовая)')) then
            return keybinds:show_spell('Берсерк(Расовая)')
        end
    end

    if ((self.vars.sunder) and (not BHelper.player:check_heroism_buff())) then
        if ((target:aura('Ослабление доспеха') == 0) and
            (player:can_cast_on_enemy('Ослабление доспеха'))) then
            return keybinds:show_spell('Ослабление доспеха')
        end

        if ((target:aura('Ослабление доспеха') <= 3) and
            (player:can_cast_on_enemy('Ослабление доспеха')) and (player:check_combo_points(4))) then
            return keybinds:show_spell('Ослабление доспеха')
        end
    end

    if ((player:aura('Мясорубка') == 0) and (player:can_cast('Мясорубка'))) then
        return keybinds:show_spell('Мясорубка')
    end

    if ((player:aura('Мясорубка') <= 3) and (player:can_cast('Мясорубка')) and
        (player:check_combo_points(5))) then return keybinds:show_spell('Мясорубка') end

    if ((player:can_cast_on_enemy('Потрошение')) and (player:check_combo_points(4))) then
        return keybinds:show_spell('Потрошение')
    end

    if (player:can_cast_on_enemy('Коварный удар')) then
        return keybinds:show_spell('Коварный удар')
    end
end

function BHelper.modules.rogue.default:rotation_multiple()
    if ((target:check_cast()) and (player:can_cast_on_enemy('Пинок'))) then
        return keybinds:show_spell('Пинок')
    end

    if (player:can_cast('Веер клинков')) then return keybinds:show_spell('Веер клинков') end
end
