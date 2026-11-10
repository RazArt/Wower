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
local multiple_attack = false
local unholy = false
local frost = false
local runes = {}
runes.count = {}
runes.ready_count = {}
runes.all_cooldown = false
for i = 1, 6 do runes[i] = {} end

function BHelper.modules.deathknight:init()
    frost = player:know_spell('Ледяной удар')
    unholy = player:know_spell('Удар плети')

    keybinds:bind_spell('Власть крови')
    keybinds:bind_spell('Власть льда')
    keybinds:bind_spell('Власть нечестивости')

    keybinds:bind_spell('Рунический удар')
    keybinds:bind_spell('Ледяные оковы')
    keybinds:bind_spell('Мор', _, 1)
    keybinds:bind_spell('Вскипание крови', _, 6)
    keybinds:bind_spell('Смерть и разложение', _, 2)
    keybinds:bind_spell('Ледяное прикосновение')
    keybinds:bind_spell('Удар чумы')
    keybinds:bind_spell('Кровавый удар')
    keybinds:bind_spell('Лик смерти')

    keybinds:bind_spell('Хватка смерти')
    keybinds:bind_spell('Темная власть')
    keybinds:bind_spell('Заморозка разума', _, 17)
    keybinds:bind_spell('Удушение', _, 18)

    keybinds:bind_spell('Льдистый путь', _, 35)
    keybinds:bind_spell('Зимний горн', _, 36)
    keybinds:bind_spell('Незыблемость льда')
    keybinds:bind_spell('Антимагический панцирь')
    keybinds:bind_spell('Усиление рунического оружия')
    keybinds:bind_spell('Кровоотвод')
    keybinds:bind_spell('Воскрешение мертвых')
    keybinds:bind_spell('Войско мертвых')

    keybinds:bind_spell('Берсерк(Расовая)')
    keybinds:bind_spell('Кровавое неистовство(Расовая)')

    keybinds:bind_macro('Смертельный союз')
end

function BHelper.modules.deathknight:macros()
    macros:create('Заморозка разумаTV', '#showtooltip Заморозка разума\n/bh tv silence',
                  41)
    macros:create('Хватка смерти',
                  '#showtooltip\n/cast [@mouseover,harm] Хватка смерти; Хватка смерти', 15)
    macros:create('Темная власть',
                  '#showtooltip\n/cast [@mouseover,harm] Темная власть; Темная власть', 16)
    macros:create('Кровоотвод', '#showtooltip\n/cancelaura Кровоотвод\n/cast Кровоотвод')
    macros:create('Войско мертвых',
                  '#showtooltip\n/bh sv army_timeout false\n/cast Войско мертвых')
    macros:create('Смертельный союз',
                  '#showtooltip Смертельный союз\n/castsequence reset=120 Воскрешение мертвых, Смертельный союз')
end

function BHelper.modules.deathknight:execute()
    disease_exists = ((target:aura('Озноб', true) > 0) and (target:aura('Кровавая чума', true) > 0))
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

    if (player:can_cast('Рунический удар')) then keybinds:show_attack('Рунический удар') end

    if ((player:health_on_percent() < 20) and (player:power() >= 40) and
        ((player:can_cast('Воскрешение мертвых')) or
            (player:can_cast('Смертельный союз')))) then
        return keybinds:show_macro('Смертельный союз')
    end

    if ((player:health_on_percent() < 20) and (player:can_cast('Кровь вампира'))) then
        return keybinds:show_spell('Кровь вампира')
    end

    if ((player:health_on_percent() < 60) and (player:can_cast('Захват рун'))) then
        return keybinds:show_spell('Захват рун')
    end

    if (player:spell_cooldown('Войско мертвых') > 10) then vars.army_timeout = true end
    if (not vars.army_timeout) then
        if (player:can_cast('Войско мертвых')) then
            return keybinds:show_spell('Войско мертвых')
        end
        return true
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

    keybinds:put_spell('Удар чумы', 3)
    keybinds:put_spell('Ледяное прикосновение', 4)
    keybinds:put_spell('Кровавый удар', 5)
    if (player:know_spell('Удар в сердце')) then keybinds:put_spell('Удар в сердце', 5) end
    keybinds:put_spell('Удар смерти', 6)
    keybinds:put_spell('Незыблемость льда', 7)
    keybinds:put_spell('Антимагический панцирь', 8)
    keybinds:put_spell('Кровоотвод', 10)
    keybinds:put_spell('Ледяные оковы', 19)
    keybinds:put_spell('Усиление рунического оружия', 21)

    keybinds:put_macro('Войско мертвых', 20)
    keybinds:put_macro('Смертельный союз', 24)

    keybinds:bind_spell('Удар в сердце')
    keybinds:bind_spell('Удар смерти')
    keybinds:bind_spell('Кровь вампира', _, 9)
    keybinds:bind_spell('Захват рун', _, 11)
    keybinds:bind_spell('Истерия', _, 22)

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
end

function BHelper.modules.deathknight.default:macros()
    macros:create('Истерия',
                  '#showtooltip Истерия\n/cast [@focus,help,nodead] Истерия\n/cast [@target,help,nodead] Истерия\n/cast [@mouseover,help,nodead] Истерия')
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
    if ((player:aura('Власть льда') == 0) and (player:aura('Власть крови') == 0) and
        (player:can_cast('Власть льда'))) then return keybinds:show_spell('Власть льда') end

    if (((not player:has_stable_threat()) or (self.opener)) and (target:is_boss()) and
        (player:spell_cooldown('Ледяное прикосновение') > 3) and
        (player:can_cast('Усиление рунического оружия'))) then
        return keybinds:show_spell('Усиление рунического оружия')
    end

    if ((not player:has_stable_threat()) and (target:is_boss()) and
        (player:spell_cooldown('Ледяное прикосновение') > 3) and
        (player:can_cast('Кровоотвод'))) then return keybinds:show_spell('Кровоотвод') end

    if (((not player:has_stable_threat()) or (self.opener) or (target:aura('Озноб', true) == 0)) and
        (player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return keybinds:show_spell('Ледяное прикосновение')
    end

    if ((target:aura('Кровавая чума', true) == 0) and (player:can_cast_on_enemy('Удар чумы'))) then
        return keybinds:show_spell('Удар чумы')
    end

    if ((multiple_attack) and (disease_exists)) then
        if ((not vars.pestilence_timeout) and (player:can_cast_on_enemy('Мор'))) then
            return keybinds:show_spell('Мор')
        end

        if ((runes[1].cooldown == 0) and (runes[2].cooldown == 0) and
            (player:can_cast('Вскипание крови', true))) then
            return keybinds:show_spell('Вскипание крови')
        end

        if ((runes.ready_count[4] > 1) and (player:can_cast('Вскипание крови', true))) then
            return keybinds:show_spell('Вскипание крови')
        end
    end

    if ((player:aura('Клинковая ограда') == 0) and (player:health_on_percent() > 80)) then
        if ((multiple_attack) and (disease_exists) and (player:can_cast('Вскипание крови', true))) then
            return keybinds:show_spell('Вскипание крови')
        end
        if ((not multiple_attack) and (player:can_cast_on_enemy('Удар в сердце'))) then
            return keybinds:show_spell('Удар в сердце')
        end
        if ((not multiple_attack) and (player:can_cast_on_enemy('Кровавый удар'))) then
            return keybinds:show_spell('Кровавый удар')
        end
    end

    if ((player:has_stable_threat()) and (player:can_cast_on_enemy('Удар смерти'))) then
        return keybinds:show_spell('Удар смерти')
    end

    if ((not multiple_attack) and (runes[1].cooldown == 0) and (runes[2].cooldown == 0)) then
        if (player:can_cast_on_enemy('Удар в сердце')) then
            return keybinds:show_spell('Удар в сердце')
        end
        if (player:can_cast_on_enemy('Кровавый удар')) then
            return keybinds:show_spell('Кровавый удар')
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

    if (spellName == 'Ледяное прикосновение') then vars.pestilence_timeout = false end
    if (spellName == 'Удар чумы') then vars.pestilence_timeout = false end
    if (spellName == 'Мор') then vars.pestilence_timeout = true end
    if (spellName == 'Войско мертвых') then vars.army_timeout = true end
end

function BHelper.modules.deathknight.default:start()
    vars.army_timeout = true

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

    vars.army_timeout = true
    vars.pestilence_timeout = true

    if (player:know_spell('Берсерк(Расовая)')) then
        keybinds:put_spell('Берсерк(Расовая)', 7)
    end
    if (player:know_spell('Кровавое неистовство(Расовая)')) then
        keybinds:put_spell('Кровавое неистовство(Расовая)', 7)
    end
    keybinds:put_spell('Удар чумы', 31)
    keybinds:put_spell('Ледяное прикосновение', 32)
    keybinds:put_spell('Кровавый удар', 33)
    keybinds:put_spell('Кровоотвод', 10)
    keybinds:put_spell('Незыблемость льда', 11)
    keybinds:put_spell('Антимагический панцирь', 12)
    keybinds:put_spell('Ледяные оковы', 21)
    keybinds:put_spell('Усиление рунического оружия', 22)

    if (frost) then
        keybinds:bind_spell('Ледяной удар', _, 3)
        keybinds:bind_spell('Уничтожение', _, 4)
        keybinds:bind_spell('Воющий ветер', _, 5)
        keybinds:bind_spell('Несокрушимая броня', _, 8)
        keybinds:put_spell('Воскрешение мертвых', 9)
    end
    if (unholy) then
        keybinds:bind_spell('Удар Плети', _, 4)
        keybinds:bind_spell('Лик смерти', _, 5)
        keybinds:bind_spell('Костяной щит', _, 8)
        keybinds:bind_spell('Призыв горгульи', _, 9)
    end

    keybinds:bind_item('Знак превосходства')

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
end

function BHelper.modules.deathknight.damage:macros()
    if (unholy) then macros:create('PetControlTV', '/bh tv pet_control', 42, 273) end
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
        if ((player:is_equipped_item('Знак превосходства')) and
            (player:can_use_item('Знак превосходства'))) then
            return keybinds:show_item('Знак превосходства')
        end

        if ((runes.all_cooldown) and (player:can_cast('Усиление рунического оружия'))) then
            return keybinds:show_spell('Усиление рунического оружия')
        end

        if ((runes[1].cooldown > 0) and (runes[2].cooldown > 0) and (player:aura('Кровоотвод', true) > 0)) then
            return keybinds:show_macro('Кровоотвод')
        end

        if ((runes[1].cooldown > 0) and (runes[2].cooldown > 0) and (player:can_cast('Кровоотвод'))) then
            return keybinds:show_spell('Кровоотвод')
        end

        if (frost) then
            if (player:can_cast('Несокрушимая броня')) then
                return keybinds:show_spell('Несокрушимая броня')
            end
        elseif (unholy) then
            if (player:can_cast('Костяной щит')) then
                return keybinds:show_spell('Костяной щит')
            end
        end

        if (frost) then
            if (player:can_cast('Воскрешение мертвых')) then
                return keybinds:show_spell('Воскрешение мертвых')
            end
        elseif (unholy) then
            if (player:can_cast('Призыв горгульи')) then
                return keybinds:show_spell('Призыв горгульи')
            end
        end

        if (player:can_cast('Кровавое неистовство(Расовая)')) then
            return keybinds:show_spell('Кровавое неистовство(Расовая)')
        end
    end

    if (frost) then
        if ((player:aura('Морозная дымка', true) > 0) and
            (player:can_cast('Воющий ветер', true))) then
            return keybinds:show_spell('Воющий ветер')
        end

        if ((player:aura('Машина для убийств', true) > 0) and
            (player:can_cast_on_enemy('Ледяной удар'))) then
            return keybinds:show_spell('Ледяной удар')
        end
    end

    if ((multiple_attack) and (disease_exists)) then
        if ((not vars.pestilence_timeout) and (player:can_cast_on_enemy('Мор'))) then
            return keybinds:show_spell('Мор')
        end

        if (frost) then
            if (player:can_cast('Воющий ветер', true)) then
                return keybinds:show_spell('Воющий ветер')
            end
        end

        if (player:can_cast('Вскипание крови', true)) then
            return keybinds:show_spell('Вскипание крови')
        end
    end

    if ((target:aura('Озноб', true) == 0) and
        (player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return keybinds:show_spell('Ледяное прикосновение')
    end

    if ((target:aura('Кровавая чума', true) == 0) and (player:can_cast_on_enemy('Удар чумы'))) then
        return keybinds:show_spell('Удар чумы')
    end

    if (frost) then
        if (player:can_cast_on_enemy('Уничтожение')) then
            return keybinds:show_spell('Уничтожение')
        end
    elseif (unholy) then
        if (player:can_cast_on_enemy('Удар Плети')) then
            return keybinds:show_spell('Удар Плети')
        end
    end

    if ((runes[1].type == 1) and (runes[1].cooldown == 0) and (player:can_cast_on_enemy('Кровавый удар'))) then
        return keybinds:show_spell('Кровавый удар')
    end
    if ((runes[2].type == 1) and (runes[2].cooldown == 0) and (player:can_cast_on_enemy('Кровавый удар'))) then
        return keybinds:show_spell('Кровавый удар')
    end

    if (frost) then
        if (player:can_cast_on_enemy('Ледяной удар')) then
            return keybinds:show_spell('Ледяной удар')
        end
    elseif (unholy) then
        if (player:can_cast_on_enemy('Лик смерти')) then
            return keybinds:show_spell('Лик смерти')
        end
    end

    if ((player:aura('Зимний горн') == 0) and (player:aura('Сила земли') == 0) and
        (player:can_cast('Зимний горн'))) then return keybinds:show_spell('Зимний горн') end
end

function BHelper.modules.deathknight.damage:UNIT_SPELLCAST_SUCCEEDED(unit_id, spellName)
    if (unit_id ~= 'player') then return end

    if (spellName == 'Ледяное прикосновение') then vars.pestilence_timeout = false end
    if (spellName == 'Удар чумы') then vars.pestilence_timeout = false end
    if (spellName == 'Мор') then vars.pestilence_timeout = true end
    if (spellName == 'Войско мертвых') then vars.army_timeout = true end
end

function BHelper.modules.deathknight.damage:start()
    vars.army_timeout = true
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
