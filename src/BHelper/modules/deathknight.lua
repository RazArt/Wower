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
local module = BHelper.modules.deathknight

function BHelper.modules.deathknight.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.silence == nil) then self.vars.silence = false end

    keybinds:bind_spell('Власть льда')
    keybinds:bind_spell('Кровь вампира')
    keybinds:bind_spell('Кровоотвод')
    keybinds:bind_spell('Захват рун')
    keybinds:bind_spell('Зимний горн')
    keybinds:bind_spell('Заморозка разума')
    keybinds:bind_spell('Удушение')
    keybinds:bind_spell('Ледяные оковы')
    keybinds:bind_spell('Рунический удар')
    keybinds:bind_spell('Ледяное прикосновение')
    keybinds:bind_spell('Удар чумы')
    keybinds:bind_spell('Удар в сердце')
    keybinds:bind_spell('Удар смерти')
    keybinds:bind_spell('Кровавый удар')
    keybinds:bind_spell('Мор')
    keybinds:bind_spell('Вскипание крови')
    keybinds:bind_spell('Лик смерти')
    keybinds:bind_spell('Войско мертвых')
    keybinds:bind_spell('Усиление рунического оружия')
    keybinds:bind_spell('Истерия')

    keybinds:bind_macro('Смертельный союз')

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
    self:register_event('PLAYER_TARGET_CHANGED')
end

function BHelper.modules.deathknight.default:macros()
    macros:create('Заморозка разума', '#showtooltip Заморозка разума\n/bh tv silence', 41)
    macros:create('Истерия',
                  '#showtooltip Истерия\n/bh c\n/cast [@focus,help,nodead] Истерия\n/cast [@target,help,nodead] Истерия\n/cast [@mouseover,help,nodead] Истерия',
                  23)
    macros:create('Смертельный союз',
                  '#showtooltip Смертельный союз\n/castsequence reset=120 Воскрешение мертвых, Смертельный союз')
    macros:create('Незыблемость льда', '#showtooltip\n/bh c\n/cast Незыблемость льда', 7)
    macros:create('Антимагический панцирь',
                  '#showtooltip\n/bh c\n/cancelaura Антимагический панцирь\n/cast Антимагический панцирь',
                  8)
    macros:create('Кровь вампира', '#showtooltip\n/bh c\n/cast Кровь вампира', 9)
    macros:create('Кровоотвод', '#showtooltip\n/bh c\n/cast Кровоотвод', 10)
    macros:create('Захват рун', '#showtooltip\n/bh c\n/cast Захват рун', 11)
    macros:create('Хватка смерти', '#showtooltip\n/bh c\n/cast Хватка смерти', 15)
    macros:create('Темная власть', '#showtooltip\n/bh c\n/cast Темная власть', 16)
    macros:create('Ледяные оковы', '#showtooltip\n/bh c\n/cast Ледяные оковы', 19)
    macros:create('Войско мертвых',
                  '#showtooltip\n/bh sv army_of_the_dead_timeout false\n/bh c\n/cast Войско мертвых', 21)
    macros:create('Усиление рунического оружия',
                  '#showtooltip\n/bh c\n/cast Усиление рунического оружия', 22)
    macros:create('Смерть и разложение',
                  '#showtooltip\n/bh c\n/cast Смерть и разложение', 2)
end

function BHelper.modules.deathknight.default:execute()
    if (player:can_cast('Рунический удар')) then keybinds:show_attack('Рунический удар') end

    if ((player:get_health_on_percent() < 20) and (player:get_power() >= 40) and
        ((player:can_cast('Воскрешение мертвых')) or
            (player:can_cast('Смертельный союз')))) then
        return keybinds:show_macro('Смертельный союз')
    end

    if ((player:get_health_on_percent() < 20) and (player:can_cast('Кровь вампира'))) then
        return keybinds:show_spell('Кровь вампира')
    end

    if ((player:get_health_on_percent() < 40) and (player:can_cast('Захват рун'))) then
        return keybinds:show_spell('Захват рун')
    end

    if (player:get_spell_cooldown('Войско мертвых') > 10) then self.vars.army_of_the_dead_timeout = true end
    if (not self.vars.army_of_the_dead_timeout) then
        if (player:can_cast('Войско мертвых')) then
            return keybinds:show_spell('Войско мертвых')
        end
        return true
    end

    if ((target:check_cast()) and (self.vars.silence) and (player:can_cast_on_enemy('Заморозка разума'))) then
        return keybinds:show_spell('Заморозка разума')
    end

    if ((player:aura('Власть льда') == 0) and (player:can_cast('Власть льда'))) then
        return keybinds:show_spell('Власть льда')
    end

    if ((player:aura('Зимний горн') == 0) and (player:aura('Сила земли') == 0) and
        (player:can_cast('Зимний горн'))) then return keybinds:show_spell('Зимний горн') end

    if ((player:check_low_threat()) and (player:can_cast('Кровоотвод'))) then
        return keybinds:show_spell('Кровоотвод')
    end
end

function BHelper.modules.deathknight.default:rotation_single()
    if ((target:get_name() == 'Волдырный зомби') and (target:aura('Ледяные оковы') == 0) and
        (player:can_cast_on_enemy('Ледяные оковы'))) then
        return keybinds:show_spell('Ледяные оковы')
    end

    if (((player:check_low_threat()) or (self.vars.opener) or (target:aura('Озноб', true) < 3)) and
        (player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return keybinds:show_spell('Ледяное прикосновение')
    end

    if (((player:check_low_threat()) or (self.vars.opener)) and (target:is_boss()) and
        (player:get_spell_cooldown('Ледяное прикосновение') > 3) and
        (player:can_cast('Усиление рунического оружия'))) then
        return keybinds:show_spell('Усиление рунического оружия')
    end

    if ((target:aura('Кровавая чума', true) < 3) and (player:can_cast_on_enemy('Удар чумы'))) then
        return keybinds:show_spell('Удар чумы')
    end

    if (((player:aura('Клинковая ограда') == 0) or (self:check_blood_rune_cooldown())) and
        (player:can_cast_on_enemy('Кровавый удар'))) then
        return keybinds:show_spell('Кровавый удар')
    end

    if ((not player:check_low_threat()) and (player:can_cast_on_enemy('Удар смерти'))) then
        return keybinds:show_spell('Удар смерти')
    end

    if ((player:get_power() == 100) and (player:can_cast_on_enemy('Лик смерти'))) then
        return keybinds:show_spell('Лик смерти')
    end
end

function BHelper.modules.deathknight.default:rotation_multiple()
    if (((player:check_low_threat()) or (target:aura('Озноб', true) < 3)) and
        (player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return keybinds:show_spell('Ледяное прикосновение')
    end

    if ((target:aura('Кровавая чума', true) < 3) and (player:can_cast_on_enemy('Удар чумы'))) then
        return keybinds:show_spell('Удар чумы')
    end

    if (((target:aura('Озноб', true) > 0) or (target:aura('Кровавая чума', true) > 0)) and
        (not self.vars.pestilence_timeout) and (player:can_cast_on_enemy('Мор'))) then
        return keybinds:show_spell('Мор')
    end

    if ((target:aura('Озноб', true) > 0) and (target:aura('Кровавая чума', true) > 0) and
        (player:can_cast('Вскипание крови'))) then
        return keybinds:show_spell('Вскипание крови')
    end

    if ((not player:check_low_threat()) and (player:can_cast_on_enemy('Удар смерти'))) then
        return keybinds:show_spell('Удар смерти')
    end

    if ((player:get_power() == 100) and (player:can_cast_on_enemy('Лик смерти'))) then
        return keybinds:show_spell('Лик смерти')
    end
end

function BHelper.modules.deathknight.default:death_ready_rune_count()
    local count = 0
    for i = 1, 6 do if (GetRuneType(i) == 4) then count = count + 1 end end
    return count
end

function BHelper.modules.deathknight.default:check_blood_rune_cooldown()
    local _, _, runeReady_1 = GetRuneCooldown(1)
    local _, _, runeReady_2 = GetRuneCooldown(2)
    if ((runeReady_1) and (runeReady_2)) then return true end
    return false
end

function BHelper.modules.deathknight.default:UNIT_SPELLCAST_SUCCEEDED(castGUID, spellName)
    if (spellName == 'Удар чумы') then self.vars.pestilence_timeout = false end
    if (spellName == 'Мор') then self.vars.pestilence_timeout = true end
    if (spellName == 'Войско мертвых') then self.vars.army_of_the_dead_timeout = true end
end

function BHelper.modules.deathknight.default:PLAYER_TARGET_CHANGED()
    self:start()
end

function BHelper.modules.deathknight.default:start()
    self.vars.army_of_the_dead_timeout = true
    self.vars.pestilence_timeout = true

    self.vars.opener = true
    timers:create(20, function()
        self.vars.opener = false
    end, 'opener')
end

function BHelper.modules.deathknight.fdk:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.attack_type == nil) then self.vars.attack_type = '1' end
    if (self.vars.silence == nil) then self.vars.silence = false end

    keybinds:bind_spell('Власть крови')
    keybinds:bind_spell('Кровоотвод')
    keybinds:bind_spell('Зимний горн')
    keybinds:bind_spell('Заморозка разума')
    keybinds:bind_spell('Удушение')
    keybinds:bind_spell('Несокрушимая броня')
    keybinds:bind_spell('Ледяные оковы')
    keybinds:bind_spell('Рунический удар')
    keybinds:bind_spell('Ледяное прикосновение')
    keybinds:bind_spell('Удар чумы')
    keybinds:bind_spell('Ледяной удар')
    keybinds:bind_spell('Кровавый удар')
    keybinds:bind_spell('Уничтожение')
    keybinds:bind_spell('Воющий ветер')
    keybinds:bind_spell('Мор')
    keybinds:bind_spell('Вскипание крови')
    keybinds:bind_spell('Воскрешение мертвых')
    keybinds:bind_spell('Войско мертвых')
    keybinds:bind_spell('Усиление рунического оружия')

    keybinds:bind_macro('КровоотводClear')

    keybinds:bind_item('Знак превосходства')
    keybinds:bind_item('Отмщение Отрекшихся')

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
    self:register_event('PLAYER_TARGET_CHANGED')

    core.action:set('rotation')
end

function BHelper.modules.deathknight.fdk:macros()
    macros:create('Заморозка разумаTV', '#showtooltip Заморозка разума\n/bh tv silence',
                  41)
    macros:create('Кровоотвод',
                  '#showtooltip\n/bh c\n/cancelaura Кровоотвод\n/cast Кровоотвод', 7)
    macros:create('Несокрушимая броня',
                  '#showtooltip\n/bh c\n/cast Несокрушимая броня\n/use Отмщение Отрекшихся',
                  8)
    macros:create('Воскрешение мертвых',
                  '#showtooltip\n/bh c\n/cast Воскрешение мертвых', 9)
    macros:create('Усиление рунического оружия',
                  '#showtooltip\n/bh c\n/cast Усиление рунического оружия', 10)
    macros:create('Незыблемость льда', '#showtooltip\n/bh c\n/cast Незыблемость льда',
                  11)
    macros:create('Антимагический панцирь',
                  '#showtooltip\n/bh c\n/cancelaura Антимагический панцирь\n/cast Антимагический панцирь',
                  12)
    macros:create('Хватка смерти', '#showtooltip\n/bh c\n/cast Хватка смерти', 15)
    macros:create('Темная власть', '#showtooltip\n/bh c\n/cast Темная власть', 16)
    macros:create('Ледяные оковы', '#showtooltip\n/bh c\n/cast Ледяные оковы', 19)
    macros:create('Воющий ветер', '#showtooltip\n/bh c\n/cast Воющий ветер', 20)
    macros:create('Войско мертвых',
                  '#showtooltip\n/bh sv army_of_the_dead_timeout false\n/bh c\n/cast Войско мертвых', 21)
    macros:create('Смерть и разложение',
                  '#showtooltip\n/bh c\n/cast Смерть и разложение', 2)

    macros:create('S', '/startattack\n/bh sv attack_type 1\n/bh', 13, 1263)
    macros:create('M', '/startattack\n/bh sv attack_type 2\n/bh', 14, 1264)
end

function BHelper.modules.deathknight.fdk:rotation()
    local ready_rune_count = module:get_ready_rune_count()
    local blood_rune_cooldown = module:check_blood_rune_cooldown()
    local can_use_blood_rune = false
    local disease_exists = false

    if ((target:aura('Озноб', true) > blood_rune_cooldown) and
        (target:aura('Кровавая чума', true) > blood_rune_cooldown)) then can_use_blood_rune = true end

    if ((target:aura('Озноб', true) > 0) and (target:aura('Кровавая чума', true) > 0)) then
        disease_exists = true
    end

    if (player:can_cast('Рунический удар')) then keybinds:show_attack('Рунический удар') end

    if (player:get_spell_cooldown('Войско мертвых') > 10) then self.vars.army_of_the_dead_timeout = true end
    if (not self.vars.army_of_the_dead_timeout) then
        if (player:can_cast('Войско мертвых')) then
            return keybinds:show_spell('Войско мертвых')
        end
        return true
    end

    if ((target:check_cast()) and (self.vars.silence) and (player:can_cast_on_enemy('Заморозка разума'))) then
        return keybinds:show_spell('Заморозка разума')
    end

    if ((player:aura('Власть крови') == 0) and (player:aura('Власть льда') == 0) and
        (player:can_cast('Власть крови'))) then return keybinds:show_spell('Власть крови') end

    if ((player:aura('Зимний горн') == 0) and (player:aura('Сила земли') == 0) and
        (player:can_cast('Зимний горн'))) then return keybinds:show_spell('Зимний горн') end

    if ((player:check_burst_mode()) and (not self.burst_cooldown)) then
        if (player:can_cast('Воскрешение мертвых')) then
            return keybinds:show_spell('Воскрешение мертвых')
        end

        if ((player:check_equipped_item('Знак превосходства')) and
            (player:can_use_item('Знак превосходства'))) then
            return keybinds:show_item('Знак превосходства')
        end

        if ((player:check_equipped_item('Отмщение Отрекшихся')) and
            (player:can_use_item('Отмщение Отрекшихся'))) then
            return keybinds:show_item('Отмщение Отрекшихся')
        end

        if (module:check_rune_cooldown()) then
            if ((player:aura('Кровоотвод', true) > 0)) then
                return keybinds:show_macro('Кровоотвод')
            end

            if ((player:can_cast('Усиление рунического оружия'))) then
                return keybinds:show_spell('Усиление рунического оружия')
            end
        end

        if ((player:can_cast('Кровоотвод'))) then return keybinds:show_spell('Кровоотвод') end

        if ((player:can_cast('Несокрушимая броня'))) then
            return keybinds:show_spell('Несокрушимая броня')
        end
    end

    if (disease_exists) then
        if ((target:aura('Озноб', true) < 3) or (target:aura('Кровавая чума', true) < 3)) then
            if ((player:can_cast_on_enemy('Мор'))) then return keybinds:show_spell('Мор') end
            return true
        end

        if ((self.vars.attack_type == '2') and
            (math.ceil(target:aura('Озноб', true)) ~= math.ceil(target:aura('Кровавая чума', true))) and
            (player:can_cast_on_enemy('Мор'))) then return keybinds:show_spell('Мор') end
    end

    if ((self.vars.attack_type == '1') and (player:aura('Машина для убийств', true) > 0) and
        (player:can_cast_on_enemy('Ледяной удар'))) then
        return keybinds:show_spell('Ледяной удар')
    end

    if (self.vars.attack_type == '2') then
        if ((player:aura('Морозная дымка', true) > 0) and
            (player:check_spell_range('Ледяной удар')) and (player:can_cast('Воющий ветер'))) then
            return keybinds:show_spell('Воющий ветер')
        end

        if ((disease_exists) and (player:check_spell_range('Ледяной удар')) and
            (player:can_cast('Воющий ветер'))) then
            return keybinds:show_spell('Воющий ветер')
        end

        if ((can_use_blood_rune) and (player:check_spell_range('Ледяной удар')) and
            (player:can_cast('Вскипание крови'))) then
            return keybinds:show_spell('Вскипание крови')
        end

        if ((disease_exists) and (player:aura('Машина для убийств', true) > 0) and
            (player:can_cast_on_enemy('Ледяной удар'))) then
            return keybinds:show_spell('Ледяной удар')
        end
    end

    if ((target:aura('Озноб', true) == 0) and
        (player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return keybinds:show_spell('Ледяное прикосновение')
    end

    if ((target:aura('Кровавая чума', true) == 0) and (player:can_cast_on_enemy('Удар чумы'))) then
        return keybinds:show_spell('Удар чумы')
    end

    if ((ready_rune_count[2] >= 1) and (ready_rune_count[3] >= 1) and
        (player:can_cast_on_enemy('Уничтожение'))) then
        return keybinds:show_spell('Уничтожение')
    end

    if (((ready_rune_count[2] >= 1) or (ready_rune_count[3] >= 1)) and (ready_rune_count[4] >= 1) and
        (can_use_blood_rune) and (player:can_cast_on_enemy('Уничтожение'))) then
        return keybinds:show_spell('Уничтожение')
    end

    if ((ready_rune_count[2] == 0) and (ready_rune_count[3] == 0) and (ready_rune_count[4] == 2) and
        (target:aura('Озноб', true) > 10.5) and (target:aura('Кровавая чума', true) > 10.5) and
        (player:can_cast_on_enemy('Уничтожение'))) then
        return keybinds:show_spell('Уничтожение')
    end

    if ((self.vars.attack_type == '1') and (can_use_blood_rune) and
        (player:can_cast_on_enemy('Кровавый удар'))) then
        return keybinds:show_spell('Кровавый удар')
    end

    if ((player:can_cast_on_enemy('Ледяной удар'))) then
        return keybinds:show_spell('Ледяной удар')
    end

    if ((player:aura('Морозная дымка', true) > 0) and (player:check_spell_range('Ледяной удар')) and
        (player:can_cast('Воющий ветер'))) then return keybinds:show_spell('Воющий ветер') end

    if ((player:get_power() <= 120) and (player:can_cast('Зимний горн'))) then
        return keybinds:show_spell('Зимний горн')
    end
end

function BHelper.modules.deathknight:get_ready_rune_count()
    local ready_rune_count = {0, 0, 0, 0}
    for i = 1, 6 do
        if (select(3, GetRuneCooldown(i))) then
            ready_rune_count[GetRuneType(i)] = ready_rune_count[GetRuneType(i)] + 1
        end
    end
    return ready_rune_count
end

function BHelper.modules.deathknight:check_blood_rune_cooldown()
    local cooldowns = {}
    for i = 1, 2 do
        local start, duration = GetRuneCooldown(i)
        local cooldown = start + duration - GetTime() + 0.5
        cooldowns[i] = (cooldown > 0) and cooldown or 0
    end
    return (cooldowns[1] > 0) and cooldowns[1] or cooldowns[2]
end

function BHelper.modules.deathknight:check_rune_cooldown()
    for i = 1, 6 do if (select(3, GetRuneCooldown(i))) then return false end end
    return true
end

function BHelper.modules.deathknight.fdk:UNIT_SPELLCAST_SUCCEEDED(castGUID, spellName)
    if (spellName == 'Войско мертвых') then self.vars.army_of_the_dead_timeout = true end
end

function BHelper.modules.deathknight.fdk:PLAYER_TARGET_CHANGED()
    self:start()
end

function BHelper.modules.deathknight.fdk:start()
    self.vars.army_of_the_dead_timeout = true
end

function BHelper.modules.deathknight.fdk:stop()
    self.vars.attack_type = '1'
end
