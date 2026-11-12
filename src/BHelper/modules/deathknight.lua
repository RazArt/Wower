local auras = BHelper.auras
local core = BHelper.core
local keybinds = BHelper.keybinds
local macros = BHelper.macros
local modules = BHelper.modules
local pet = BHelper.pet
local player = BHelper.player
local pool = BHelper.pool
local target = BHelper.target
local threat = BHelper.threat
local timers = BHelper.timers
local module = BHelper.modules.deathknight

local vars = nil

local cooldown = {}
local multiple_attack = false
local unholy = false
local frost = false
local runes = {}
for i = 1, 6 do runes[i] = {} end
runes.count = {}
runes.ready_count = {}
runes.all_cooldown = false

local function udpate()
    frost = player:know_spell('Ледяной удар')
    unholy = player:know_spell('Удар плети')

    runes.all_cooldown = true
    for i = 1, 4 do
        runes.count[i] = 0
        runes.ready_count[i] = 0
    end

    for i = 1, 6 do
        local type = GetRuneType(i)
        local start, duration, ready = GetRuneCooldown(i)

        runes[i].type = type
        runes[i].cooldown = (start > 0) and start + duration - GetTime() or 0
        if (runes[i].cooldown == 0) then runes.all_cooldown = false end

        runes.count[type] = runes.count[type] + 1
        if (ready) then runes.ready_count[type] = runes.ready_count[type] + 1 end
    end

    diseases = ((target:aura('Озноб', true) > 0) and (target:aura('Кровавая чума', true) > 0))
end

function BHelper.modules.deathknight:init()
    udpate()
end

function BHelper.modules.deathknight:macros()
    macros:create('Кровоотвод', '#showtooltip\n/cancelaura Кровоотвод\n/cast Кровоотвод')
    macros:create('Антимагический панцирь',
                  '#showtooltip\n/cancelaura Антимагический панцирь\n/cast Антимагический панцирь')
    macros:create('Смертельный союз',
                  '#showtooltip Смертельный союз\n/castsequence reset=120 Воскрешение мертвых, Смертельный союз')
end

function BHelper.modules.deathknight:execute()
    udpate()

    if (player:can_cast('Рунический удар')) then keybinds:show_attack('Рунический удар') end

    if (player:health_on_percent() < 20) then
        if ((player:power() >= 40) and (player:can_cast('Воскрешение мертвых'))) then
            return keybinds:show_spell('Воскрешение мертвых')
        end
        if (player:can_cast('Смертельный союз')) then
            return keybinds:show_spell('Смертельный союз')
        end
    end

    if ((player:health_on_percent() < 20) and (player:can_cast('Кровь вампира'))) then
        return keybinds:show_spell('Кровь вампира')
    end

    if ((player:health_on_percent() < 60) and (player:can_cast('Захват рун'))) then
        return keybinds:show_spell('Захват рун')
    end

    if ((target:check_cast()) and (vars.silence) and (player:can_cast_on_enemy('Заморозка разума'))) then
        return keybinds:show_spell('Заморозка разума')
    end

    if (((target:name() == 'Волдырный зомби') or (target:name() == 'Большой слизнюк')) and
        (target:aura('Ледяные оковы') == 0) and (player:can_cast_on_enemy('Ледяные оковы'))) then
        return keybinds:show_spell('Ледяные оковы')
    end
end

function BHelper.modules.deathknight.default:init()
    vars = self.vars

    self.settings.usable_equip = 'TANK'

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
end

function BHelper.modules.deathknight.default:macros()
    macros:create('Истерия',
                  '#showtooltip Истерия\n/cast [@target,help,nodead] Истерия\n/cast [@focus,help,nodead] Истерия')
end

function BHelper.modules.deathknight.default:put()
    keybinds:place_spell('Мор', 1)
    keybinds:place_spell('Смерть и разложение', 2)
    keybinds:place_spell('Удар чумы', 3)
    keybinds:place_spell('Ледяное прикосновение', 4)
    keybinds:place_spell('Кровавый удар', 5)
    if (player:know_spell('Удар в сердце')) then keybinds:place_spell('Удар в сердце', 5) end
    keybinds:place_spell('Удар смерти', 6)
    keybinds:place_spell('Незыблемость льда', 7)
    keybinds:place_macro('Антимагический панцирь', 8)
    keybinds:place_spell('Кровь вампира', 9)
    keybinds:place_macro('Кровоотвод', 10)
    keybinds:place_spell('Захват рун', 11)
    keybinds:place_spell('Хватка смерти', 15)
    keybinds:place_spell('Темная власть', 16)
    keybinds:place_spell('Заморозка разума', 17)
    keybinds:place_spell('Удушение', 18)
    keybinds:place_spell('Ледяные оковы', 19)
    keybinds:place_spell('Войско мертвых', 20)
    keybinds:place_spell('Усиление рунического оружия', 21)
    keybinds:place_macro('Истерия', 22)
    keybinds:place_macro('Смертельный союз', 24)
    keybinds:place_spell('Льдистый путь', 35)
    keybinds:place_spell('Зимний горн', 36)
end

function BHelper.modules.deathknight.default:rotation_single()
    multiple_attack = false
    return self:rotation()
end

function BHelper.modules.deathknight.default:rotation_multiple()
    multiple_attack = true
    return self:rotation()
end

function BHelper.modules.deathknight.default:rotation()
    if ((player:aura('Власть крови') == 0) and (player:aura('Власть льда') == 0) and
        (player:can_cast('Власть льда'))) then return keybinds:show_spell('Власть льда') end

    if ((not player:has_stable_threat()) or (self.opener)) then
        if ((target:is_boss()) and (player:spell_cooldown('Ледяное прикосновение') > 3)) then
            if (player:can_cast('Усиление рунического оружия')) then
                return keybinds:show_spell('Усиление рунического оружия')
            end
            if (player:can_cast('Кровоотвод')) then
                return keybinds:show_spell('Кровоотвод')
            end
        end

        if (player:can_cast_on_enemy('Ледяное прикосновение')) then
            return keybinds:show_spell('Ледяное прикосновение')
        end
    end

    if ((target:aura('Озноб', true) == 0) and
        (player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return keybinds:show_spell('Ледяное прикосновение')
    end

    if ((target:aura('Кровавая чума', true) == 0) and (player:can_cast_on_enemy('Удар чумы'))) then
        return keybinds:show_spell('Удар чумы')
    end

    if (multiple_attack) then
        if (diseases) then
            if ((player:health_on_percent() < 60) and (player:can_cast_on_enemy('Удар смерти'))) then
                return keybinds:show_spell('Удар смерти')
            end

            if ((not cooldown.pestilence) and (player:can_cast_on_enemy('Мор'))) then
                return keybinds:show_spell('Мор')
            end

            if ((player:aura('Клинковая ограда') == 0) and
                ((player:health_on_percent() > 80) or (runes.ready_count[4] > 1)) and
                (player:can_cast('Вскипание крови', true))) then
                return keybinds:show_spell('Вскипание крови')
            end

            if ((runes.ready_count[1] == 2) and (player:can_cast('Вскипание крови', true))) then
                return keybinds:show_spell('Вскипание крови')
            end

            if ((runes.ready_count[1] == 1) and (runes.ready_count[4] > 0) and
                (player:can_cast('Вскипание крови', true))) then
                return keybinds:show_spell('Вскипание крови')
            end

            if ((runes.ready_count[4] > 1) and (player:can_cast('Вскипание крови', true))) then
                return keybinds:show_spell('Вскипание крови')
            end
        end

        if ((runes.ready_count[4] < 4) and (player:can_cast_on_enemy('Удар смерти'))) then
            return keybinds:show_spell('Удар смерти')
        end
    else
        if ((player:aura('Клинковая ограда') == 0) and
            ((player:health_on_percent() > 80) or (runes.ready_count[4] > 1))) then
            if (player:can_cast_on_enemy('Удар в сердце')) then
                return keybinds:show_spell('Удар в сердце')
            end
            if (player:can_cast_on_enemy('Кровавый удар')) then
                return keybinds:show_spell('Кровавый удар')
            end
        end

        if (player:can_cast_on_enemy('Удар смерти')) then
            return keybinds:show_spell('Удар смерти')
        end

        if (runes.ready_count[1] == 2) then
            if (player:can_cast_on_enemy('Удар в сердце')) then
                return keybinds:show_spell('Удар в сердце')
            end
            if (player:can_cast_on_enemy('Кровавый удар')) then
                return keybinds:show_spell('Кровавый удар')
            end
        end
    end

    if ((player:power() == 100) and (player:can_cast_on_enemy('Лик смерти'))) then
        return keybinds:show_spell('Лик смерти')
    end

    if ((player:aura('Зимний горн') == 0) and (player:aura('Сила земли') == 0) and
        (player:can_cast('Зимний горн'))) then return keybinds:show_spell('Зимний горн') end
end

function BHelper.modules.deathknight.default:UNIT_SPELLCAST_SUCCEEDED(unit_id, spellName)
    if (unit_id ~= 'player') then return end

    if (spellName == 'Ледяное прикосновение') then cooldown.pestilence = false end
    if (spellName == 'Удар чумы') then cooldown.pestilence = false end
    if (spellName == 'Мор') then cooldown.pestilence = true end
end

function BHelper.modules.deathknight.default:start()
    self.opener = true
    self.opener = false
    timers:create(20, function()
        self.opener = false
    end, 'opener')
end

function BHelper.modules.deathknight.damage:init()
    vars = self.vars

    if (frost) then self.settings.usable_equip = 'DPS' end
    if (unholy) then self.settings.usable_equip = 'DPS Unh' end

    if (not vars.pet_control) then vars.pet_control = true end

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
end

function BHelper.modules.deathknight.damage:put()
    keybinds:place_spell('Мор', 1)
    keybinds:place_spell('Смерть и разложение', 2)
    if (frost) then
        keybinds:place_spell('Ледяной удар', 3)
        keybinds:place_spell('Уничтожение', 4)
        keybinds:place_spell('Воющий ветер', 5)
        keybinds:place_spell('Несокрушимая броня', 8)
        keybinds:place_spell('Воскрешение мертвых', 9)
    end
    if (unholy) then
        keybinds:place_spell('Удар Плети', 4)
        keybinds:place_spell('Лик смерти', 5)
        keybinds:place_spell('Костяной щит', 8)
        keybinds:place_spell('Призыв горгульи', 9)
    end
    keybinds:place_spell('Вскипание крови', 6)
    if (player:know_spell('Берсерк(Расовая)')) then
        keybinds:place_spell('Берсерк(Расовая)', 7)
    end
    if (player:know_spell('Кровавое неистовство(Расовая)')) then
        keybinds:place_spell('Кровавое неистовство(Расовая)', 7)
    end
    keybinds:place_spell('Кровоотвод', 10)
    keybinds:place_spell('Незыблемость льда', 11)
    keybinds:place_macro('Антимагический панцирь', 12)
    keybinds:place_spell('Хватка смерти', 15)
    keybinds:place_spell('Темная власть', 16)
    keybinds:place_spell('Заморозка разума', 17)
    keybinds:place_spell('Удушение', 18)
    keybinds:place_spell('Ледяные оковы', 21)
    keybinds:place_spell('Войско мертвых', 22)
    keybinds:place_spell('Усиление рунического оружия', 23)
    keybinds:place_macro('Смертельный союз', 24)
    keybinds:place_spell('Удар чумы', 31)
    keybinds:place_spell('Ледяное прикосновение', 32)
    keybinds:place_spell('Кровавый удар', 33)
    keybinds:place_spell('Льдистый путь', 35)
    keybinds:place_spell('Зимний горн', 36)
    if (unholy) then put_macro('PetControl', 41) end
end

function BHelper.modules.deathknight.damage:rotation_single()
    multiple_attack = false
    return self:rotation()
end

function BHelper.modules.deathknight.damage:rotation_multiple()
    multiple_attack = true
    return self:rotation()
end

function BHelper.modules.deathknight.damage:rotation()
    if ((player:aura('Власть крови') == 0) and (player:aura('Власть льда') == 0) and
        (player:can_cast('Власть крови'))) then return keybinds:show_spell('Власть крови') end

    if ((player:is_burst()) and (not self.burst_cooldown)) then
        local item = player:item_name(INVSLOT_TRINKET1)
        if ((player:is_equipped_item(item)) and (player:can_use_item(item))) then keybinds:show_item(item) end

        local item = player:item_name(INVSLOT_TRINKET2)
        if ((player:is_equipped_item(item)) and (player:can_use_item(item))) then keybinds:show_item(item) end

        if ((runes.all_cooldown) and (player:can_cast('Усиление рунического оружия'))) then
            return keybinds:show_spell('Усиление рунического оружия')
        end

        if ((runes[1].cooldown > 0) and (runes[2].cooldown > 0) and (player:aura('Кровоотвод', true) > 0)) then
            return keybinds:show_macro('Кровоотвод')
        end

        if ((runes[1].cooldown > 0) and (runes[2].cooldown > 0) and (player:can_cast('Кровоотвод'))) then
            return keybinds:show_spell('Кровоотвод')
        end

        if (player:can_cast('Несокрушимая броня')) then
            return keybinds:show_spell('Несокрушимая броня')
        end

        if (player:can_cast('Костяной щит')) then
            return keybinds:show_spell('Костяной щит')
        end

        if (player:can_cast('Воскрешение мертвых')) then
            return keybinds:show_spell('Воскрешение мертвых')
        end

        if (player:can_cast('Призыв горгульи')) then
            return keybinds:show_spell('Призыв горгульи')
        end

        if (player:can_cast('Берсерк(Расовая)')) then
            return keybinds:show_spell('Берсерк(Расовая)')
        end

        if (player:can_cast('Кровавое неистовство(Расовая)')) then
            return keybinds:show_spell('Кровавое неистовство(Расовая)')
        end
    end

    if ((player:aura('Морозная дымка', true) > 0) and (player:can_cast('Воющий ветер', true))) then
        return keybinds:show_spell('Воющий ветер')
    end

    if ((player:aura('Машина для убийств', true) > 0) and
        (player:can_cast_on_enemy('Ледяной удар'))) then
        return keybinds:show_spell('Ледяной удар')
    end

    if ((target:aura('Озноб', true) == 0) and
        (player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return keybinds:show_spell('Ледяное прикосновение')
    end

    if ((target:aura('Кровавая чума', true) == 0) and (player:can_cast_on_enemy('Удар чумы'))) then
        return keybinds:show_spell('Удар чумы')
    end

    if ((multiple_attack) and (diseases)) then
        if ((not cooldown.pestilence) and (player:can_cast_on_enemy('Мор'))) then
            return keybinds:show_spell('Мор')
        end

        if (player:can_cast('Воющий ветер', true)) then
            return keybinds:show_spell('Воющий ветер')
        end

        if (player:can_cast('Вскипание крови', true)) then
            return keybinds:show_spell('Вскипание крови')
        end
    end

    if (player:can_cast_on_enemy('Уничтожение')) then return keybinds:show_spell('Уничтожение') end
    if (player:can_cast_on_enemy('Удар Плети')) then return keybinds:show_spell('Удар Плети') end

    if ((runes.ready_count[1] > 0) and (player:can_cast_on_enemy('Кровавый удар'))) then
        return keybinds:show_spell('Кровавый удар')
    end

    if (player:can_cast_on_enemy('Ледяной удар')) then
        return keybinds:show_spell('Ледяной удар')
    end
    if (player:can_cast_on_enemy('Лик смерти')) then return keybinds:show_spell('Лик смерти') end

    if ((player:aura('Зимний горн') == 0) and (player:aura('Сила земли') == 0) and
        (player:can_cast('Зимний горн'))) then return keybinds:show_spell('Зимний горн') end
end

function BHelper.modules.deathknight.damage:UNIT_SPELLCAST_SUCCEEDED(unit_id, spellName)
    if (unit_id ~= 'player') then return end

    if (spellName == 'Ледяное прикосновение') then cooldown.pestilence = false end
    if (spellName == 'Удар чумы') then cooldown.pestilence = false end
    if (spellName == 'Мор') then cooldown.pestilence = true end
end

-- can_use_blood_rune = false
-- if ((runes[1].cooldown == 0) and (runes[2].cooldown == 0)) then
--     can_use_blood_rune = true
-- elseif (((runes[1].cooldown > 0) and (runes[2].cooldown == 0)) or
--     ((runes[1].cooldown == 0) and (runes[2].cooldown > 0))) then
--     local blood_rune_cd = (runes[1].cooldown > 0) and runes[1].cooldown or runes[2].cooldown
--     if ((target:aura('Озноб', true) > blood_rune_cd) and
--         (target:aura('Кровавая чума', true) > blood_rune_cd)) then can_use_blood_rune = true end
-- end

-- if (player:can_cast_on_enemy('Удар Плети')) then
--         if ((runes.ready_count[2] >= 1) and (runes.ready_count[3] >= 1)) then
--             return keybinds:show_spell('Удар Плети')
--         end

--         if (((runes.ready_count[2] >= 1) or (runes.ready_count[3] >= 1)) and (runes.ready_count[4] >= 1) and
--             (can_use_blood_rune)) then return keybinds:show_spell('Удар Плети') end

--         if ((runes.ready_count[2] == 0) and (runes.ready_count[3] == 0) and (runes.ready_count[4] == 2) and
--             (target:aura('Озноб', true) > 10.5) and (target:aura('Кровавая чума', true) > 10.5)) then
--             return keybinds:show_spell('Удар Плети')
--         end
--     end
