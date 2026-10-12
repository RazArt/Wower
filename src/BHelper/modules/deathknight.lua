function BHelper.modules.deathknight.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Кровь вампира')
    BHelper.keybinds:bind_spell('Кровоотвод')
    BHelper.keybinds:bind_spell('Захват рун')
    BHelper.keybinds:bind_macro('Смертельный союз')
    BHelper.keybinds:bind_spell('Зимний горн')
    BHelper.keybinds:bind_spell('Рунический удар')
    BHelper.keybinds:bind_spell('Заморозка разума')
    BHelper.keybinds:bind_spell('Удушение')
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
                          '#showtooltip\n/bh c\n/cast Антимагический панцирь', 8)
    BHelper.macros:create('Кровь вампира', '#showtooltip\n/bh c\n/cast Кровь вампира', 9)
    BHelper.macros:create('Захват рун', '#showtooltip\n/bh c\n/cast Захват рун', 10)
    BHelper.macros:create('Кровоотвод', '#showtooltip\n/bh c\n/cast Кровоотвод', 11)
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
    if ((self.vars.death_strike_timeout) and (self:death_rune_count() == 0)) then
        self.vars.death_strike_timeout = false
    elseif ((not self.vars.death_strike_timeout) and (self:death_rune_count() >= 3)) then
        self.vars.death_strike_timeout = true
    end

    if (BHelper.player:can_cast('Рунический удар')) then
        BHelper.keybinds:show_attack('Рунический удар')
    end

    if ((BHelper.player:get_health_on_percent() < 20) and
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

    if ((BHelper.player:get_buff_time('Зимний горн') == 0) and
        (BHelper.player:get_buff_time('Тотем силы земли') == 0) and
        (BHelper.player:can_cast('Зимний горн'))) then
        return BHelper.keybinds:show_spell('Зимний горн')
    end

    if (BHelper.target:check_cast() and (self.vars.silence) and
        BHelper.player:can_cast_on_enemy('Заморозка разума')) then
        return BHelper.keybinds:show_spell('Заморозка разума')
    end

    if ((BHelper.player:can_cast('Кровоотвод'))) then
        return BHelper.keybinds:show_spell('Кровоотвод')
    end
end

function BHelper.modules.deathknight.default:rotation_single()
    if (self.vars.opener) then
        if ((BHelper.player:can_cast_on_enemy('Ледяное прикосновение'))) then
            return BHelper.keybinds:show_spell('Ледяное прикосновение')
        end

        if ((BHelper.target:is_boss()) and
            (BHelper.player:get_spell_cooldown('Ледяное прикосновение') > 3) and
            (BHelper.player:can_cast('Усиление рунического оружия'))) then
            return BHelper.keybinds:show_spell('Усиление рунического оружия')
        end
    end

    if (((BHelper.player:check_low_threat()) or (BHelper.target:get_debuff_time('Озноб', true) < 3)) and
        (BHelper.player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return BHelper.keybinds:show_spell('Ледяное прикосновение')
    end

    if ((BHelper.target:get_debuff_time('Кровавая чума', true) < 3) and
        (BHelper.player:can_cast_on_enemy('Удар чумы'))) then
        return BHelper.keybinds:show_spell('Удар чумы')
    end

    if ((((BHelper.player:get_health_on_percent() < 60)) or (not self.vars.death_strike_timeout)) and
        (BHelper.player:can_cast_on_enemy('Удар смерти'))) then
        return BHelper.keybinds:show_spell('Удар смерти')
    end

    if ((BHelper.player:can_cast_on_enemy('Ледяное прикосновение'))) then
        return BHelper.keybinds:show_spell('Ледяное прикосновение')
    end

    if (((BHelper.player:get_buff_time('Клинковая ограда') == 0) or (self:check_blood_rune_cooldown())) and
        (BHelper.player:can_cast_on_enemy('Кровавый удар'))) then
        return BHelper.keybinds:show_spell('Кровавый удар')
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

    if ((((BHelper.player:get_health_on_percent() < 60)) or (self:death_rune_count() < 3)) and
        (BHelper.player:can_cast_on_enemy('Удар смерти'))) then
        return BHelper.keybinds:show_spell('Удар смерти')
    end

    if ((BHelper.player:get_power() == 100) and (BHelper.player:can_cast_on_enemy('Лик смерти'))) then
        return BHelper.keybinds:show_spell('Лик смерти')
    end
end

function BHelper.modules.deathknight.default:death_rune_count()
    local count = 0
    if (GetRuneType(3) == 4) then count = count + 1 end
    if (GetRuneType(4) == 4) then count = count + 1 end
    if (GetRuneType(5) == 4) then count = count + 1 end
    if (GetRuneType(6) == 4) then count = count + 1 end
    return count
end

function BHelper.modules.deathknight.default:check_blood_rune_cooldown()
    local _, _, runeReady_1 = GetRuneCooldown(1)
    local _, _, runeReady_2 = GetRuneCooldown(2)
    if ((runeReady_1 == true) and (runeReady_2 == true)) then return true end
    return false
end

function BHelper.modules.deathknight.default:PLAYER_TARGET_CHANGED()
    self:start()
end

function BHelper.modules.deathknight.default:UNIT_SPELLCAST_SUCCEEDED(castGUID, spellName)
    if (spellName == 'Удар чумы') then self.vars.pestilence_timeout = false end
    if (spellName == 'Мор') then self.vars.pestilence_timeout = true end

    if (spellName == 'Войско мертвых') then self.vars.army_of_the_dead_timeout = true end
end

function BHelper.modules.deathknight.default:start()
    self.vars.opener = true
    self.vars.army_of_the_dead_timeout = true
    self.vars.pestilence_timeout = true
    self.vars.death_strike_timeout = true

    BHelper.timers:create(10, function()
        self.vars.opener = false
    end, 'opener')
end
