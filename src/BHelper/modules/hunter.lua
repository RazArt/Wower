function BHelper.modules.hunter.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.mana_regeneration == nil) then self.vars.mana_regeneration = false end
    if (self.vars.manual_mana_regeneration == nil) then self.vars.manual_mana_regeneration = false end
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
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')
    BHelper.keybinds:bind_spell('Готовность')
    BHelper.keybinds:bind_spell('Зов дикой природы')
    BHelper.keybinds:bind_item('Зов берсерка')
    BHelper.keybinds:bind_item('Знак превосходства')
    BHelper.keybinds:bind_macro('Перенаправление')
    BHelper.keybinds:bind_macro('ManaTV', 'BUTTON5')
end

function BHelper.modules.hunter.default:macros()
    BHelper.macros:create('Отрыв', '#showtooltip\n/bh c\n/stopcasting\n/cast Отрыв', 1)

    BHelper.macros:create('PetControlTV', '/bh tv pet_control', 42, 273)
    BHelper.macros:create('ManaTV', '/bh tv manual_mana_regeneration')
    BHelper.macros:create('Быстрая стрельба',
                          '#showtooltip Быстрая стрельба\n/bh c\n/use Зов берсерка\n/cast Зов дикой природы\n/stopcasting\n/cast Быстрая стрельба\n',
                          9)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip Берсерк(Расовая)\n/bh c\n/cast Берсерк(Расовая)', 10)
    BHelper.macros:create('Готовность',
                          '#showtooltip Готовность\n/bh c\n/stopcasting\n/cast Готовность', 11)
    BHelper.macros:create('Притвориться мертвым',
                          '#showtooltip Притвориться мертвым\n/bh stop\n/stopcasting\n/cast Притвориться мертвым',
                          12)
    BHelper.macros:create('Метка охотника',
                          '#showtooltip Метка охотника\n/bh c\n/stopcasting\n/cast Метка охотника',
                          21)
    BHelper.macros:create('Ледяная ловушка',
                          '#showtooltip Ледяная ловушка\n/bh c\n/stopcasting\n/cast Ледяная ловушка',
                          22)
    BHelper.macros:create('Сдерживание',
                          '#showtooltip Сдерживание\n/bh stop\n/stopcasting\n/cancelaura Сдерживание\n/cast Сдерживание',
                          24)
    BHelper.macros:create('Перенаправление',
                          '#showtooltip Перенаправление\n/stopcasting\n/bh c\n/cast [@focus,help,nodead] Перенаправление\n/cast [@target,help,nodead] Перенаправление\n/cast [@targettarget,help,nodead] Перенаправление',
                          15)
    BHelper.macros:create('Глушащий выстрел',
                          '#showtooltip\n/bh c\n/stopcasting\n/cast Глушащий выстрел', 17)
    BHelper.macros:create('Усмиряющий выстрел',
                          '#showtooltip\n/bh c\n/stopcasting\n/cast Усмиряющий выстрел', 18)
end

function BHelper.modules.hunter.default:execute()
    if (BHelper.player:get_mana_on_percent() >= 95) then self.vars.manual_mana_regeneration = false end

    if ((BHelper.player:get_mana() < 500)) then
        self.vars.mana_regeneration = true
    elseif ((BHelper.player:get_mana() > 3000)) then
        self.vars.mana_regeneration = false
    end

    if (((not self.vars.mana_regeneration) and (not self.vars.manual_mana_regeneration)) and
        (BHelper.auras:player('Дух дракондора') == 0) and
        (BHelper.auras:player('Дух дикой природы') == 0) and
        (BHelper.player:can_cast('Дух дракондора'))) then
        return BHelper.keybinds:show_spell('Дух дракондора')
    end

    if (((self.vars.mana_regeneration) or (self.vars.manual_mana_regeneration)) and
        (BHelper.auras:player('Дух гадюки') == 0) and
        (BHelper.auras:player('Дух дикой природы') == 0) and
        (BHelper.player:can_cast('Дух гадюки'))) then
        return BHelper.keybinds:show_spell('Дух гадюки')
    end

    if (BHelper.player:can_cast_on_enemy('Глушащий выстрел')) then
        return BHelper.keybinds:show_attack('Глушащий выстрел')
    end

    if ((BHelper.auras:target('Исступление') > 0) and
        BHelper.player:can_cast_on_enemy('Усмиряющий выстрел')) then
        return BHelper.keybinds:show_spell('Усмиряющий выстрел')
    end

    if (BHelper.player:can_cast('Команда "Взять!"')) then
        return BHelper.keybinds:show_help('Команда "Взять!"')
    end
end

function BHelper.modules.hunter.default:rotation_single()
    if ((not self.vars.mana_regeneration) and (not self.vars.manual_mana_regeneration)) then
        if ((BHelper.player:can_cast_on_enemy('Убийственный выстрел'))) then
            return BHelper.keybinds:show_spell('Убийственный выстрел')
        end

        if ((BHelper.player:check_burst_mode()) and (not BHelper.vars.cooldown_berserker)) then
            if ((BHelper.player:check_equipped_item('Зов берсерка')) and
                (BHelper.player:can_use_item('Зов берсерка'))) then
                return BHelper.keybinds:show_item('Зов берсерка')
            end

            if ((BHelper.player:check_equipped_item('Знак превосходства')) and
                (BHelper.player:can_use_item('Знак превосходства'))) then
                return BHelper.keybinds:show_item('Знак превосходства')
            end

            if ((BHelper.auras:player('Зов дикой природы') == 0) and
                (BHelper.player:can_cast('Зов дикой природы'))) then
                return BHelper.keybinds:show_spell('Зов дикой природы')
            end

            if ((BHelper.auras:player('Быстрая стрельба') == 0) and
                (BHelper.player:can_cast('Быстрая стрельба'))) then
                return BHelper.keybinds:show_spell('Быстрая стрельба')
            end

            if (BHelper.player:can_cast('Берсерк(Расовая)')) then
                return BHelper.keybinds:show_spell('Берсерк(Расовая)')
            end

            if ((BHelper.player:get_spell_cooldown('Быстрая стрельба') > 30) and
                (BHelper.player:get_spell_cooldown('Выстрел химеры') > 2) and
                (BHelper.player:get_spell_cooldown('Прицельный выстрел') > 2) and
                (BHelper.player:get_spell_cooldown('Бросок ловушки: взрывная ловушка') > 2) and
                (BHelper.player:can_cast('Готовность'))) then
                return BHelper.keybinds:show_spell('Готовность')
            end
        end

        if (BHelper.auras:player('Перенаправление') == 0) then
            if ((BHelper.auras:target('Эффект взрывной ловушки', true) == 0) and
                (BHelper.player:can_cast_on_point('Бросок ловушки: взрывная ловушка'))) then
                return BHelper.keybinds:show_spell('Бросок ловушки: взрывная ловушка')
            end

            if ((BHelper.auras:target('Укус змеи', true) == 0) and
                (BHelper.auras:target('Укус гадюки', true) == 0) and
                (BHelper.player:can_cast_on_enemy('Укус змеи'))) then
                return BHelper.keybinds:show_spell('Укус змеи')
            end
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

        local ss_cast_time = BHelper.player:get_spell_casttime('Верный выстрел') - 0.5
        ss_cast_time = (ss_cast_time < 1) and 1 or ss_cast_time

        if ((not BHelper.player:can_cast_on_enemy('Убийственный выстрел', ss_cast_time)) and
            (not BHelper.player:can_cast_on_enemy('Выстрел химеры', ss_cast_time)) and
            (not BHelper.player:can_cast_on_enemy('Прицельный выстрел', ss_cast_time)) and
            (not BHelper.player:check_moving()) and (BHelper.player:can_cast_on_enemy('Верный выстрел'))) then
            return BHelper.keybinds:show_spell('Верный выстрел')
        end
    else
        return self:mana_regeneration()
    end
end

function BHelper.modules.hunter.default:rotation_multiple()
    if ((not self.vars.mana_regeneration) and (not self.vars.manual_mana_regeneration)) then
        if ((BHelper.auras:player('Перенаправление') == 0) and
            (BHelper.player:can_cast_on_enemy('Залп'))) then return BHelper.keybinds:show_spell('Залп') end

        if ((BHelper.auras:player('Перенаправление') == 0) and
            (BHelper.player:can_cast_on_point('Бросок ловушки: взрывная ловушка')) and
            (not BHelper.player:check_moving())) then
            return BHelper.keybinds:show_spell('Бросок ловушки: взрывная ловушка')
        end

        if (BHelper.player:can_cast_on_point('Град стрел') and (not BHelper.player:check_moving())) then
            return BHelper.keybinds:show_spell('Град стрел')
        end
    else
        return self:mana_regeneration()
    end
end

function BHelper.modules.hunter.default:mana_regeneration()
    if ((BHelper.target:get_mana_max() > 1) and (BHelper.auras:target('Укус гадюки', true) == 0) and
        (BHelper.player:can_cast_on_enemy('Укус гадюки'))) then
        return BHelper.keybinds:show_spell('Укус гадюки')
    end

    if ((BHelper.auras:target('Укус гадюки', true) > 0) and
        BHelper.player:can_cast_on_enemy('Выстрел химеры')) then
        return BHelper.keybinds:show_spell('Выстрел химеры')
    end

    if ((not BHelper.player:check_moving()) and BHelper.player:can_cast_on_enemy('Верный выстрел')) then
        return BHelper.keybinds:show_spell('Верный выстрел')
    end
end

function BHelper.modules.hunter.default:stop()
    self.vars.manual_mana_regeneration = false
    BHelper.core.action:set('rotation_single')
end
