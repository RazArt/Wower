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
    BHelper.DB().opener = 'Чародейская вспышка'

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
                          '#showtooltip Щит маны\n/bh c 0.5\n/cast Щит маны', 2)
    BHelper.macros:create('Скачок',
                          '#showtooltip Скачок\n/bh c 0.5\n/cast Скачок', 1)
    BHelper.macros:create('Ледяная глыба',
                          '#showtooltip\n/bh c 0.5\n/stopcasting\n/cancelaura Ледяная глыба\n/cast Ледяная глыба',
                          24)
    BHelper.macros:create('Стылая кровь',
                          '#showtooltip Стылая кровь\n/bh c 0.5\n/cast Стылая кровь',
                          9)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip Берсерк(Расовая)\n/bh c 0.5\n/cast Берсерк(Расовая)',
                          10)
    BHelper.macros:create('Мощь тайной магии',
                          '#showtooltip Мощь тайной магии\n/bh c 0.5\n/cast Мощь тайной магии',
                          11)
    BHelper.macros:create('Прилив сил',
                          '#showtooltip Прилив сил\n/bh c 0.5\n/cast Прилив сил')
    BHelper.macros:create('Превращение',
                          '#showtooltip Превращение\n/bh c 0.5\n/cast Превращение')

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

function BHelper.modules.mage.ffb:init()
    BHelper.DB().type = 'battle'
    BHelper.DB().opener = 'Живая бомба'

    BHelper.keybinds:bind_spell('Антимагия')
    BHelper.keybinds:bind_spell('Раскаленный доспех')
    BHelper.keybinds:bind_spell('Чародейская гениальность')
    BHelper.keybinds:bind_spell('Усиление магии')
    BHelper.keybinds:bind_spell('Живая бомба')
    BHelper.keybinds:bind_spell('Ожог')
    BHelper.keybinds:bind_spell('Стрела ледяного огня')
    BHelper.keybinds:bind_spell('Огненный шар')
    BHelper.keybinds:bind_spell('Огненная глыба')
    BHelper.keybinds:bind_spell('Возгорание')
end

function BHelper.modules.mage.ffb:macros()
    BHelper.macros:create('Щит маны',
                          '#showtooltip Щит маны\n/bh c 0.5\n/cast Щит маны', 2)
    BHelper.macros:create('Скачок',
                          '#showtooltip Скачок\n/bh c 0.5\n/cast Скачок', 1)
    BHelper.macros:create('Ледяная глыба',
                          '#showtooltip\n/bh c 0.5\n/stopcasting\n/cancelaura Ледяная глыба\n/cast Ледяная глыба',
                          24)
    BHelper.macros:create('Стылая кровь',
                          '#showtooltip Стылая кровь\n/bh c 0.5\n/cast Стылая кровь',
                          9)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip Берсерк(Расовая)\n/bh c 0.5\n/cast Берсерк(Расовая)',
                          10)
    BHelper.macros:create('Возгорание',
                          '#showtooltip Возгорание\n/bh c 0.5\n/cast Возгорание',
                          11)
    BHelper.macros:create('Прилив сил',
                          '#showtooltip Прилив сил\n/bh c 0.5\n/cast Прилив сил')
    BHelper.macros:create('Превращение',
                          '#showtooltip Превращение\n/bh c 0.5\n/cast Превращение')

    BHelper.macros:create('S', '/cast Живая бомба\n/bh sa rotation_single\n/bh', 13, true,
                          1263)
    BHelper.macros:create('M', '/cast Снежная буря\n/bh sa rotation_multiple\n/bh', 14,
                          true, 1264)
end

function BHelper.modules.mage.ffb:update()
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

function BHelper.modules.mage.ffb:rotation_single()
    if (BHelper:is_enemy_cast() and BHelper:can_cast_on_enemy('Антимагия')) then
        BHelper.keybinds:show_spell('Антимагия')
        return true
    end

    if ((BHelper:get_player_buff_time('Путь огня') > 0) and
        (BHelper:can_cast_on_enemy('Огненная глыба'))) then
        BHelper.keybinds:show_spell('Огненная глыба')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Живая бомба', true) == 0) and
        (BHelper:can_cast_on_enemy('Живая бомба'))) then
        BHelper.keybinds:show_spell('Живая бомба')
        return true
    end

    if ((BHelper:get_ememy_debuff_time('Улучшенный ожог', true) == 0) and
        (BHelper:can_cast_on_enemy('Ожог'))) then
        BHelper.keybinds:show_spell('Ожог')
        return true
    end

    if (BHelper:can_cast_on_enemy('Стрела ледяного огня')) then
        BHelper.keybinds:show_spell('Стрела ледяного огня')
        return true
    end
end
