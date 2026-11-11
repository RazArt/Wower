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

local vars = nil

function BHelper.modules.hunter.default:init()
    vars = self.vars

    if (not vars.mana_regeneration) then vars.mana_regeneration = false end
    if (not vars.manual_mana_regeneration) then vars.manual_mana_regeneration = false end
    if (not vars.pet_control) then vars.pet_control = true end

    keybinds:bind_macro('Mana', 'BUTTON5')

    keybinds:bind_item('Зов берсерка')
    keybinds:bind_item('Знак превосходства')
end

function BHelper.modules.hunter.default:macros()
    macros:create('Отрыв', '#showtooltip\n/stopcasting\n/cast Отрыв')
    macros:create('Быстрая стрельба',
                  '#showtooltip Быстрая стрельба\n/use Зов берсерка\n/cast Зов дикой природы\n/stopcasting\n/cast Быстрая стрельба\n')
    macros:create('Готовность', '#showtooltip Готовность\n/stopcasting\n/cast Готовность')
    macros:create('Притвориться мертвым',
                  '#showtooltip Притвориться мертвым\n/bh stop\n/stopcasting\n/cast Притвориться мертвым')
    macros:create('Перенаправление',
                  '#showtooltip Перенаправление\n/stopcasting\n/cast [@focus,help,nodead] Перенаправление\n/cast [@target,help,nodead] Перенаправление\n/cast [@targettarget,help,nodead] Перенаправление')
    macros:create('Глушащий выстрел', '#showtooltip\n/stopcasting\n/cast Глушащий выстрел')
    macros:create('Усмиряющий выстрел',
                  '#showtooltip\n/stopcasting\n/cast Усмиряющий выстрел')
    macros:create('Сдерживание',
                  '#showtooltip Сдерживание\n/bh stop\n/stopcasting\n/cancelaura Сдерживание\n/cast Сдерживание')
    macros:create('Mana', '/bh tv manual_mana_regeneration', 'Spell_Arcane_ManaTap')
end

function BHelper.modules.hunter.default:put()
    keybinds:place_macro('Отрыв', 1)
    keybinds:place_spell('Укус змеи', 2)
    keybinds:place_spell('Прицельный выстрел', 3)
    keybinds:place_spell('Верный выстрел', 4)
    keybinds:place_spell('Выстрел химеры', 5)
    keybinds:place_spell('Бросок ловушки: взрывная ловушка', 6)
    keybinds:place_spell('Убийственный выстрел', 7)
    keybinds:place_spell('Укус гадюки', 8)
    keybinds:place_macro('Быстрая стрельба', 9)
    keybinds:place_spell('Берсерк(Расовая)', 10)
    keybinds:place_macro('Готовность', 11)
    keybinds:place_macro('Притвориться мертвым', 12)
    keybinds:place_macro('Перенаправление', 15)
    keybinds:place_spell('Град стрел', 16)
    keybinds:place_macro('Глушащий выстрел', 17)
    keybinds:place_macro('Усмиряющий выстрел', 18)
    keybinds:place_spell('Метка охотника', 21)
    keybinds:place_spell('Ледяная ловушка', 22)
    keybinds:place_macro('Сдерживание', 24)
    keybinds:place_spell('Отвлекающий выстрел', 30)
    keybinds:place_spell('Дух дикой природы', 31)
    keybinds:place_spell('Дух дракондора', 32)
    keybinds:place_spell('Дух гадюки', 33)
    keybinds:place_spell('Дух стаи', 34)
    keybinds:place_spell('Замораживающая стрела', 35)
    keybinds:place_spell('Приказ хозяина', 36)
    keybinds:place_spell('Призыв питомца', 44)
    keybinds:place_spell('Лечение питомца', 45)
    keybinds:place_spell('Воскрешение питомца', 46)
    keybinds:place_spell('Звериный глаз', 47)
    keybinds:place_macro('PetControl', 41)
    keybinds:place_macro('Mana', 42)
end

function BHelper.modules.hunter.default:execute()
    if (player:mana_on_percent() >= 95) then vars.manual_mana_regeneration = false end

    if ((player:mana() < 500)) then vars.mana_regeneration = true end
    if ((player:mana() > 3000)) then vars.mana_regeneration = false end

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
    if (self:mana_regeneration()) then return self:rotation_mana() end

    if ((player:can_cast_on_enemy('Убийственный выстрел'))) then
        return keybinds:show_spell('Убийственный выстрел')
    end

    if ((player:is_burst()) and (not self.burst_cooldown)) then
        if ((player:is_equipped_item('Зов берсерка')) and (player:can_use_item('Зов берсерка'))) then
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
            (player:can_cast('Готовность'))) then return keybinds:show_spell('Готовность') end
    end

    if (player:aura('Перенаправление') == 0) then
        if ((target:aura('Эффект взрывной ловушки', true) == 0) and
            (player:can_cast_on_point('Бросок ловушки: взрывная ловушка'))) then
            return keybinds:show_spell('Бросок ловушки: взрывная ловушка')
        end

        if ((target:aura('Укус змеи', true) < 3) and (target:aura('Укус гадюки', true) == 0) and
            (player:can_cast_on_enemy('Укус змеи'))) then return keybinds:show_spell('Укус змеи') end
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
end

function BHelper.modules.hunter.default:rotation_multiple()
    if (self:mana_regeneration()) then return self:rotation_mana() end

    if (player:aura('Перенаправление') == 0) then
        if (player:can_cast_on_enemy('Залп')) then return keybinds:show_spell('Залп') end

        if (player:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
            return keybinds:show_spell('Бросок ловушки: взрывная ловушка')
        end
    end

    if (player:can_cast_on_point('Град стрел')) then return keybinds:show_spell('Град стрел') end
end

function BHelper.modules.hunter.default:rotation_mana()
    if ((target:mana_max() > 1) and (target:aura('Укус гадюки', true) < 3) and
        (player:can_cast_on_enemy('Укус гадюки'))) then return keybinds:show_spell('Укус гадюки') end

    if ((target:mana_max() == 0) and (target:aura('Укус змеи', true) < 3) and
        (player:can_cast_on_enemy('Укус змеи'))) then return keybinds:show_spell('Укус змеи') end

    if ((target:aura('Укус гадюки', true) > 0) and player:can_cast_on_enemy('Выстрел химеры')) then
        return keybinds:show_spell('Выстрел химеры')
    end

    if (player:can_cast_on_enemy('Верный выстрел')) then
        return keybinds:show_spell('Верный выстрел')
    end
end

function BHelper.modules.hunter.default:stop()
    vars.manual_mana_regeneration = false
end

function BHelper.modules.hunter.default:mana_regeneration()
    return ((vars.mana_regeneration) or (vars.manual_mana_regeneration)) and true or false
end
