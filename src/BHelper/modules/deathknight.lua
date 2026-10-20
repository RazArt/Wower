function BHelper.modules.deathknight.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Власть льда')
    BHelper.keybinds:bind_spell('Кровь вампира')
    BHelper.keybinds:bind_spell('Кровоотвод')
    BHelper.keybinds:bind_spell('Захват рун')
    BHelper.keybinds:bind_macro('Смертельный союз')
    BHelper.keybinds:bind_spell('Зимний горн')
    BHelper.keybinds:bind_spell('Заморозка разума')
    BHelper.keybinds:bind_spell('Удушение')
    BHelper.keybinds:bind_spell('Ледяные оковы')
    BHelper.keybinds:bind_spell('Рунический удар')
    BHelper.keybinds:bind_spell('Ледяное прикосновение')
    BHelper.keybinds:bind_spell('Удар чумы')
    BHelper.keybinds:bind_spell('Удар в сердце')
    BHelper.keybinds:bind_spell('Удар смерти')
    BHelper.keybinds:bind_spell('Кровавый удар')
    BHelper.keybinds:bind_spell('Мор')
    BHelper.keybinds:bind_spell('Вскипание крови')
    BHelper.keybinds:bind_spell('Лик смерти')
    BHelper.keybinds:bind_spell('Войско мертвых')
    BHelper.keybinds:bind_spell('Усиление рунического оружия')
    BHelper.keybinds:bind_spell('Истерия')

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
    self:register_event('PLAYER_TARGET_CHANGED')
end

function BHelper.modules.deathknight.default:macros()
    BHelper.macros:create('Заморозка разума',
                          '#showtooltip Заморозка разума\n/bh tv silence', 41)
    BHelper.macros:create('Истерия',
                          '#showtooltip Истерия\n/bh c\n/cast [@focus,help,nodead] Истерия\n/cast [@target,help,nodead] Истерия\n/cast [@mouseover,help,nodead] Истерия',
                          23)
    BHelper.macros:create('Смертельный союз',
                          '#showtooltip Смертельный союз\n/castsequence reset=120 Воскрешение мертвых, Смертельный союз')
    BHelper.macros:create('Незыблемость льда',
                          '#showtooltip\n/bh c\n/cast Незыблемость льда', 7)
    BHelper.macros:create('Антимагический панцирь',
                          '#showtooltip\n/bh c\n/cancelaura Антимагический панцирь\n/cast Антимагический панцирь',
                          8)
    BHelper.macros:create('Кровь вампира', '#showtooltip\n/bh c\n/cast Кровь вампира', 9)
    BHelper.macros:create('Кровоотвод', '#showtooltip\n/bh c\n/cast Кровоотвод', 10)
    BHelper.macros:create('Захват рун', '#showtooltip\n/bh c\n/cast Захват рун', 11)
    BHelper.macros:create('Хватка смерти', '#showtooltip\n/bh c\n/cast Хватка смерти', 15)
    BHelper.macros:create('Темная власть', '#showtooltip\n/bh c\n/cast Темная власть', 16)
    BHelper.macros:create('Ледяные оковы', '#showtooltip\n/bh c\n/cast Ледяные оковы', 19)
    BHelper.macros:create('Войско мертвых',
                          '#showtooltip\n/bh sv army_of_the_dead_timeout false\n/bh c\n/cast Войско мертвых',
                          21)
    BHelper.macros:create('Усиление рунического оружия',
                          '#showtooltip\n/bh c\n/cast Усиление рунического оружия', 22)
    BHelper.macros:create('Смерть и разложение',
                          '#showtooltip\n/bh c\n/cast Смерть и разложение', 2)
end

function BHelper.modules.deathknight.default:update()
    if (BHelper.player:can_cast('Рунический удар')) then
        BHelper.keybinds:show_attack('Рунический удар')
    end

    if ((BHelper.player:get_health_on_percent() < 20) and (BHelper.player:get_power() >= 40) and
        ((BHelper.player:can_cast('Воскрешение мертвых')) or
            (BHelper.player:can_cast('Смертельный союз')))) then
        return BHelper.keybinds:show_macro('Смертельный союз')
    end

    if ((BHelper.player:get_health_on_percent() < 20) and (BHelper.player:can_cast('Кровь вампира'))) then
        return BHelper.keybinds:show_spell('Кровь вампира')
    end

    if ((BHelper.player:get_health_on_percent() < 40) and (BHelper.player:can_cast('Захват рун'))) then
        return BHelper.keybinds:show_spell('Захват рун')
    end

    if (BHelper.player:get_spell_cooldown('Войско мертвых') > 10) then
        self.vars.army_of_the_dead_timeout = true
    end
    if (not self.vars.army_of_the_dead_timeout) then
        if (BHelper.player:can_cast('Войско мертвых')) then
            return BHelper.keybinds:show_spell('Войско мертвых')
        else
            return true
        end
    end

    if ((BHelper.target:check_cast()) and (self.vars.silence) and
        (BHelper.player:can_cast_on_enemy('Заморозка разума'))) then
        return BHelper.keybinds:show_spell('Заморозка разума')
    end

    if ((BHelper.player:get_buff_time('Власть льда') == 0) and
        (BHelper.player:can_cast('Власть льда'))) then
        return BHelper.keybinds:show_spell('Власть льда')
    end

    if ((BHelper.player:get_buff_time('Зимний горн') == 0) and
        (BHelper.player:get_buff_time('Сила земли') == 0) and
        (BHelper.player:can_cast('Зимний горн'))) then
        return BHelper.keybinds:show_spell('Зимний горн')
    end

    if ((BHelper.player:check_low_threat()) and (BHelper.player:can_cast('Кровоотвод'))) then
        return BHelper.keybinds:show_spell('Кровоотвод')
    end
end

function BHelper.modules.deathknight.default:rotation_single()
    if ((BHelper.target:get_name() == 'Волдырный зомби') and
        (BHelper.target:get_debuff_time('Ледяные оковы') == 0) and
        (BHelper.player:can_cast_on_enemy('Ледяные оковы'))) then
        return BHelper.keybinds:show_spell('Ледяные оковы')
    end

    if (((BHelper.player:check_low_threat()) or (self.vars.opener) or
        (BHelper.target:get_debuff_time('Озноб', true) < 3)) and
        (BHelper.player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return BHelper.keybinds:show_spell('Ледяное прикосновение')
    end

    if (((BHelper.player:check_low_threat()) or (self.vars.opener)) and (BHelper.target:is_boss()) and
        (BHelper.player:get_spell_cooldown('Ледяное прикосновение') > 3) and
        (BHelper.player:can_cast('Усиление рунического оружия'))) then
        return BHelper.keybinds:show_spell('Усиление рунического оружия')
    end

    if ((BHelper.target:get_debuff_time('Кровавая чума', true) < 3) and
        (BHelper.player:can_cast_on_enemy('Удар чумы'))) then
        return BHelper.keybinds:show_spell('Удар чумы')
    end

    if (((BHelper.player:get_buff_time('Клинковая ограда') == 0) or (self:check_blood_rune_cooldown())) and
        (BHelper.player:can_cast_on_enemy('Кровавый удар'))) then
        return BHelper.keybinds:show_spell('Кровавый удар')
    end

    if ((not BHelper.player:check_low_threat()) and (BHelper.player:can_cast_on_enemy('Удар смерти'))) then
        return BHelper.keybinds:show_spell('Удар смерти')
    end

    if ((BHelper.player:get_power() == 100) and (BHelper.player:can_cast_on_enemy('Лик смерти'))) then
        return BHelper.keybinds:show_spell('Лик смерти')
    end
end

function BHelper.modules.deathknight.default:rotation_multiple()
    if (((BHelper.player:check_low_threat()) or (BHelper.target:get_debuff_time('Озноб', true) < 3)) and
        (BHelper.player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return BHelper.keybinds:show_spell('Ледяное прикосновение')
    end

    if ((BHelper.target:get_debuff_time('Кровавая чума', true) < 3) and
        (BHelper.player:can_cast_on_enemy('Удар чумы'))) then
        return BHelper.keybinds:show_spell('Удар чумы')
    end

    if (((BHelper.target:get_debuff_time('Озноб', true) > 0) or
        (BHelper.target:get_debuff_time('Кровавая чума', true) > 0)) and (not self.vars.pestilence_timeout) and
        (BHelper.player:can_cast_on_enemy('Мор'))) then return BHelper.keybinds:show_spell('Мор') end

    if ((BHelper.target:get_debuff_time('Озноб', true) > 0) and
        (BHelper.target:get_debuff_time('Кровавая чума', true) > 0) and
        (BHelper.player:can_cast('Вскипание крови'))) then
        return BHelper.keybinds:show_spell('Вскипание крови')
    end

    if ((not BHelper.player:check_low_threat()) and (BHelper.player:can_cast_on_enemy('Удар смерти'))) then
        return BHelper.keybinds:show_spell('Удар смерти')
    end

    if ((BHelper.player:get_power() == 100) and (BHelper.player:can_cast_on_enemy('Лик смерти'))) then
        return BHelper.keybinds:show_spell('Лик смерти')
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
    BHelper.timers:create(20, function()
        self.vars.opener = false
    end, 'opener')
end

function BHelper.modules.deathknight.fdk:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.attack_type == nil) then self.vars.attack_type = '1' end
    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Власть крови')
    BHelper.keybinds:bind_spell('Кровоотвод')
    BHelper.keybinds:bind_spell('Зимний горн')
    BHelper.keybinds:bind_spell('Заморозка разума')
    BHelper.keybinds:bind_spell('Удушение')
    BHelper.keybinds:bind_spell('Несокрушимая броня')

    BHelper.keybinds:bind_spell('Ледяные оковы')
    BHelper.keybinds:bind_spell('Рунический удар')
    BHelper.keybinds:bind_spell('Ледяное прикосновение')
    BHelper.keybinds:bind_spell('Удар чумы')
    BHelper.keybinds:bind_spell('Ледяной удар')
    BHelper.keybinds:bind_spell('Кровавый удар')
    BHelper.keybinds:bind_spell('Уничтожение')
    BHelper.keybinds:bind_spell('Воющий ветер')
    BHelper.keybinds:bind_spell('Мор')
    BHelper.keybinds:bind_spell('Вскипание крови')

    BHelper.keybinds:bind_spell('Воскрешение мертвых')
    BHelper.keybinds:bind_spell('Войско мертвых')
    BHelper.keybinds:bind_spell('Усиление рунического оружия')

    BHelper.keybinds:bind_macro('КровоотводClear')

    BHelper.keybinds:bind_item('Знак превосходства')

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
    self:register_event('PLAYER_TARGET_CHANGED')

    BHelper.core.action:set('rotation')
end

function BHelper.modules.deathknight.fdk:macros()
    BHelper.macros:create('Заморозка разумаTV',
                          '#showtooltip Заморозка разума\n/bh tv silence', 41)

    BHelper.macros:create('Кровоотвод',
                          '#showtooltip\n/bh c\n/cancelaura Кровоотвод\n/cast Кровоотвод', 7)
    BHelper.macros:create('Несокрушимая броня',
                          '#showtooltip\n/bh c\n/cast Несокрушимая броня', 8)
    BHelper.macros:create('Воскрешение мертвых',
                          '#showtooltip\n/bh c\n/cast Воскрешение мертвых', 9)
    BHelper.macros:create('Усиление рунического оружия',
                          '#showtooltip\n/bh c\n/cast Усиление рунического оружия', 10)
    BHelper.macros:create('Незыблемость льда',
                          '#showtooltip\n/bh c\n/cast Незыблемость льда', 11)
    BHelper.macros:create('Антимагический панцирь',
                          '#showtooltip\n/bh c\n/cancelaura Антимагический панцирь\n/cast Антимагический панцирь',
                          12)
    BHelper.macros:create('Хватка смерти', '#showtooltip\n/bh c\n/cast Хватка смерти', 15)
    BHelper.macros:create('Темная власть', '#showtooltip\n/bh c\n/cast Темная власть', 16)
    BHelper.macros:create('Ледяные оковы', '#showtooltip\n/bh c\n/cast Ледяные оковы', 19)
    BHelper.macros:create('Воющий ветер', '#showtooltip\n/bh c\n/cast Воющий ветер', 20)
    BHelper.macros:create('Войско мертвых',
                          '#showtooltip\n/bh sv army_of_the_dead_timeout false\n/bh c\n/cast Войско мертвых',
                          21)

    BHelper.macros:create('Смерть и разложение',
                          '#showtooltip\n/bh c\n/cast Смерть и разложение', 2)

    BHelper.macros:create('S', '/startattack\n/bh sv attack_type 1\n/bh', 13, 1263)
    BHelper.macros:create('M', '/startattack\n/bh sv attack_type 2\n/bh', 14, 1264)
end

function BHelper.modules.deathknight.fdk:rotation()
    local ready_rune_count = self:get_ready_rune_count()
    local blood_rune_cooldown = self:check_blood_rune_cooldown()
    local frost_fever_time = BHelper.target:get_debuff_time('Озноб', true)
    local blood_plague_time = BHelper.target:get_debuff_time('Кровавая чума', true)

    if (BHelper.player:can_cast('Рунический удар')) then
        BHelper.keybinds:show_attack('Рунический удар')
    end

    if (BHelper.player:get_spell_cooldown('Войско мертвых') > 10) then
        self.vars.army_of_the_dead_timeout = true
    end
    if (not self.vars.army_of_the_dead_timeout) then
        if (BHelper.player:can_cast('Войско мертвых')) then
            return BHelper.keybinds:show_spell('Войско мертвых')
        else
            return true
        end
    end

    if ((BHelper.target:check_cast()) and (self.vars.silence) and
        (BHelper.player:can_cast_on_enemy('Заморозка разума'))) then
        return BHelper.keybinds:show_spell('Заморозка разума')
    end

    if ((BHelper.player:get_buff_time('Власть крови') == 0) and
        (BHelper.player:can_cast('Власть крови'))) then
        return BHelper.keybinds:show_spell('Власть крови')
    end

    if ((BHelper.player:get_buff_time('Зимний горн') == 0) and
        (BHelper.player:get_buff_time('Сила земли') == 0) and
        (BHelper.player:can_cast('Зимний горн'))) then
        return BHelper.keybinds:show_spell('Зимний горн')
    end

    if ((BHelper.player:check_burst_mode()) and (not BHelper.vars.cooldown_berserker)) then
        if (BHelper.player:can_cast('Воскрешение мертвых')) then
            return BHelper.keybinds:show_spell('Воскрешение мертвых')
        end

        if ((BHelper.player:check_equipped_item('Знак превосходства')) and
            (BHelper.player:can_use_item('Знак превосходства'))) then
            return BHelper.keybinds:show_item('Знак превосходства')
        end

        if ((self:check_rune_cooldown()) and (BHelper.player:get_buff_time('Кровоотвод', true) > 0)) then
            return BHelper.keybinds:show_macro('Кровоотвод')
        end

        if ((self:check_rune_cooldown()) and
            (BHelper.player:can_cast('Усиление рунического оружия'))) then
            return BHelper.keybinds:show_spell('Усиление рунического оружия')
        end

        if ((BHelper.player:can_cast('Кровоотвод'))) then
            return BHelper.keybinds:show_spell('Кровоотвод')
        end

        if ((BHelper.player:can_cast('Несокрушимая броня'))) then
            return BHelper.keybinds:show_spell('Несокрушимая броня')
        end
    end

    if ((frost_fever_time > 0) and (blood_plague_time > 0)) then
        if ((frost_fever_time < 3) or (blood_plague_time < 3)) then
            if (BHelper.player:can_cast_on_enemy('Мор')) then return BHelper.keybinds:show_spell('Мор') end
            return true
        end

        if ((self.vars.attack_type == '2') and (math.ceil(frost_fever_time) ~= math.ceil(blood_plague_time)) and
            (BHelper.player:can_cast_on_enemy('Мор'))) then return BHelper.keybinds:show_spell('Мор') end
    end

    if ((self.vars.attack_type == '2') and (BHelper.player:check_spell_range('Ледяной удар')) and
        (BHelper.player:can_cast('Воющий ветер'))) then
        return BHelper.keybinds:show_spell('Воющий ветер')
    end

    if ((self.vars.attack_type == '1') and
        (BHelper.player:get_buff_time('Машина для убийств', true) > 0) and
        (BHelper.player:can_cast('Ледяной удар'))) then
        return BHelper.keybinds:show_spell('Ледяной удар')
    end

    if ((self.vars.attack_type == '2') and (frost_fever_time > blood_rune_cooldown) and
        (blood_plague_time > blood_rune_cooldown) and (BHelper.player:can_cast('Вскипание крови'))) then
        return BHelper.keybinds:show_spell('Вскипание крови')
    end

    if ((self.vars.attack_type == '2') and (frost_fever_time > 0) and (blood_plague_time > 0) and
        (BHelper.player:get_buff_time('Машина для убийств', true) > 0) and
        (BHelper.player:can_cast('Ледяной удар'))) then
        return BHelper.keybinds:show_spell('Ледяной удар')
    end

    if ((frost_fever_time == 0) and (BHelper.player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return BHelper.keybinds:show_spell('Ледяное прикосновение')
    end

    if ((blood_plague_time == 0) and (BHelper.player:can_cast_on_enemy('Удар чумы'))) then
        return BHelper.keybinds:show_spell('Удар чумы')
    end

    if ((ready_rune_count[2] >= 1) and (ready_rune_count[3] >= 1) and
        (BHelper.player:can_cast_on_enemy('Уничтожение'))) then
        return BHelper.keybinds:show_spell('Уничтожение')
    end

    if (((ready_rune_count[2] >= 1) or (ready_rune_count[3] >= 1)) and (ready_rune_count[4] >= 1) and
        (frost_fever_time > blood_rune_cooldown) and (blood_plague_time > blood_rune_cooldown) and
        (BHelper.player:can_cast_on_enemy('Уничтожение'))) then
        return BHelper.keybinds:show_spell('Уничтожение')
    end

    if ((ready_rune_count[2] == 0) and (ready_rune_count[3] == 0) and (ready_rune_count[4] == 2) and
        (frost_fever_time > 10.5) and (blood_plague_time > 10.5) and
        (BHelper.player:can_cast_on_enemy('Уничтожение'))) then
        return BHelper.keybinds:show_spell('Уничтожение')
    end

    if ((self.vars.attack_type == '1') and (frost_fever_time > blood_rune_cooldown) and
        (blood_plague_time > blood_rune_cooldown) and (BHelper.player:can_cast_on_enemy('Кровавый удар'))) then
        return BHelper.keybinds:show_spell('Кровавый удар')
    end

    if ((BHelper.player:can_cast_on_enemy('Ледяной удар'))) then
        return BHelper.keybinds:show_spell('Ледяной удар')
    end

    if ((BHelper.player:get_buff_time('Морозная дымка', true) > 0) and
        (BHelper.player:check_spell_range('Ледяной удар')) and
        (BHelper.player:can_cast('Воющий ветер'))) then
        return BHelper.keybinds:show_spell('Воющий ветер')
    end

    if (BHelper.player:can_cast('Зимний горн')) then
        return BHelper.keybinds:show_spell('Зимний горн')
    end
end

function BHelper.modules.deathknight.fdk:get_ready_rune_count()
    local ready_rune_count = {0, 0, 0, 0}
    for i = 1, 6 do
        if (select(3, GetRuneCooldown(i))) then
            ready_rune_count[GetRuneType(i)] = ready_rune_count[GetRuneType(i)] + 1
        end
    end
    return ready_rune_count
end

function BHelper.modules.deathknight.fdk:check_blood_rune_cooldown()
    local cooldowns = {}
    for i = 1, 2 do
        local start, duration = GetRuneCooldown(i)
        local cooldown = start + duration - GetTime() + 0.5
        cooldowns[i] = (cooldown > 0) and cooldown or 0
    end
    return (cooldowns[1] > 0) and cooldowns[1] or cooldowns[2]
end

function BHelper.modules.deathknight.fdk:check_rune_cooldown()
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
