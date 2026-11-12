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
local module = BHelper.modules.mage

local vars = nil

local cooldown = {}

function BHelper.modules.mage.default:init()
    vars = self.vars

    self:register_event('UNIT_SPELLCAST_SUCCEEDED')
    self:register_event('PLAYER_REGEN_ENABLED')
end

function BHelper.modules.mage.default:macros()
    macros:create('Ожог', '#showtooltip\n/bh tv scorch', 40)
    macros:create('Антимагия', '#showtooltip\n/bh tv silence', 41)
    macros:create('Щит маны', '#showtooltip\n/stopcasting\n/cast Щит маны')
    macros:create('Скачок', '#showtooltip\n/stopcasting\n/cast Скачок')
    macros:create('Антимагия', '#showtooltip\n/stopcasting\n/cast Антимагия')
    macros:create('Превращение', '#showtooltip\n/stopcasting\n/cast Превращение')
    macros:create('Возгорание', '#showtooltip\n/stopcasting\n/cast Возгорание')
    macros:create('Зеркальное изображение',
                  '#showtooltip\n/stopcasting\n/cast Зеркальное изображение')
    macros:create('Ледяная глыба',
                  '#showtooltip\n/stopcasting\n/cancelaura Ледяная глыба\n/cast Ледяная глыба')
    macros:create('Невидимость',
                  '#showtooltip\n/stopcasting\n/cancelaura Невидимость\n/cast Невидимость')
end

function BHelper.modules.mage.default:put()
    keybinds:place_macro('Щит маны', 2)
    keybinds:place_spell('Ожог', 3)
    keybinds:place_spell('Огненный шар', 4)
    keybinds:place_spell('Огненная глыба', 5)
    keybinds:place_spell('Огненный взрыв', 6)
    keybinds:place_macro('Возгорание', 7)
    keybinds:place_macro('Зеркальное изображение', 8)
    keybinds:place_spell('Берсерк(Расовая)', 9)
    keybinds:place_macro('Ледяная глыба', 10)
    keybinds:place_macro('Невидимость', 11)
    keybinds:place_spell('Прилив сил', 11)
    keybinds:place_macro('Скачок', 15)
    keybinds:place_spell('Огненный столб', 16)
    keybinds:place_macro('Антимагия', 17)
    keybinds:place_macro('Антимагия', 18)
    keybinds:place_item('Сера Сульфурона', 32)
    keybinds:place_item('Сапфир маны', 33)
    keybinds:place_spell('Снятие проклятия', 34)
    keybinds:place_spell('Защита от магии льда', 35)
    keybinds:place_spell('Обряд сотворения яств', 36)
    keybinds:place_spell('Замедленное падение', 42)
    keybinds:place_spell('Сотворение самоцвета маны', 43)
    keybinds:place_spell('Магическая концентрация', 44)
    keybinds:place_spell('Усиление магии', 45)
    keybinds:place_spell('Раскаленный доспех', 46)
    keybinds:place_spell('Портал в Даларан', 47)
end

function BHelper.modules.mage.default:execute()
    if ((player:health_on_percent() < 20) and (player:can_cast('Ледяная глыба'))) then
        return keybinds:show_spell('Ледяная глыба')
    end

    if (player:aura('Невидимость') > 0) then return true end

    if ((not player:has_safety_threat(95)) and (player:can_cast('Невидимость')) and (not target:is_player())) then
        return keybinds:show_macro('Невидимость')
    end

    if ((player:mana_on_percent() < 80) and (player:can_use_item('Сапфир маны'))) then
        return keybinds:show_item('Сапфир маны')
    end

    if (player:location_is_icc()) then
        if ((target:is_player()) and (player:can_cast_on_enemy('Превращение'))) then
            return keybinds:show_spell('Превращение')
        end
        if ((target:name() == 'Имирьярская охотница') and
            (target:check_cast('Быстрострел')) and (player:can_cast_on_enemy('Превращение'))) then
            return keybinds:show_spell('Превращение')
        end
    end

    if ((target:check_cast()) and (vars.silence) and (player:can_cast_on_enemy('Антимагия'))) then
        return keybinds:show_spell('Антимагия')
    end
end

function BHelper.modules.mage.default:rotation_single()
    if ((not player:is_equipped_item('Трупное окоченение')) and
        (player:aura('Черная магия') > 0)) then return player:equip_set('DPS') end

    if ((player:aura('Путь огня') > 0) and (player:can_cast_on_enemy('Огненная глыба'))) then
        return keybinds:show_spell('Огненная глыба')
    end

    if ((target:aura('Живая бомба', true) == 0) and (not player:has_heroism_buff()) and
        ((target:name() ~= 'Принц Келесет')) and (player:can_cast_on_enemy('Живая бомба'))) then
        return keybinds:show_spell('Живая бомба')
    end

    if ((target:aura('Улучшенный ожог') < 3) and (target:aura('Власть над Тенями') == 0) and
        (not cooldown.scorch) and (player:can_cast_on_enemy('Ожог'))) then return keybinds:show_spell('Ожог') end

    if ((player:is_burst()) and (not self.burst_cooldown)) then
        if (player:can_cast('Зеркальное изображение')) then
            return keybinds:show_spell('Зеркальное изображение')
        end

        if ((player:aura('Возгорание') == 0) and (player:can_cast('Возгорание'))) then
            return keybinds:show_spell('Возгорание')
        end

        if (player:can_cast('Берсерк(Расовая)')) then
            return keybinds:show_spell('Берсерк(Расовая)')
        end
    end

    local item_hand = player:item_name(INVSLOT_HAND)
    if ((player:is_equipped_item(item_hand)) and (player:can_use_item(item_hand))) then keybinds:show_item(item_hand) end

    if (player:can_cast_on_enemy('Огненный шар')) then
        return keybinds:show_spell('Огненный шар')
    end

    if (player:can_cast_on_enemy('Огненный взрыв')) then
        return keybinds:show_spell('Огненный взрыв')
    end
end

function BHelper.modules.mage.default:rotation_multiple()
    if (player:can_cast_on_point('Огненный столб')) then
        return keybinds:show_spell('Огненный столб')
    end
end

function BHelper.modules.mage.default:UNIT_SPELLCAST_SUCCEEDED(unit_id, spellName)
    if (unit_id ~= 'player') then return end

    if (spellName == 'Ожог') then
        cooldown.scorch = true
        timers:create(1, function()
            cooldown.scorch = false
        end, 'scorch')
    end
end

function BHelper.modules.mage.default:PLAYER_REGEN_ENABLED()
    player:equip_set('BM')
end
