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

local rune_cooldown = {}
local rune_count = {}
local rune_type = {}
local all_rune_cooldown = true
local ready_rune_count = {}
local can_use_blood_rune = false

local usable_spec = ''

local vars = nil

function BHelper.modules.deathknight:init()
    usable_spec = (GetSpellInfo('Ледяной удар')) and 'frost' or usable_spec
    usable_spec = (GetSpellInfo('Удар плети')) and 'unholy' or usable_spec

    timers:create(3, function()
        usable_spec = (GetSpellInfo('Ледяной удар')) and 'frost' or usable_spec
        usable_spec = (GetSpellInfo('Удар плети')) and 'unholy' or usable_spec
    end, 'dk_spec', true)
end

function BHelper.modules.deathknight:execute()
    all_rune_cooldown = true
    for i = 1, 4 do
        rune_count[i] = 0
        ready_rune_count[i] = 0
    end

    for i = 1, 6 do
        local start, duration = GetRuneCooldown(i)
        rune_cooldown[i] = (start > 0) and start + duration - GetTime() or 0
        rune_count[GetRuneType(i)] = rune_count[GetRuneType(i)] + 1
        rune_type[i] = GetRuneType(i)
        if (rune_cooldown[i] == 0) then all_rune_cooldown = false end

        if (select(3, GetRuneCooldown(i))) then
            ready_rune_count[GetRuneType(i)] = ready_rune_count[GetRuneType(i)] + 1
        end
    end

    can_use_blood_rune = false
    if ((rune_cooldown[1] == 0) and (rune_cooldown[2] == 0)) then
        can_use_blood_rune = true
    elseif (((rune_cooldown[1] > 0) and (rune_cooldown[2] == 0)) or ((rune_cooldown[1] == 0) and (rune_cooldown[2] > 0))) then
        local blood_rune_cd = (rune_cooldown[1] > 0) and rune_cooldown[1] or rune_cooldown[2]
        if ((target:aura('Озноб', true) > blood_rune_cd) and
            (target:aura('Кровавая чума', true) > blood_rune_cd)) then can_use_blood_rune = true end
    end

    disease_exists = ((target:aura('Озноб', true) > 0) and (target:aura('Кровавая чума', true) > 0))
end

do -- Танк ГДК
    function BHelper.modules.deathknight.default:init()
        vars = self.vars

        self.settings.type = 'battle'
        self.settings.only_combat_start = true
        self.settings.usable_equip = 'TANK'

        if (not vars.silence) then vars.silence = false end

        keybinds:bind_spell('Власть льда')
        keybinds:bind_spell('Кровь вампира')
        keybinds:bind_spell('Кровоотвод')
        keybinds:bind_spell('Захват рун')
        keybinds:bind_spell('Зимний горн')
        keybinds:bind_spell('Заморозка разума')
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
        keybinds:bind_spell('Кровавое неистовство(Расовая)')

        keybinds:bind_macro('Смертельный союз')

        self:register_event('UNIT_SPELLCAST_SUCCEEDED')
    end

    function BHelper.modules.deathknight.default:macros()
        macros:create('Заморозка разума', '#showtooltip Заморозка разума\n/bh tv silence',
                      41)
        macros:create('Смертельный союз',
                      '#showtooltip Смертельный союз\n/castsequence reset=120 Воскрешение мертвых, Смертельный союз')
        macros:create('Незыблемость льда',
                      '#showtooltip\n/bh c\n/cast Незыблемость льда', 7)
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
                      '#showtooltip\n/bh sv army_timeout false\n/bh c\n/cast Войско мертвых', 20)
        macros:create('Усиление рунического оружия',
                      '#showtooltip\n/bh c\n/cast Усиление рунического оружия', 21)
        macros:create('Истерия',
                      '#showtooltip Истерия\n/bh c\n/cast [@focus,help,nodead] Истерия\n/cast [@target,help,nodead] Истерия\n/cast [@mouseover,help,nodead] Истерия',
                      22)
        macros:create('Смерть и разложение',
                      '#showtooltip\n/bh c 1\n/cast Смерть и разложение', 2)
    end

    function BHelper.modules.deathknight.default:rotation_single()
        vars.attack_type = '1'
        return self:rotation()
    end

    function BHelper.modules.deathknight.default:rotation_multiple()
        vars.attack_type = '2'
        return self:rotation()
    end

    function BHelper.modules.deathknight.default:rotation()
        if (player:can_cast('Рунический удар')) then
            keybinds:show_attack('Рунический удар')
        end

        if ((player:health_on_percent() < 20) and (player:power() >= 40) and
            ((player:can_cast('Воскрешение мертвых')) or
                (player:can_cast('Смертельный союз')))) then
            return keybinds:show_macro('Смертельный союз')
        end

        if ((player:health_on_percent() < 20) and (player:can_cast('Кровь вампира'))) then
            return keybinds:show_spell('Кровь вампира')
        end

        if ((player:health_on_percent() < 40) and (player:can_cast('Захват рун'))) then
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

        if ((player:aura('Власть льда') == 0) and (player:can_cast('Власть льда'))) then
            return keybinds:show_spell('Власть льда')
        end

        if (((target:name() == 'Волдырный зомби') or (target:name() == 'Большой слизнюк')) and
            (target:aura('Ледяные оковы') == 0) and (player:can_cast_on_enemy('Ледяные оковы'))) then
            return keybinds:show_spell('Ледяные оковы')
        end

        if ((vars.attack_type == '2') and (disease_exists)) then
            if ((not vars.pestilence_timeout) and (player:can_cast_on_enemy('Мор'))) then
                return keybinds:show_spell('Мор')
            end

            if ((rune_cooldown[1] == 0) and (rune_cooldown[2] == 0) and (player:check_spell_range('Удар чумы')) and
                (player:can_cast('Вскипание крови'))) then
                return keybinds:show_spell('Вскипание крови')
            end
        end

        if (((not player:has_stable_threat()) or (self.opener) or (target:aura('Озноб', true) == 0)) and
            (player:can_cast_on_enemy('Ледяное прикосновение'))) then
            return keybinds:show_spell('Ледяное прикосновение')
        end

        if (((not player:has_stable_threat()) or (self.opener)) and (target:is_boss()) and
            (player:spell_cooldown('Ледяное прикосновение') > 3) and
            (player:can_cast('Усиление рунического оружия'))) then
            return keybinds:show_spell('Усиление рунического оружия')
        end

        if ((not player:has_stable_threat()) and (target:is_boss()) and
            (player:spell_cooldown('Ледяное прикосновение') > 3) and
            (player:can_cast('Кровоотвод'))) then return keybinds:show_spell('Кровоотвод') end

        if ((target:aura('Кровавая чума', true) == 0) and (player:can_cast_on_enemy('Удар чумы'))) then
            return keybinds:show_spell('Удар чумы')
        end

        if ((player:aura('Клинковая ограда') == 0) and (player:health_on_percent() > 80)) then
            if (player:can_cast_on_enemy('Удар в сердце')) then
                return keybinds:show_spell('Удар в сердце')
            end
            if (player:can_cast_on_enemy('Кровавый удар')) then
                return keybinds:show_spell('Кровавый удар')
            end
        end

        if ((player:has_stable_threat()) and (player:can_cast_on_enemy('Удар смерти'))) then
            return keybinds:show_spell('Удар смерти')
        end

        if ((rune_cooldown[1] == 0) and (rune_cooldown[2] == 0)) then
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
        vars.pestilence_timeout = true

        self.opener = true
        self.opener = false
        timers:create(20, function()
            self.opener = false
        end, 'opener')
    end

    function BHelper.modules.deathknight.default:stop()
        core.action:set('rotation_single')
    end
end

do -- ДД ФДК
    function BHelper.modules.deathknight.damage:init()
        vars = self.vars
        self.settings.type = 'battle'
        self.settings.only_combat_start = true
        if (usable_spec == 'frost') then
            self.settings.usable_equip = 'DPS'
        elseif (usable_spec == 'unholy') then
            self.settings.usable_equip = 'DPS Unh'
        end

        if (not vars.attack_type) then vars.attack_type = '1' end
        if (not vars.silence) then vars.silence = false end
        if (not vars.pet_control) then vars.pet_control = true end

        vars.army_timeout = true
        vars.pestilence_timeout = true

        keybinds:bind_spell('Власть крови')
        keybinds:bind_spell('Власть льда')
        keybinds:bind_spell('Власть нечестивости')
        keybinds:bind_spell('Зимний горн')

        keybinds:bind_spell('Кровоотвод')
        keybinds:bind_spell('Несокрушимая броня')
        keybinds:bind_spell('Костяной щит')
        keybinds:bind_spell('Усиление рунического оружия')

        keybinds:bind_spell('Заморозка разума')
        keybinds:bind_spell('Рунический удар')
        keybinds:bind_spell('Ледяные оковы')
        keybinds:bind_spell('Ледяное прикосновение')
        keybinds:bind_spell('Удар чумы')
        keybinds:bind_spell('Кровавый удар')

        keybinds:bind_spell('Уничтожение')
        keybinds:bind_spell('Ледяной удар')
        keybinds:bind_spell('Воющий ветер')
        keybinds:bind_spell('Воскрешение мертвых')

        keybinds:bind_spell('Удар Плети')
        keybinds:bind_spell('Лик смерти')
        keybinds:bind_spell('Призыв горгульи')

        keybinds:bind_spell('Мор')
        keybinds:bind_spell('Вскипание крови')
        keybinds:bind_spell('Войско мертвых')
        keybinds:bind_spell('Кровавое неистовство(Расовая)')

        keybinds:bind_macro('Кровоотвод')

        keybinds:bind_item('Знак превосходства')
        keybinds:bind_item('Отмщение Отрекшихся')

        self:register_event('UNIT_SPELLCAST_SUCCEEDED')

        core.action:set('rotation')
    end

    function BHelper.modules.deathknight.damage:macros()
        macros:create('Заморозка разумаTV',
                      '#showtooltip Заморозка разума\n/bh tv silence', 41)
        macros:create('Кровоотвод',
                      '#showtooltip\n/bh c\n/cancelaura Кровоотвод\n/cast Кровоотвод', 7)
        if (usable_spec == 'frost') then
            macros:create('Несокрушимая броня',
                          '#showtooltip\n/bh c\n/cast Несокрушимая броня', 8)
            macros:create('Воскрешение мертвых',
                          '#showtooltip\n/bh c\n/cast Воскрешение мертвых', 9)
        elseif (usable_spec == 'unholy') then
            macros:create('Костяной щит', '#showtooltip\n/bh c\n/cast Костяной щит', 8)
            macros:create('Призыв горгульи', '#showtooltip\n/bh c\n/cast Призыв горгульи', 9)
            macros:create('PetControlTV', '/bh tv pet_control', 42, 273)
        end

        macros:create('Усиление рунического оружия',
                      '#showtooltip\n/bh c\n/cast Усиление рунического оружия', 10)
        macros:create('Незыблемость льда',
                      '#showtooltip\n/bh c\n/cast Незыблемость льда', 11)
        macros:create('Антимагический панцирь',
                      '#showtooltip\n/bh c\n/cancelaura Антимагический панцирь\n/cast Антимагический панцирь',
                      12)
        macros:create('Хватка смерти', '#showtooltip\n/bh c\n/cast Хватка смерти', 15)
        macros:create('Темная власть', '#showtooltip\n/bh c\n/cast Темная власть', 16)
        macros:create('Войско мертвых',
                      '#showtooltip\n/bh sv army_timeout false\n/bh c\n/cast Войско мертвых', 28)
        macros:create('Ледяные оковы', '#showtooltip\n/bh c\n/cast Ледяные оковы', 29)
        macros:create('Смерть и разложение',
                      '#showtooltip\n/bh c\n/cast Смерть и разложение', 2)
        macros:create('Удар чумы',
                      '#showtooltip\n/bh c\n/cast [mod:shift] Удар чумы; Ледяное прикосновение',
                      3)
        if (usable_spec == 'frost') then
            macros:create('Уничтожение',
                          '#showtooltip\n/bh c\n/cast [mod:shift] Воющий ветер; Уничтожение', 4)
            macros:create('Ледяной удар',
                          '#showtooltip\n/bh c\n/cast [mod:shift] Кровавый удар; Ледяной удар', 5)
        elseif (usable_spec == 'unholy') then
            macros:create('Уничтожение', '#showtooltip\n/bh c\n/cast Удар плети', 4)
            macros:create('Ледяной удар',
                          '#showtooltip\n/bh c\n/cast [mod:shift] Кровавый удар; Лик смерти', 5)
        end
        if (usable_spec == 'unholy') then
            macros:create('Воскрешение мертвых',
                          '#showtooltip\n/bh c\n/cast Воскрешение мертвых', 34)
        end
    end

    function BHelper.modules.deathknight.damage:rotation_single()
        vars.attack_type = '1'
        return self:rotation()
    end

    function BHelper.modules.deathknight.damage:rotation_multiple()
        vars.attack_type = '2'
        return self:rotation()
    end

    function BHelper.modules.deathknight.damage:rotation()
        if (player:can_cast('Рунический удар')) then
            keybinds:show_attack('Рунический удар')
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

        if ((player:aura('Власть крови') == 0) and (player:aura('Власть льда') == 0) and
            (player:can_cast('Власть крови'))) then
            return keybinds:show_spell('Власть крови')
        end

        if (((target:name() == 'Волдырный зомби') or (target:name() == 'Большой слизнюк')) and
            (target:aura('Ледяные оковы') == 0) and (player:can_cast_on_enemy('Ледяные оковы'))) then
            return keybinds:show_spell('Ледяные оковы')
        end

        if ((player:is_burst()) and (not self.burst_cooldown)) then
            if ((player:is_equipped_item('Знак превосходства')) and
                (player:can_use_item('Знак превосходства'))) then
                return keybinds:show_item('Знак превосходства')
            end

            if ((player:is_equipped_item('Отмщение Отрекшихся')) and
                (player:can_use_item('Отмщение Отрекшихся'))) then
                return keybinds:show_item('Отмщение Отрекшихся')
            end

            if ((all_rune_cooldown) and (player:can_cast('Усиление рунического оружия'))) then
                return keybinds:show_spell('Усиление рунического оружия')
            end

            if ((rune_cooldown[1] > 0) and (rune_cooldown[2] > 0) and (player:aura('Кровоотвод', true) > 0)) then
                return keybinds:show_macro('Кровоотвод')
            end

            if ((rune_cooldown[1] > 0) and (rune_cooldown[2] > 0) and (player:can_cast('Кровоотвод'))) then
                return keybinds:show_spell('Кровоотвод')
            end

            if (usable_spec == 'frost') then
                if (player:can_cast('Несокрушимая броня')) then
                    return keybinds:show_spell('Несокрушимая броня')
                end
            elseif (usable_spec == 'unholy') then
                if (player:can_cast('Костяной щит')) then
                    return keybinds:show_spell('Костяной щит')
                end
            end

            if (usable_spec == 'frost') then
                if (player:can_cast('Воскрешение мертвых')) then
                    return keybinds:show_spell('Воскрешение мертвых')
                end
            elseif (usable_spec == 'unholy') then
                if (player:can_cast('Призыв горгульи')) then
                    return keybinds:show_spell('Призыв горгульи')
                end
            end

            if (player:can_cast('Кровавое неистовство(Расовая)')) then
                return keybinds:show_spell('Кровавое неистовство(Расовая)')
            end
        end

        if (usable_spec == 'frost') then
            if ((player:aura('Морозная дымка', true) > 0) and
                (player:check_spell_range('Удар чумы')) and (player:can_cast('Воющий ветер'))) then
                return keybinds:show_spell('Воющий ветер')
            end

            if ((player:aura('Машина для убийств', true) > 0) and
                (player:can_cast_on_enemy('Ледяной удар'))) then
                return keybinds:show_spell('Ледяной удар')
            end
        end

        if ((vars.attack_type == '2') and (disease_exists)) then
            if ((not vars.pestilence_timeout) and (player:can_cast_on_enemy('Мор'))) then
                return keybinds:show_spell('Мор')
            end

            if (usable_spec == 'frost') then
                if ((player:check_spell_range('Удар чумы')) and (player:can_cast('Воющий ветер'))) then
                    return keybinds:show_spell('Воющий ветер')
                end
            end

            if ((player:check_spell_range('Удар чумы')) and (player:can_cast('Вскипание крови'))) then
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

        if (usable_spec == 'frost') then
            if (player:can_cast_on_enemy('Уничтожение')) then
                return keybinds:show_spell('Уничтожение')
            end
        elseif (usable_spec == 'unholy') then
            if (player:can_cast_on_enemy('Удар Плети')) then
                return keybinds:show_spell('Удар Плети')
            end
        end

        if ((rune_type[1] == 1) and (rune_cooldown[1] == 0) and (player:can_cast_on_enemy('Кровавый удар'))) then
            return keybinds:show_spell('Кровавый удар')
        end
        if ((rune_type[2] == 1) and (rune_cooldown[2] == 0) and (player:can_cast_on_enemy('Кровавый удар'))) then
            return keybinds:show_spell('Кровавый удар')
        end

        if (usable_spec == 'frost') then
            if (player:can_cast_on_enemy('Ледяной удар')) then
                return keybinds:show_spell('Ледяной удар')
            end
        elseif (usable_spec == 'unholy') then
            if (player:can_cast_on_enemy('Лик смерти')) then
                return keybinds:show_spell('Лик смерти')
            end
        end

        if ((player:aura('Зимний горн') == 0) and (player:aura('Сила земли') == 0) and
            (player:can_cast('Зимний горн'))) then return keybinds:show_spell('Зимний горн') end
    end

    function BHelper.modules.deathknight.damage:UNIT_SPELLCAST_SUCCEEDED(unit_id, spellName)
        if (unit_id ~= 'player') then return end

        if (spellName == 'Удар чумы') then vars.pestilence_timeout = false end
        if (spellName == 'Мор') then vars.pestilence_timeout = true end
        if (spellName == 'Войско мертвых') then vars.army_timeout = true end
    end

    function BHelper.modules.deathknight.damage:start()
        vars.army_timeout = true
        vars.pestilence_timeout = true
    end

    function BHelper.modules.deathknight.damage:stop()
        core.action:set('rotation_single')
    end

    -- if (player:can_cast_on_enemy('Удар Плети')) then
    --         if ((ready_rune_count[2] >= 1) and (ready_rune_count[3] >= 1)) then
    --             return keybinds:show_spell('Удар Плети')
    --         end

    --         if (((ready_rune_count[2] >= 1) or (ready_rune_count[3] >= 1)) and (ready_rune_count[4] >= 1) and
    --             (can_use_blood_rune)) then return keybinds:show_spell('Удар Плети') end

    --         if ((ready_rune_count[2] == 0) and (ready_rune_count[3] == 0) and (ready_rune_count[4] == 2) and
    --             (target:aura('Озноб', true) > 10.5) and (target:aura('Кровавая чума', true) > 10.5)) then
    --             return keybinds:show_spell('Удар Плети')
    --         end
    --     end
end
