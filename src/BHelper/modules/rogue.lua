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

local vars = nil

function BHelper.modules.rogue.default:init()
    vars = self.vars

    if (not vars.sunder) then vars.sunder = false end
end

function BHelper.modules.rogue.default:macros()
    macros:create('Ослабление доспеха',
                  '#showtooltip Ослабление доспеха\n/bh tv sunder', 41)
    macros:create('Маленькие хитрости',
                  '#showtooltip Маленькие хитрости\n/cancelaura Маленькие хитрости\n/cast [@focus,help,nodead] Маленькие хитрости\n/cast [@target,help,nodead] Маленькие хитрости\n/cast [@mouseover,help,nodead] Маленькие хитрости',
                  15)
    macros:create('Берсерк(Расовая)', '#showtooltip\n/cast Берсерк(Расовая)', 9)
    macros:create('Шквал клинков', '#showtooltip\n/cast Шквал клинков', 10)
    macros:create('Выброс адреналина', '#showtooltip\n/cast Выброс адреналина', 11)
    macros:create('Череда убийств', '#showtooltip\n/cast Череда убийств', 12)
end

function BHelper.modules.rogue.default:rotation_single()
    if (target:check_cast() and player:can_cast_on_enemy('Пинок')) then return keybinds:show_spell('Пинок') end

    if (player:is_burst() and (not self.burst_cooldown)) then
        local item = player:item_name(INVSLOT_TRINKET1)
        if ((player:is_equipped_item(item)) and (player:can_use_item(item))) then keybinds:show_item(item) end

        local item = player:item_name(INVSLOT_TRINKET2)
        if ((player:is_equipped_item(item)) and (player:can_use_item(item))) then keybinds:show_item(item) end

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

    if ((vars.sunder) and (not BHelper.player:has_heroism_buff())) then
        if ((target:aura('Ослабление доспеха') == 0) and
            (player:can_cast_on_enemy('Ослабление доспеха'))) then
            return keybinds:show_spell('Ослабление доспеха')
        end

        if ((target:aura('Ослабление доспеха') <= 3) and
            (player:can_cast_on_enemy('Ослабление доспеха')) and (player:has_combo_points(4))) then
            return keybinds:show_spell('Ослабление доспеха')
        end
    end

    if ((player:aura('Мясорубка') == 0) and (player:can_cast('Мясорубка'))) then
        return keybinds:show_spell('Мясорубка')
    end

    if ((player:aura('Мясорубка') <= 3) and (player:can_cast('Мясорубка')) and
        (player:has_combo_points(5))) then return keybinds:show_spell('Мясорубка') end

    if ((player:can_cast_on_enemy('Потрошение')) and (player:has_combo_points(4))) then
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
