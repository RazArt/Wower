-- Ледяные пальцы
-- Огшненный шар!
-- /закл Раскаленный доспех
-- /закл Чародейская гениальность
-- /закл Антимагия
-- /закл Огненный шар
-- /закл Ожог
-- /закл Огненный столб
-- /закл Огненный взрыв
-- /закл Чародейские стрелы
-- /закл Чародейская вспышка
-- /закл Ледяное копье
-- /закл Ледяная стрела
-- /закл Ледяная преграда
-- /закл Снежная буря
-- /закл Кольцо льда
-- /закл Стылая кровь
-- /закл 
-- /закл Ледяная глыба
-- /закл Скачок
-- /закл Превращение
function BHelper.modules.mage.default:init()
    BHelper.DB().type = 'battle'

    BHelper.keybinds:bind_spell('Антимагия')
    BHelper.keybinds:bind_spell('Раскаленный доспех')
    BHelper.keybinds:bind_spell('Чародейская гениальность')
    BHelper.keybinds:bind_spell('Усиление магии')
    BHelper.keybinds:bind_spell('Чародейская вспышка')
    BHelper.keybinds:bind_spell('Чародейские стрелы')
    BHelper.keybinds:bind_spell('Заградительные стрелы')
    BHelper.keybinds:bind_spell('Чародейский обстрел')
    BHelper.keybinds:bind_spell('Снежная буря')
end

function BHelper.modules.mage.default:macros()
    BHelper.macros:create('Щит маны',
                          '#showtooltip Щит маны\n/bh c\n/cast Щит маны', 2)
    BHelper.macros:create('Скачок', '#showtooltip Скачок\n/bh c\n/cast Скачок', 1)
    BHelper.macros:create('Ледяная глыба',
                          '#showtooltip\n/bh c\n/stopcasting\n/cancelaura Ледяная глыба\n/cast Ледяная глыба',
                          24)
    BHelper.macros:create('Стылая кровь',
                          '#showtooltip Стылая кровь\n/bh c\n/cast Стылая кровь',
                          9)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip Берсерк(Расовая)\n/bh c\n/cast Берсерк(Расовая)',
                          10)
    BHelper.macros:create('Мощь тайной магии',
                          '#showtooltip Мощь тайной магии\n/bh c\n/cast Мощь тайной магии',
                          11)
    BHelper.macros:create('Прилив сил',
                          '#showtooltip Прилив сил\n/bh c\n/cast Прилив сил')
    BHelper.macros:create('Превращение',
                          '#showtooltip Превращение\n/bh c\n/cast Превращение')

    BHelper.macros:create('S',
                          '/cast Чародейская вспышка\n/bh sa rotation_single\n/bh',
                          13, true, 1263)
    BHelper.macros:create('M', '/cast Снежная буря\n/bh sa rotation_multiple\n/bh', 14,
                          true, 1264)
end

function BHelper.modules.mage.default:update()
    if ((BHelper:get_player_buff_time('Раскаленный доспех') == 0) and
        (BHelper:can_cast('Раскаленный доспех'))) then
        BHelper.keybinds:show_spell('Раскаленный доспех')
        return true
    end

    if ((BHelper:get_player_buff_time('Чародейская гениальность') == 0) and
        (BHelper:can_cast('Чародейская гениальность'))) then
        BHelper.keybinds:show_spell('Чародейская гениальность')
        return true
    end

    if ((BHelper:get_player_buff_time('Усиление магии') == 0) and
        (BHelper:can_cast('Усиление магии'))) then
        BHelper.keybinds:show_spell('Усиление магии')
        return true
    end
end

function BHelper.modules.mage.default:rotation_single()
    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Антимагия')) then
        BHelper.keybinds:show_spell('Антимагия')
        return true
    end

    if ((BHelper:get_player_debuff_count('Чародейская вспышка') < 3) and
        (BHelper:can_cast('Чародейская вспышка'))) then
        BHelper.keybinds:show_spell('Чародейская вспышка')
        return true
    end

    if ((BHelper:get_player_buff_time('Величие разума') > 0) and
        (BHelper:can_cast('Чародейская вспышка'))) then
        BHelper.keybinds:show_spell('Чародейская вспышка')
        return true
    end

    if ((BHelper:get_player_buff_time('Заградительные стрелы') > 0) and
        (BHelper:can_cast('Чародейские стрелы'))) then
        BHelper.keybinds:show_spell('Чародейские стрелы')
        return true
    end

    if ((BHelper:can_cast('Чародейский обстрел'))) then
        BHelper.keybinds:show_spell('Чародейский обстрел')
        return true
    end

    if ((BHelper:can_cast('Чародейские стрелы'))) then
        BHelper.keybinds:show_spell('Чародейские стрелы')
        return true
    end
end

function BHelper.modules.mage.ttw:init()
    BHelper.DB().type = 'battle'
    BHelper.DB().only_combat_start = false

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

function BHelper.modules.mage.ttw:macros()
    BHelper.macros:create('Щит маны',
                          '#showtooltip Щит маны\n/bh c\n/cast Щит маны', 2)
    BHelper.macros:create('Скачок', '#showtooltip Скачок\n/bh c\n/cast Скачок', 15)
    BHelper.macros:create('Возгорание',
                          '#showtooltip Возгорание\n/bh c\n/cast Возгорание', 7)
    BHelper.macros:create('Зеркальное изображение',
                          '#showtooltip Зеркальное изображение\n/bh c\n/cast Зеркальное изображение',
                          8)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip Берсерк(Расовая)\n/bh c\n/cast Берсерк(Расовая)',
                          9)
    BHelper.macros:create('Ледяная глыба',
                          '#showtooltip\n/bh c\n/stopcasting\n/cancelaura Ледяная глыба\n/cast Ледяная глыба',
                          10)
    BHelper.macros:create('Невидимость',
                          '#showtooltip Невидимость\n/bh c\n/cast Невидимость',
                          11)
    BHelper.macros:create('Невидимость авто',
                          '#showtooltip Невидимость\n/cast Невидимость\n/bh c 3.1')
    BHelper.macros:create('Прилив сил',
                          '#showtooltip Прилив сил\n/bh c\n/cast Прилив сил', 12)
    BHelper.macros:create('Превращение',
                          '#showtooltip Превращение\n/bh c\n/cast Превращение',
                          18)
    BHelper.macros:create('S', '/cast Огненная глыба\n/bh sa rotation_single\n/bh', 13,
                          true, 1263)
    BHelper.macros:create('M', '/cast Огненный столб\n/bh sa rotation_multiple\n/bh',
                          14, true, 1264)
    -- BHelper.macros:create('Огненный шар',
    --                       '#showtooltip Огненный шар\n/use 10\n/cast Огненный шар')
    -- BHelper.macros:create('Стрела ледяного огня',
    --                       '#showtooltip Стрела ледяного огня\n/use 10\n/cast Стрела ледяного огня')
    BHelper.macros:create('Ожог', '#showtooltip Ожог\n/bh tv scorch', 40)
    BHelper.macros:create('Антимагия', '#showtooltip Антимагия\n/bh tv silence',
                          41)
end

function BHelper.modules.mage.ttw:update()
    if ((BHelper:get_health_on_percent() < 20) and BHelper:can_cast('Ледяная глыба')) then
        BHelper.keybinds:show_spell('Ледяная глыба')
        return true
    end

    if ((BHelper:get_player_buff_time('Невидимость') > 0)) then return true end

    if ((BHelper:player_is_target()) and (BHelper:can_cast('Невидимость')) and
        (not BHelper:target_is_player())) then
        BHelper.keybinds:show_macro('Невидимость авто')
        return true
    end

    if ((BHelper:get_mana_on_percent() < 80) and (BHelper:can_use_item('Сапфир маны'))) then
        BHelper.keybinds:show_item('Сапфир маны')
        return true
    end

    -- if ((BHelper:get_item_count('Сапфир маны') == 0) and
    --     (BHelper:can_cast('Сотворение самоцвета маны'))) then
    --     BHelper.keybinds:show_spell('Сотворение самоцвета маны')
    --     return true
    -- end

    -- if ((BHelper:get_player_buff_time('Чародейская гениальность') == 0) and
    --     (BHelper:get_player_buff_time(
    --         'Чародейская гениальность Даларана') == 0) and
    --     (BHelper:can_cast('Чародейская гениальность'))) then
    --     BHelper.keybinds:show_spell('Чародейская гениальность')
    --     return true
    -- end

    -- if ((BHelper:get_player_buff_time('Раскаленный доспех') == 0) and
    --     (BHelper:can_cast('Раскаленный доспех'))) then
    --     UseEquipmentSet('BUFF')
    --     BHelper.keybinds:show_spell('Раскаленный доспех')
    --     UseEquipmentSet('BUFF2')
    --     return true
    -- end
end

function BHelper.modules.mage.ttw:rotation_single()
    if ((BHelper:get_player_buff_time('Невидимость') > 0)) then return true end

    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Антимагия') and
        (self.vars.silence)) then
        BHelper.keybinds:show_spell('Антимагия')
        return true
    end

    if ((BHelper:get_player_buff_time('Путь огня') > 0) and
        (BHelper:can_cast_on_enemy('Огненная глыба'))) then
        BHelper.keybinds:show_spell('Огненная глыба')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Живая бомба', true) == 0) and
        (not BHelper:exist_heroism_buff()) and (BHelper:can_cast_on_enemy('Живая бомба'))) then
        BHelper.keybinds:show_spell('Живая бомба')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Улучшенный ожог') == 0) and
        (BHelper:get_ememy_debuff_time('Власть над Тенями') == 0) and
        (BHelper:can_cast_on_enemy('Ожог')) and (not BHelper:is_player_moving()) and
        (self.vars.can_cast_scorch) and (self.vars.scorch)) then
        BHelper.keybinds:show_spell('Ожог')
        return true
    end

    if (BHelper:is_burst_mode()) then
        if (BHelper:can_cast('Зеркальное изображение')) then
            BHelper.keybinds:show_spell('Зеркальное изображение')
            return true
        end

        if ((BHelper:get_player_buff_time('Возгорание') == 0) and
            (BHelper:can_cast('Возгорание'))) then
            BHelper.keybinds:show_spell('Возгорание')
            return true
        end

        if ((not BHelper:exist_heroism_buff()) and (not BHelper.vars.cooldown_berserker) and
            (BHelper:can_cast('Берсерк(Расовая)'))) then
            BHelper.keybinds:show_spell('Берсерк(Расовая)')
            return true
        end
    end

    if ((BHelper.common:is_equipped_item('Перчатки ложных знаков')) and
        (BHelper:can_use_item('Перчатки ложных знаков'))) then
        BHelper.keybinds:show_item('Перчатки ложных знаков')
        return true
    end

    if (BHelper:can_cast_on_enemy('Огненный шар') and (not BHelper:is_player_moving())) then
        BHelper.keybinds:show_spell('Огненный шар')
        return true
    end

    if (BHelper:can_cast_on_enemy('Огненный взрыв') and (BHelper:is_player_moving())) then
        BHelper.keybinds:show_spell('Огненный взрыв')
        return true
    end
end

function BHelper.modules.mage.ttw:UNIT_SPELLCAST_START(castGUID, spellName)
    if (spellName == 'Ожог') then
        self.vars.can_cast_scorch = false
        BHelper.timers:create(2, function()
            self.vars.can_cast_scorch = true
        end, 'can_cast_scorch')
    end
end

function BHelper.modules.mage.ttw:rotation_multiple()
    -- if (BHelper:can_cast_on_point('Огненный столб') and
    --     (not BHelper:is_player_moving())) then
    --     BHelper.keybinds:show_spell('Огненный столб')
    --     return true
    -- end

    -- if (BHelper:can_cast_on_point('Снежная буря') and (not BHelper:is_player_moving())) then
    --     BHelper.keybinds:show_spell('Снежная буря')
    --     return true
    -- end
end
