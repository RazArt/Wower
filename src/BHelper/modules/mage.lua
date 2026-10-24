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

function BHelper.modules.mage.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (not self.vars.silence) then self.vars.silence = false end
    if (not self.vars.scorch) then self.vars.scorch = true end
    self.can_cast_scorch = true

    keybinds:bind_spell('Антимагия')
    keybinds:bind_spell('Раскаленный доспех')
    keybinds:bind_spell('Чародейская гениальность')
    keybinds:bind_spell('Усиление магии')
    keybinds:bind_spell('Живая бомба')
    keybinds:bind_spell('Ожог')
    keybinds:bind_spell('Огненный шар')
    keybinds:bind_spell('Огненная глыба')
    keybinds:bind_spell('Огненный взрыв')
    keybinds:bind_spell('Возгорание')
    keybinds:bind_spell('Зеркальное изображение')
    keybinds:bind_spell('Берсерк(Расовая)')
    keybinds:bind_spell('Невидимость')
    keybinds:bind_spell('Ледяная глыба')
    keybinds:bind_spell('Сотворение самоцвета маны')
    keybinds:bind_spell('Снежная буря')
    keybinds:bind_spell('Огненный столб')
    keybinds:bind_spell('Превращение')

    keybinds:bind_macro('Невидимость авто')

    keybinds:bind_item('Сапфир маны')
    keybinds:bind_item('Перчатки ложных знаков')

    self:register_event('UNIT_SPELLCAST_START')
    self:register_event('PLAYER_REGEN_ENABLED')
end

function BHelper.modules.mage.default:macros()
    macros:create('Щит маны', '#showtooltip Щит маны\n/bh c\n/stopcasting\n/cast Щит маны', 2)
    macros:create('Скачок', '#showtooltip Скачок\n/bh c\n/stopcasting\n/cast Скачок', 15)
    macros:create('Антимагия',
                  '#showtooltip Антимагия\n/bh c\n/stopcasting\n/cast Антимагия', 17)
    macros:create('Превращение',
                  '#showtooltip Превращение\n/bh c\n/stopcasting\n/cast Превращение', 18)
    macros:create('Возгорание',
                  '#showtooltip Возгорание\n/bh c\n/stopcasting\n/cast Возгорание', 7)
    macros:create('Зеркальное изображение',
                  '#showtooltip Зеркальное изображение\n/bh c\n/stopcasting\n/cast Зеркальное изображение',
                  8)
    macros:create('Берсерк(Расовая)',
                  '#showtooltip Берсерк(Расовая)\n/bh c\n/stopcasting\n/cast Берсерк(Расовая)',
                  9)
    macros:create('Ледяная глыба',
                  '#showtooltip\n/bh c\n/stopcasting\n/cancelaura Ледяная глыба\n/cast Ледяная глыба',
                  10)
    macros:create('Невидимость',
                  '#showtooltip\n/bh c\n/stopcasting\n/cancelaura Невидимость\n/cast Невидимость',
                  11)
    macros:create('Невидимость авто',
                  '#showtooltip Невидимость\n/cast Невидимость\n/bh c 1')
    macros:create('Прилив сил', '#showtooltip Прилив сил\n/bh c\n/cast Прилив сил', 12)

    macros:create('ОжогTV', '#showtooltip Ожог\n/bh tv scorch', 40)
    macros:create('АнтимагияTV', '#showtooltip Антимагия\n/bh tv silence', 41)

    macros:create('S', '/cast Огненная глыба\n/bh sa rotation_single\n/bh', 13, 1263)
    macros:create('M', '/cast Огненный столб\n/bh sa rotation_multiple\n/bh', 14, 1264)
end

function BHelper.modules.mage.default:execute()
    if ((player:health_on_percent() < 20) and (player:can_cast('Ледяная глыба'))) then
        return keybinds:show_spell('Ледяная глыба')
    end

    if (player:aura('Невидимость') > 0) then return true end

    if ((not player:has_safety_threat(95)) and (player:can_cast('Невидимость')) and (not target:is_player())) then
        return keybinds:show_macro('Невидимость авто')
    end

    if ((player:mana_on_percent() < 80) and (player:can_use_item('Сапфир маны'))) then
        return keybinds:show_item('Сапфир маны')
    end

    if ((target:name() == 'Имирьярская охотница') and (target:check_cast()) and
        (player:can_cast_on_enemy('Превращение'))) then
        return keybinds:show_spell('Превращение')
    end

    if ((player:location_is_icc()) and ((target:is_player()) or
        ((target:name() == 'Имирьярская охотница') and (target:check_cast('Быстрострел')))) and
        (player:can_cast_on_enemy('Превращение'))) then
        return keybinds:show_spell('Превращение')
    end
end

function BHelper.modules.mage.default:rotation_single()
    if ((target:check_cast()) and (self.vars.silence) and (player:can_cast_on_enemy('Антимагия'))) then
        return keybinds:show_spell('Антимагия')
    end

    if ((not player:is_equipped_item('Трупное окоченение')) and
        (player:aura('Черная магия') > 0)) then return player:equip_set('MAIN') end

    if ((player:aura('Путь огня') > 0) and (player:can_cast_on_enemy('Огненная глыба'))) then
        return keybinds:show_spell('Огненная глыба')
    end

    if ((target:aura('Живая бомба', true) == 0) and (not player:has_heroism_buff()) and
        ((target:name() ~= 'Принц Келесет')) and (player:can_cast_on_enemy('Живая бомба'))) then
        return keybinds:show_spell('Живая бомба')
    end

    if ((target:aura('Улучшенный ожог') == 0) and (target:aura('Власть над Тенями') == 0) and
        (self.can_cast_scorch) and (self.vars.scorch) and (player:can_cast_on_enemy('Ожог'))) then
        return keybinds:show_spell('Ожог')
    end

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

    if ((player:is_equipped_item('Перчатки ложных знаков')) and
        (player:can_use_item('Перчатки ложных знаков'))) then
        return keybinds:show_item('Перчатки ложных знаков')
    end

    if ((player:is_equipped_item('Освященные перчатки волшебника крови')) and
        (player:can_use_item('Освященные перчатки волшебника крови'))) then
        return keybinds:show_item('Освященные перчатки волшебника крови')
    end

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

function BHelper.modules.mage.default:UNIT_SPELLCAST_START(castGUID, spellName)
    if (spellName == 'Ожог') then
        self.can_cast_scorch = false
        timers:create(2, function()
            self.can_cast_scorch = true
        end, 'can_cast_scorch')
    end
end

function BHelper.modules.mage.default:PLAYER_REGEN_ENABLED()
    player:equip_set('BM')
end
