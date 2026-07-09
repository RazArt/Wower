function HelloWorld.war.hunter:init()
    self.vars.mana_regeneration = false
    self:set_step(HelloWorld:get_player_spec())
end

function HelloWorld.war.hunter:step_1()
    self.parent:general_update()

    if ((self.parent:get_mana_on_percent('player') < 20) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((self.parent:get_mana_on_percent('player') > 60) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (self.parent:get_player_buff_time('Дух дракондора') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух дракондора'))) then
        HelloWorld:show(10)
    else
        HelloWorld:hide(10)
    end

    if ((self.vars.mana_regeneration == true) and
        (self.parent:get_player_buff_time('Дух гадюки') == 0) and
        (self.parent:get_player_buff_time('Дух дикой природы') == 0) and
        (self.parent:can_cast('Дух гадюки'))) then
        HelloWorld:show(11)
    else
        HelloWorld:hide(11)
    end

    if ((self.parent:get_player_buff_time('Аура меткого выстрела') == 0) and
        (self.parent:can_cast('Аура меткого выстрела'))) then
        HelloWorld:show(12)
    else
        HelloWorld:hide(12)
    end

    if (self.parent:is_enemy_cast() and
        self.parent:can_cast_on_enemy('Глушащий выстрел')) then
        HelloWorld:show(13)
    else
        HelloWorld:hide(13)
    end

    if ((self.parent:get_ememy_debuff_time('Метка охотника') == 0) and
        (self.parent:can_cast_on_enemy('Метка охотника')) and (IsShiftKeyDown() ~= 1)) then
        HelloWorld:show(14)
    else
        HelloWorld:hide(14)
    end

    if ((self.vars.mana_regeneration == false) and
        (self.parent:get_ememy_debuff_time('Укус змеи', true) == 0) and
        (self.parent:can_cast_on_enemy('Укус змеи'))) then
        HelloWorld:show(15)
    else
        HelloWorld:hide(15)
    end

    if ((self.vars.mana_regeneration == true) and
        (self.parent:get_ememy_debuff_time('Укус гадюки', true) == 0) and
        (self.parent:can_cast_on_enemy('Укус гадюки'))) then
        HelloWorld:show(16)
    else
        HelloWorld:hide(16)
    end

    if (self.parent:can_cast_on_enemy('Убийственный выстрел')) then
        HelloWorld:show(17)
    else
        HelloWorld:hide(17)
    end

    if (self.parent:can_cast_on_enemy('Выстрел химеры')) then
        HelloWorld:show(18)
    else
        HelloWorld:hide(18)
    end

    if (self.parent:can_cast_on_enemy('Прицельный выстрел')) then
        HelloWorld:show(19)
    else
        HelloWorld:hide(19)
    end

    if (self.parent:can_cast_on_enemy('Чародейский выстрел')) then
        HelloWorld:show(20)
    else
        HelloWorld:hide(20)
    end

    if (self.parent:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        HelloWorld:show(21)
    else
        HelloWorld:hide(21)
    end

    if (self.parent:can_cast_on_enemy('Верный выстрел')) then
        HelloWorld:show(22)
    else
        HelloWorld:hide(22)
    end

    if (self.parent:can_cast_on_point('Град стрел')) then
        HelloWorld:show(23)
    else
        HelloWorld:hide(23)
    end
    -- /cast [@target,help,nodead][@focus,help,nodead][@targettarget,help,nodead] Маленькие хитрости
end
