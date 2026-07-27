function BHelper.modules.warrior:init()
    self.vars.attack_type = 1
    self.vars.battle_shout = false
    self.vars.commanding_shout = false
    self.vars.sunder = false

    self:set_route('rotation_1')
end

function BHelper.modules.warrior:rotation_1()
    if (InCombatLockdown() ~= 1) then return end

    if (self.vars.attack_type == 1) then
        if (self.parent:can_cast('Удар героя')) then
            Keystroke:show_attack(2, false, false, true)
        end
    elseif (self.vars.attack_type == 2) then
        if (self.parent:can_cast('Рассекающий удар')) then
            Keystroke:show_attack(3, false, false, true)
        end
    end

    if ((self.parent:get_health_on_percent() < 30) and
        self.parent:can_cast('Безудержное восстановление')) then
        Keystroke:show_spell(62)
    end

    if ((self.parent:get_player_buff_time('Боевой крик') == 0) and
        (self.parent:can_cast('Боевой крик')) and (self.vars.battle_shout)) then
        Keystroke:show_spell(6, false, false, false, true)
        return
    end

    if ((self.parent:get_player_buff_time('Командирский крик') == 0) and
        (self.parent:can_cast('Командирский крик')) and (self.vars.commanding_shout)) then
        Keystroke:show_spell(7, false, false, false, true)
        return
    end

    if (self.parent:is_enemy_cast() and self.parent:can_cast_on_enemy('Зуботычина')) then
        Keystroke:show_spell(34)
        return
    end

    if (self.parent:can_cast('Ярость берсерка')) then
        Keystroke:show_spell(9)
        return
    end

    if ((self.parent:get_power() <= 30) and (self.parent:can_cast('Кровавая ярость'))) then
        Keystroke:show_spell(8)
        return
    end

    if (((self.parent:get_ememy_debuff_time('Раскол брони') <= 3) or
        (self.parent:get_ememy_debuff_count('Раскол брони') < 5)) and
        (self.parent:can_cast_on_enemy('Раскол брони')) and (self.vars.sunder)) then
        Keystroke:show_spell(33)
        return
    end

    if (self.parent:can_cast_on_enemy('Кровожадность')) then
        Keystroke:show_spell(3)
        return
    end

    if ((self.parent:get_player_buff_time('Сокрушить!') > 0) and
        (self.parent:can_cast_on_enemy('Мощный удар'))) then
        Keystroke:show_spell(4)
        return
    end

    if (self.parent:can_cast('Вихрь')) then
        Keystroke:show_spell(2)
        return
    end

    if (self.parent:can_cast_on_enemy('Казнь')) then
        Keystroke:show_spell(5)
        return
    end
end
