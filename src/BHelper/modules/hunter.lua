function BHelper.modules.hunter.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true
    self.settings.auto_combat_start = true

    if (self.vars.mana_regeneration == nil) then self.vars.mana_regeneration = false end
    if (self.vars.misdirection == nil) then self.vars.misdirection = true end
    if (self.vars.pet_control == nil) then self.vars.pet_control = true end

    BHelper.keybinds:bind_spell('Дух дракондора')
    BHelper.keybinds:bind_spell('Дух гадюки')
    BHelper.keybinds:bind_spell('Глушащий выстрел')
    BHelper.keybinds:bind_spell('Усмиряющий выстрел')
    BHelper.keybinds:bind_spell('Метка охотника')
    BHelper.keybinds:bind_spell('Укус змеи')
    BHelper.keybinds:bind_spell('Укус гадюки')
    BHelper.keybinds:bind_spell('Убийственный выстрел')
    BHelper.keybinds:bind_spell('Бросок ловушки: взрывная ловушка')
    BHelper.keybinds:bind_spell('Град стрел')
    BHelper.keybinds:bind_spell('Выстрел химеры')
    BHelper.keybinds:bind_spell('Прицельный выстрел')
    BHelper.keybinds:bind_spell('Верный выстрел')
    BHelper.keybinds:bind_spell('Залп')
    BHelper.keybinds:bind_spell('Команда "Взять!"')
    BHelper.keybinds:bind_spell('Быстрая стрельба')
    BHelper.keybinds:bind_spell('Зов дикой природы')
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')
    BHelper.keybinds:bind_spell('Готовность')
    BHelper.keybinds:bind_item('Тень Лотхиба')
    BHelper.keybinds:bind_macro('Перенаправление')
end

function BHelper.modules.hunter.default:macros()
    BHelper.macros:create('Отрыв', '#showtooltip\n/bh c\n/stopcasting\n/cast Отрыв', 1)
    BHelper.macros:create('Дух дикой природы',
                          '#showtooltip Дух дикой природы\n/bh c\n/stopcasting\n/cast Дух дикой природы',
                          21)
    BHelper.macros:create('Ледяная ловушка',
                          '#showtooltip Ледяная ловушка\n/bh c\n/stopcasting\n/cast Ледяная ловушка',
                          22)
    BHelper.macros:create('Метка охотникаTV',
                          '#showtooltip Метка охотника\n/bh tv mark', 39)
    BHelper.macros:create('ПеренаправлениеTV',
                          '#showtooltip Перенаправление\n/bh tv misdirection', 40)
    BHelper.macros:create('PetControlTV', '/bh tv pet_control', 41, 453)
    BHelper.macros:create('Быстрая стрельба',
                          '#showtooltip Быстрая стрельба\n/bh c\n/use Тень Лотхиба\n/stopcasting\n/cast Быстрая стрельба\n/cast Зов дикой природы',
                          9)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip Берсерк(Расовая)\n/bh c\n/cast Берсерк(Расовая)',
                          10)
    BHelper.macros:create('Готовность',
                          '#showtooltip Готовность\n/bh c\n/stopcasting\n/cast Готовность',
                          11)
    BHelper.macros:create('Притвориться мертвым',
                          '#showtooltip Притвориться мертвым\n/bh stop\n/stopcasting\n/cast Притвориться мертвым',
                          12)
    BHelper.macros:create('Сдерживание',
                          '#showtooltip Сдерживание\n/bh stop\n/stopcasting\n/cast Сдерживание',
                          24)
    BHelper.macros:create('Перенаправление',
                          '#showtooltip Перенаправление\n/stopcasting\n/bh c\n/cast [@focus,help,nodead] Перенаправление\n/cast [@target,help,nodead] Перенаправление\n/cast [@targettarget,help,nodead] Перенаправление',
                          15)
    BHelper.macros:create('Глушащий выстрел',
                          '#showtooltip\n/bh c\n/stopcasting\n/cast Глушащий выстрел',
                          17)
    BHelper.macros:create('Усмиряющий выстрел',
                          '#showtooltip\n/bh c\n/stopcasting\n/cast Усмиряющий выстрел',
                          18)
end

function BHelper.modules.hunter.default:update()
    if ((BHelper.player:get_mana() < 300)) then
        self.vars.mana_regeneration = true
    elseif ((BHelper.player:get_mana() > 3000)) then
        self.vars.mana_regeneration = false
    end

    if ((not self.vars.mana_regeneration) and
        (BHelper.player:get_buff_time('Дух дракондора') == 0) and
        (BHelper.player:get_buff_time('Дух дикой природы') == 0) and
        (BHelper.player:can_cast('Дух дракондора'))) then
        return BHelper.keybinds:show_spell('Дух дракондора')
    end

    if ((self.vars.mana_regeneration) and (BHelper.player:get_buff_time('Дух гадюки') == 0) and
        (BHelper.player:get_buff_time('Дух дикой природы') == 0) and
        (BHelper.player:can_cast('Дух гадюки'))) then
        return BHelper.keybinds:show_spell('Дух гадюки')
    end

    if (BHelper.player:can_cast_on_enemy('Глушащий выстрел')) then
        return BHelper.keybinds:show_attack('Глушащий выстрел')
    end

    if ((BHelper.target:get_buff_time('Исступление') > 0) and
        BHelper.player:can_cast_on_enemy('Усмиряющий выстрел')) then
        return BHelper.keybinds:show_spell('Усмиряющий выстрел')
    end

    if ((BHelper.target:get_debuff_time('Метка охотника') == 0) and
        (BHelper.player:get_buff_time('Перенаправление') == 0) and
        (BHelper.target:is_boss()) and
        (BHelper.player:can_cast_on_enemy('Метка охотника'))) then
        return BHelper.keybinds:show_spell('Метка охотника')
    end

    if (BHelper.player:can_cast('Команда "Взять!"')) then
        return BHelper.keybinds:show_help('Команда "Взять!"')
    end

    -- if ((BHelper.player:help_focus_exist()) and (self.vars.misdirection) and
    --     (BHelper.player:can_cast('Перенаправление'))) then
    --     return BHelper.keybinds:show_macro('Перенаправление')
    -- end
end

function BHelper.modules.hunter.default:rotation_single()
    if (not self.vars.mana_regeneration) then
        if ((BHelper.player:can_cast_on_enemy('Убийственный выстрел'))) then
            return BHelper.keybinds:show_spell('Убийственный выстрел')
        end

        if (BHelper.player:check_burst_mode()) then
            if ((BHelper.player:check_equipped_item('Тень Лотхиба')) and
                (BHelper.player:can_use_item('Тень Лотхиба'))) then
                return BHelper.keybinds:show_item('Тень Лотхиба')
            end

            if ((BHelper.player:get_buff_time('Зов дикой природы') == 0) and
                (BHelper.player:can_cast('Зов дикой природы'))) then
                return BHelper.keybinds:show_spell('Зов дикой природы')
            end

            if ((BHelper.player:get_buff_time('Быстрая стрельба') == 0) and
                (BHelper.player:get_buff_time(26297) == 0) and
                (not BHelper.player:check_heroism_buff()) and (not BHelper.vars.cooldown_berserker) and
                (BHelper.player:can_cast('Быстрая стрельба'))) then
                return BHelper.keybinds:show_spell('Быстрая стрельба')
            end

            if ((BHelper.player:get_buff_time('Быстрая стрельба') == 0) and
                (BHelper.player:get_buff_time(26297) == 0) and
                (not BHelper.player:check_heroism_buff()) and (not BHelper.vars.cooldown_berserker) and
                (BHelper.player:can_cast('Берсерк(Расовая)'))) then
                return BHelper.keybinds:show_spell('Берсерк(Расовая)')
            end

            if ((BHelper.player:get_spell_cooldown('Быстрая стрельба') > 60) and
                (BHelper.player:can_cast('Готовность'))) then
                return BHelper.keybinds:show_spell('Готовность')
            end
        end

        if ((BHelper.target:get_debuff_time('Укус змеи', true) == 0) and
            (BHelper.target:get_debuff_time('Укус гадюки', true) == 0) and
            (BHelper.player:can_cast_on_enemy('Укус змеи'))) then
            return BHelper.keybinds:show_spell('Укус змеи')
        end

        if ((not BHelper.player:can_cast_on_enemy('Убийственный выстрел', 1)) and
            (not BHelper.player:check_moving()) and
            BHelper.player:can_cast_on_point(
                'Бросок ловушки: взрывная ловушка')) then
            return BHelper.keybinds:show_spell(
                       'Бросок ловушки: взрывная ловушка')
        end

        if ((not BHelper.player:can_cast_on_enemy('Убийственный выстрел', 1)) and
            BHelper.player:can_cast_on_enemy('Выстрел химеры')) then
            return BHelper.keybinds:show_spell('Выстрел химеры')
        end

        if ((not BHelper.player:can_cast_on_enemy('Убийственный выстрел', 1)) and
            (not BHelper.player:can_cast_on_enemy('Выстрел химеры', 1)) and
            BHelper.player:can_cast_on_enemy('Прицельный выстрел')) then
            return BHelper.keybinds:show_spell('Прицельный выстрел')
        end

        if ((not BHelper.player:can_cast_on_enemy('Убийственный выстрел', 1)) and
            (not BHelper.player:can_cast_on_enemy('Выстрел химеры', 1)) and
            (not BHelper.player:can_cast_on_enemy('Прицельный выстрел', 1)) and
            (not BHelper.player:check_moving()) and
            BHelper.player:can_cast_on_enemy('Верный выстрел')) then
            return BHelper.keybinds:show_spell('Верный выстрел')
        end
    else
        if ((BHelper.target:get_mana_max() > 1) and
            (BHelper.target:get_debuff_time('Укус гадюки', true) == 0) and
            (BHelper.player:can_cast_on_enemy('Укус гадюки'))) then
            return BHelper.keybinds:show_spell('Укус гадюки')
        end

        if ((not BHelper.player:check_moving()) and
            BHelper.player:can_cast_on_enemy('Верный выстрел')) then
            return BHelper.keybinds:show_spell('Верный выстрел')
        end
    end
end

function BHelper.modules.hunter.default:rotation_multiple()
    if (BHelper.player:can_cast_on_enemy('Залп')) then
        return BHelper.keybinds:show_spell('Залп')
    end

    if (BHelper.player:can_cast_on_point(
        'Бросок ловушки: взрывная ловушка') and
        (not BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell(
                   'Бросок ловушки: взрывная ловушка')
    end

    if (BHelper.player:can_cast_on_point('Град стрел') and
        (not BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell('Град стрел')
    end
end
