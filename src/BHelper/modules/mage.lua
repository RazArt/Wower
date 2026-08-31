function BHelper.modules.mage.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.silence == nil) then self.vars.silence = false end
    if (self.vars.can_cast_scorch == nil) then self.vars.can_cast_scorch = true end
    if (self.vars.scorch == nil) then self.vars.scorch = true end

    BHelper.keybinds:bind_spell('Антимагия')
    BHelper.keybinds:bind_spell('Раскаленный доспех')
    BHelper.keybinds:bind_spell('Чародейская гениальность')
    BHelper.keybinds:bind_spell('Усиление магии')
    BHelper.keybinds:bind_spell('Живая бомба')
    BHelper.keybinds:bind_spell('Ожог')
    BHelper.keybinds:bind_spell('Огненный шар')
    BHelper.keybinds:bind_spell('Огненная глыба')
    BHelper.keybinds:bind_spell('Огненный взрыв')
    BHelper.keybinds:bind_spell('Возгорание')
    BHelper.keybinds:bind_spell('Зеркальное изображение')
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')
    BHelper.keybinds:bind_spell('Невидимость')
    BHelper.keybinds:bind_spell('Ледяная глыба')
    BHelper.keybinds:bind_spell('Сотворение самоцвета маны')
    BHelper.keybinds:bind_spell('Снежная буря', true)
    BHelper.keybinds:bind_spell('Огненный столб', true)
    BHelper.keybinds:bind_macro('Невидимость авто')
    BHelper.keybinds:bind_item('Сапфир маны')
    BHelper.keybinds:bind_item('Перчатки ложных знаков')

    self:register_event('UNIT_SPELLCAST_START')
end

function BHelper.modules.mage.default:macros()
    BHelper.macros:create('Щит маны',
                          '#showtooltip Щит маны\n/bh c\n/stopcasting\n/cast Щит маны',
                          2)
    BHelper.macros:create('Скачок',
                          '#showtooltip Скачок\n/bh c\n/stopcasting\n/cast Скачок', 15)
    BHelper.macros:create('Антимагия',
                          '#showtooltip Антимагия\n/bh c\n/stopcasting\n/cast Антимагия',
                          17)
    BHelper.macros:create('Превращение',
                          '#showtooltip Превращение\n/bh c\n/stopcasting\n/cast Превращение',
                          18)
    BHelper.macros:create('Возгорание',
                          '#showtooltip Возгорание\n/bh c\n/stopcasting\n/cast Возгорание',
                          7)
    BHelper.macros:create('Зеркальное изображение',
                          '#showtooltip Зеркальное изображение\n/bh c\n/stopcasting\n/cast Зеркальное изображение',
                          8)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip Берсерк(Расовая)\n/bh c\n/stopcasting\n/cast Берсерк(Расовая)',
                          9)
    BHelper.macros:create('Ледяная глыба',
                          '#showtooltip\n/bh c\n/stopcasting\n/cancelaura Ледяная глыба\n/cast Ледяная глыба',
                          10)
    BHelper.macros:create('Невидимость',
                          '#showtooltip Невидимость\n/bh c\n/cast Невидимость',
                          11)
    BHelper.macros:create('Невидимость авто',
                          '#showtooltip Невидимость\n/cast Невидимость\n/bh c 1')
    BHelper.macros:create('Прилив сил',
                          '#showtooltip Прилив сил\n/bh c\n/cast Прилив сил', 12)

    BHelper.macros:create('ОжогTV', '#showtooltip Ожог\n/bh tv scorch', 40)
    BHelper.macros:create('АнтимагияTV', '#showtooltip Антимагия\n/bh tv silence',
                          41)

    BHelper.macros:create('S', '/cast Огненная глыба\n/bh sa rotation_single\n/bh', 13,
                          true, 1263)
    BHelper.macros:create('M', '/cast Огненный столб\n/bh sa rotation_multiple\n/bh',
                          14, true, 1264)

    BHelper.macros:create('Stop',
                          '/stopcasting\n/stopattack\n/petfollow\n/cleartarget\n/equipset BM', 0,
                          true)
end

function BHelper.modules.mage.default:update()
    if ((BHelper.player:get_health_on_percent() < 20) and
        BHelper.player:can_cast('Ледяная глыба')) then
        return BHelper.keybinds:show_spell('Ледяная глыба')
    end

    if ((BHelper.player:get_buff_time('Невидимость') > 0)) then return true end

    if ((BHelper.target:player_on_target()) and (BHelper.player:can_cast('Невидимость')) and
        (not BHelper.target:is_player())) then
        return BHelper.keybinds:show_macro('Невидимость авто')
    end

    if ((BHelper.player:get_mana_on_percent() < 80) and
        (BHelper.player:can_use_item('Сапфир маны'))) then
        return BHelper.keybinds:show_item('Сапфир маны')
    end

    -- if ((BHelper.player:get_item_count('Сапфир маны') == 0) and
    --     (BHelper.player:can_cast('Сотворение самоцвета маны'))) then
    --     return BHelper.keybinds:show_spell('Сотворение самоцвета маны')
    -- end

    -- if ((BHelper.player:get_buff_time('Чародейская гениальность') == 0) and
    --     (BHelper.player:get_buff_time(
    --         'Чародейская гениальность Даларана') == 0) and
    --     (BHelper.player:can_cast('Чародейская гениальность'))) then
    --     return BHelper.keybinds:show_spell('Чародейская гениальность')
    -- end

    -- if ((BHelper.player:get_buff_time('Раскаленный доспех') == 0) and
    --     (BHelper.player:can_cast('Раскаленный доспех'))) then
    --     UseEquipmentSet('BUFF')
    --     return BHelper.keybinds:show_spell('Раскаленный доспех')
    --     UseEquipmentSet('BUFF2')
    -- end
end

function BHelper.modules.mage.default:rotation_single()
    if ((BHelper.player:get_buff_time('Невидимость') > 0)) then end

    if (BHelper.target:check_cast() and BHelper.player:can_cast_on_enemy('Антимагия') and
        (self.vars.silence)) then return BHelper.keybinds:show_spell('Антимагия') end

    if ((not BHelper.player:check_equipped_item('Трупное окоченение')) and
        (BHelper.player:get_buff_time('Черная магия') > 0)) then
        return BHelper.player:equip_set('MAIN')
    end

    if ((BHelper.player:get_buff_time('Путь огня') > 0) and
        (BHelper.player:can_cast_on_enemy('Огненная глыба'))) then
        return BHelper.keybinds:show_spell('Огненная глыба')
    end

    if ((BHelper.target:get_debuff_time('Живая бомба', true) == 0) and
        (not BHelper.player:check_heroism_buff()) and
        (BHelper.player:can_cast_on_enemy('Живая бомба'))) then
        return BHelper.keybinds:show_spell('Живая бомба')
    end

    if ((BHelper.target:get_debuff_time('Улучшенный ожог') == 0) and
        (BHelper.target:get_debuff_time('Власть над Тенями') == 0) and
        (BHelper.player:can_cast_on_enemy('Ожог')) and (not BHelper.player:check_moving()) and
        (self.vars.can_cast_scorch) and (self.vars.scorch)) then
        return BHelper.keybinds:show_spell('Ожог')
    end

    if (BHelper.player:check_burst_mode()) then
        if (BHelper.player:can_cast('Зеркальное изображение')) then
            return BHelper.keybinds:show_spell('Зеркальное изображение')
        end

        if ((BHelper.player:get_buff_time('Возгорание') == 0) and
            (BHelper.player:can_cast('Возгорание'))) then
            return BHelper.keybinds:show_spell('Возгорание')
        end

        if ((not BHelper.player:check_heroism_buff()) and (not BHelper.vars.cooldown_berserker) and
            (BHelper.player:can_cast('Берсерк(Расовая)'))) then
            return BHelper.keybinds:show_spell('Берсерк(Расовая)')
        end
    end

    if ((BHelper.player:check_equipped_item('Перчатки ложных знаков')) and
        (BHelper.player:can_use_item('Перчатки ложных знаков'))) then
        return BHelper.keybinds:show_item('Перчатки ложных знаков')
    end

    if ((BHelper.player:check_equipped_item(
        'Освященные перчатки волшебника крови')) and
        (BHelper.player:can_use_item(
            'Освященные перчатки волшебника крови'))) then
        return BHelper.keybinds:show_item(
                   'Освященные перчатки волшебника крови')
    end

    if (BHelper.player:can_cast_on_enemy('Огненный шар') and
        (not BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell('Огненный шар')
    end

    if (BHelper.player:can_cast_on_enemy('Огненный взрыв') and
        (BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell('Огненный взрыв')
    end
end

function BHelper.modules.mage.default:UNIT_SPELLCAST_START(castGUID, spellName)
    if (spellName == 'Ожог') then
        self.vars.can_cast_scorch = false
        BHelper.timers:create(2, function()
            self.vars.can_cast_scorch = true
        end, 'can_cast_scorch')
    end
end

function BHelper.modules.mage.default:rotation_multiple()
    if (BHelper.player:can_cast_on_point('Огненный столб') and
        (not BHelper.player:check_moving())) then
        return BHelper.keybinds:show_spell('Огненный столб')
    end
end
