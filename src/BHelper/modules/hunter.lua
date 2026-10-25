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
local module = BHelper.modules.hunter

function BHelper.modules.hunter.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (not self.vars.mana_regeneration) then self.vars.mana_regeneration = false end
    if (not self.vars.manual_mana_regeneration) then self.vars.manual_mana_regeneration = false end
    if (not self.vars.pet_control) then self.vars.pet_control = true end

    keybinds:bind_spell('Дух дракондора')
    keybinds:bind_spell('Дух гадюки')
    keybinds:bind_spell('Глушащий выстрел')
    keybinds:bind_spell('Усмиряющий выстрел')
    keybinds:bind_spell('Метка охотника')
    keybinds:bind_spell('Укус змеи')
    keybinds:bind_spell('Укус гадюки')
    keybinds:bind_spell('Убийственный выстрел')
    keybinds:bind_spell('Бросок ловушки: взрывная ловушка')
    keybinds:bind_spell('Град стрел')
    keybinds:bind_spell('Выстрел химеры')
    keybinds:bind_spell('Прицельный выстрел')
    keybinds:bind_spell('Верный выстрел')
    keybinds:bind_spell('Залп')
    keybinds:bind_spell('Команда "Взять!"')
    keybinds:bind_spell('Быстрая стрельба')
    keybinds:bind_spell('Берсерк(Расовая)')
    keybinds:bind_spell('Готовность')
    keybinds:bind_spell('Зов дикой природы')
    keybinds:bind_item('Зов берсерка')
    keybinds:bind_item('Знак превосходства')

    keybinds:bind_macro('Перенаправление')
    keybinds:bind_macro('ManaTV', 'BUTTON5')
end

function BHelper.modules.hunter.default:macros()
    macros:create('Отрыв', '#showtooltip\n/bh c\n/stopcasting\n/cast Отрыв', 1)
    macros:create('PetControlTV', '/bh tv pet_control', 42, 273)
    macros:create('ManaTV', '/bh tv manual_mana_regeneration')
    macros:create('Быстрая стрельба',
                  '#showtooltip Быстрая стрельба\n/bh c\n/use Зов берсерка\n/cast Зов дикой природы\n/stopcasting\n/cast Быстрая стрельба\n',
                  9)
    macros:create('Берсерк(Расовая)',
                  '#showtooltip Берсерк(Расовая)\n/bh c\n/cast Берсерк(Расовая)', 10)
    macros:create('Готовность',
                  '#showtooltip Готовность\n/bh c\n/stopcasting\n/cast Готовность', 11)
    macros:create('Притвориться мертвым',
                  '#showtooltip Притвориться мертвым\n/bh stop\n/stopcasting\n/cast Притвориться мертвым',
                  12)
    macros:create('Метка охотника',
                  '#showtooltip Метка охотника\n/bh c\n/stopcasting\n/cast Метка охотника', 21)
    macros:create('Ледяная ловушка',
                  '#showtooltip Ледяная ловушка\n/bh c\n/stopcasting\n/cast Ледяная ловушка',
                  22)
    macros:create('Сдерживание',
                  '#showtooltip Сдерживание\n/bh stop\n/stopcasting\n/cancelaura Сдерживание\n/cast Сдерживание',
                  24)
    macros:create('Перенаправление',
                  '#showtooltip Перенаправление\n/stopcasting\n/bh c\n/cast [@focus,help,nodead] Перенаправление\n/cast [@target,help,nodead] Перенаправление\n/cast [@targettarget,help,nodead] Перенаправление',
                  15)
    macros:create('Глушащий выстрел',
                  '#showtooltip\n/bh c\n/stopcasting\n/cast Глушащий выстрел', 17)
    macros:create('Усмиряющий выстрел',
                  '#showtooltip\n/bh c\n/stopcasting\n/cast Усмиряющий выстрел', 18)
end

function BHelper.modules.hunter.default:execute()
    if (player:mana_on_percent() >= 95) then self.vars.manual_mana_regeneration = false end

    if ((player:mana() < 500)) then
        self.vars.mana_regeneration = true
    elseif ((player:mana() > 3000)) then
        self.vars.mana_regeneration = false
    end

    if ((not self:mana_regeneration()) and (player:aura('Дух дракондора') == 0) and
        (player:aura('Дух дикой природы') == 0) and (player:can_cast('Дух дракондора'))) then
        return keybinds:show_spell('Дух дракондора')
    end

    if ((self:mana_regeneration()) and (player:aura('Дух гадюки') == 0) and
        (player:aura('Дух дикой природы') == 0) and (player:can_cast('Дух гадюки'))) then
        return keybinds:show_spell('Дух гадюки')
    end

    if (player:can_cast_on_enemy('Глушащий выстрел')) then
        return keybinds:show_attack('Глушащий выстрел')
    end

    if ((target:aura('Исступление') > 0) and player:can_cast_on_enemy('Усмиряющий выстрел')) then
        return keybinds:show_spell('Усмиряющий выстрел')
    end

    if (player:can_cast('Команда "Взять!"')) then
        return keybinds:show_help('Команда "Взять!"')
    end
end

function BHelper.modules.hunter.default:rotation_single()
    if (not self:mana_regeneration()) then
        if ((player:can_cast_on_enemy('Убийственный выстрел'))) then
            return keybinds:show_spell('Убийственный выстрел')
        end

        if ((player:is_burst()) and (not self.burst_cooldown)) then
            if ((player:is_equipped_item('Зов берсерка')) and
                (player:can_use_item('Зов берсерка'))) then
                return keybinds:show_item('Зов берсерка')
            end

            if ((player:is_equipped_item('Знак превосходства')) and
                (player:can_use_item('Знак превосходства'))) then
                return keybinds:show_item('Знак превосходства')
            end

            if ((player:aura('Зов дикой природы') == 0) and
                (player:can_cast('Зов дикой природы'))) then
                return keybinds:show_spell('Зов дикой природы')
            end

            if ((player:aura('Быстрая стрельба') == 0) and
                (player:can_cast('Быстрая стрельба'))) then
                return keybinds:show_spell('Быстрая стрельба')
            end

            if (player:can_cast('Берсерк(Расовая)')) then
                return keybinds:show_spell('Берсерк(Расовая)')
            end

            if ((player:spell_cooldown('Быстрая стрельба') > 30) and
                (player:spell_cooldown('Выстрел химеры') > 2) and
                (player:spell_cooldown('Прицельный выстрел') > 2) and
                (player:spell_cooldown('Бросок ловушки: взрывная ловушка') > 2) and
                (player:can_cast('Готовность'))) then
                return keybinds:show_spell('Готовность')
            end
        end

        if (player:aura('Перенаправление') == 0) then
            if ((target:aura('Эффект взрывной ловушки', true) == 0) and
                (player:can_cast_on_point('Бросок ловушки: взрывная ловушка'))) then
                return keybinds:show_spell('Бросок ловушки: взрывная ловушка')
            end

            if ((target:aura('Укус змеи', true) == 0) and (target:aura('Укус гадюки', true) == 0) and
                (player:can_cast_on_enemy('Укус змеи'))) then
                return keybinds:show_spell('Укус змеи')
            end
        end

        if ((not player:can_cast_on_enemy('Убийственный выстрел', 1)) and
            player:can_cast_on_enemy('Выстрел химеры')) then
            return keybinds:show_spell('Выстрел химеры')
        end

        if ((not player:can_cast_on_enemy('Убийственный выстрел', 1)) and
            (not player:can_cast_on_enemy('Выстрел химеры', 1)) and
            player:can_cast_on_enemy('Прицельный выстрел')) then
            return keybinds:show_spell('Прицельный выстрел')
        end

        local ss_cast_time = player:spell_casttime('Верный выстрел') - 0.5
        ss_cast_time = (ss_cast_time < 1) and 1 or ss_cast_time

        if ((not player:can_cast_on_enemy('Убийственный выстрел', ss_cast_time)) and
            (not player:can_cast_on_enemy('Выстрел химеры', ss_cast_time)) and
            (not player:can_cast_on_enemy('Прицельный выстрел', ss_cast_time)) and
            (player:can_cast_on_enemy('Верный выстрел'))) then
            return keybinds:show_spell('Верный выстрел')
        end
    else
        return self:rotation_mana()
    end
end

function BHelper.modules.hunter.default:rotation_multiple()
    if (not self:mana_regeneration()) then
        if ((player:aura('Перенаправление') == 0) and (player:can_cast_on_enemy('Залп'))) then
            return keybinds:show_spell('Залп')
        end

        if ((player:aura('Перенаправление') == 0) and
            (player:can_cast_on_point('Бросок ловушки: взрывная ловушка'))) then
            return keybinds:show_spell('Бросок ловушки: взрывная ловушка')
        end

        if (player:can_cast_on_point('Град стрел')) then
            return keybinds:show_spell('Град стрел')
        end
    else
        return self:rotation_mana()
    end
end

function BHelper.modules.hunter.default:rotation_mana()
    if ((target:mana_max() > 1) and (target:aura('Укус гадюки', true) == 0) and
        (player:can_cast_on_enemy('Укус гадюки'))) then return keybinds:show_spell('Укус гадюки') end

    if ((target:aura('Укус гадюки', true) > 0) and player:can_cast_on_enemy('Выстрел химеры')) then
        return keybinds:show_spell('Выстрел химеры')
    end

    if (player:can_cast_on_enemy('Верный выстрел')) then
        return keybinds:show_spell('Верный выстрел')
    end
end

function BHelper.modules.hunter.default:stop()
    self.vars.manual_mana_regeneration = false
    core.action:set('rotation_single')
end

function BHelper.modules.hunter.default:mana_regeneration()
    return ((self.vars.mana_regeneration) or (self.vars.manual_mana_regeneration)) and true or false
end
