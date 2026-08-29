function BHelper.modules.druid.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Калечение')
    BHelper.keybinds:bind_spell('Оглушить')
    BHelper.keybinds:bind_spell('Волшебный огонь (зверь)')
    BHelper.keybinds:bind_spell('Дикий рев')
    BHelper.keybinds:bind_spell('Тигриное неистовство')
    BHelper.keybinds:bind_spell('Размах (кошка)')
    BHelper.keybinds:bind_spell('Размах (медведь)')
    BHelper.keybinds:bind_spell('Увечье (кошка)')
    BHelper.keybinds:bind_spell('Увечье (медведь)')
    BHelper.keybinds:bind_spell('Глубокая рана')
    BHelper.keybinds:bind_spell('Полоснуть')
    BHelper.keybinds:bind_spell('Разорвать')
    BHelper.keybinds:bind_spell('Свирепый укус')
    BHelper.keybinds:bind_spell('Растерзать')
    BHelper.keybinds:bind_spell('Трепка')
    BHelper.keybinds:bind_spell('Цапнуть')
    BHelper.keybinds:bind_spell('Попятиться')
    BHelper.keybinds:bind_spell('Берсерк')
    BHelper.keybinds:bind_spell('Берсерк(Расовая)')
    BHelper.keybinds:bind_spell('Облик лютого медведя')
    BHelper.keybinds:bind_spell('Облик кошки')
    BHelper.keybinds:bind_item('Знак превосходства')
end

function BHelper.modules.druid.default:macros()
    BHelper.macros:create('Накинуться',
                          '#showtooltip\n/bh start\n/cast Накинуться', 88)
    BHelper.macros:create('Чардж',
                          '#showtooltip\n/cast [form:1] Звериная атака - медведь\n/cast [form:3] Звериная атака - кошка',
                          15)
    BHelper.macros:create('Атака',
                          '#showtooltip\n/startattack\n/cast [form:0/2/4/5/6] !Облик кошки(Смена облика)\n/cast Волшебный огонь (зверь)',
                          16)
    BHelper.macros:create('Сало',
                          '#showtooltip\n/cast [form:1/2] Оглушить\n/cast [form:3] Калечение',
                          17)
    BHelper.macros:create('Возрождение',
                          '#showtooltip Возрождение\n/bh c\n/cast Возрождение',
                          19)
    BHelper.macros:create('Дубовая кожа',
                          '#showtooltip Дубовая кожа\n/bh c\n/cast Дубовая кожа',
                          20)
    BHelper.macros:create('Смерч', '#showtooltip Смерч\n/bh c\n/cast Смерч', 21)
    BHelper.macros:create('Озарение',
                          '#showtooltip Озарение\n/bh c\n/cast [@focus,help,nodead] Озарение\n/cast [@target,help,nodead] Озарение\n/cast [@mouseover,help,nodead] Озарение',
                          22)
    BHelper.macros:create('Инстинкты выживания',
                          '#showtooltip Инстинкты выживания\n/bh c\n/cast Инстинкты выживания',
                          23)
    BHelper.macros:create('Инвиз',
                          '#showtooltip Крадущийся зверь\n/bh stop\n/cast [form:0/1/2/4/5/6] !Облик кошки(Смена облика)\n/cast [form:3] Крадущийся зверь',
                          24)
    BHelper.macros:create('Берсерк',
                          '#showtooltip Берсерк\n/bh c\n/cast Берсерк\n/use Знак превосходства',
                          69)
    BHelper.macros:create('Берсерк(Расовая)',
                          '#showtooltip Берсерк(Расовая)\n/bh c\n/cast Берсерк(Расовая)',
                          70)
    BHelper.macros:put_to_panel('Берсерк', 81)
    BHelper.macros:put_to_panel('Берсерк(Расовая)', 82)
    BHelper.macros:create('Неистовое восстановление',
                          '#showtooltip Неистовое восстановление\n/bh c\n/cast Неистовое восстановление',
                          71)
    BHelper.macros:create('Исступление',
                          '#showtooltip Исступление\n/bh c\n/cast Исступление',
                          72)
    BHelper.macros:create('Порыв', '#showtooltip Порыв\n/bh c\n/cast Порыв', 83)
    BHelper.macros:create('Попятиться',
                          '#showtooltip Попятиться\n/bh c\n/cast Попятиться', 84)
    BHelper.macros:create('Калечение', '#showtooltip Калечение\n/bh tv silence',
                          43)
end

function BHelper.modules.druid.default:update()
    if (BHelper.player:get_buff_time('Облик кошки') > 0) then
        if ((BHelper.target:player_on_target() or BHelper.player:check_hight_treat()) and
            (not BHelper.target:is_player()) and (BHelper.player:can_cast('Попятиться'))) then
            return BHelper.keybinds:show_spell('Попятиться')
        end

        -- if ((BHelper.target:player_on_target()) and
        --     (not BHelper.player:can_cast('Попятиться')) and
        --     (not BHelper.target:is_player()) and
        --     (BHelper.player:can_cast('Облик лютого медведя'))) then
        --      return BHelper.keybinds:show_spell('Облик лютого медведя')
        --     return true
        -- end

        if (BHelper.player:check_burst_mode()) then
            if ((BHelper.player:get_buff_time('Тигриное неистовство') == 0) and
                (BHelper.player:get_power() <= 80) and (BHelper.player:can_cast('Берсерк'))) then
                return BHelper.keybinds:show_spell('Берсерк')
            end

            if ((BHelper.player:get_buff_time(50334) > 0) and
                (BHelper.player:check_equipped_item('Знак превосходства')) and
                (BHelper.player:can_use_item('Знак превосходства'))) then
                return BHelper.keybinds:show_item('Знак превосходства')
            end

            if ((not BHelper.player:check_heroism_buff()) and (not BHelper.vars.cooldown_berserker) and
                (BHelper.player:can_cast('Берсерк(Расовая)'))) then
                return BHelper.keybinds:show_spell('Берсерк(Расовая)')
            end
        end
    end
end

function BHelper.modules.druid.default:rotation_single()
    if (BHelper.player:get_buff_time('Облик кошки') > 0) then return self:cat_single() end

    if (BHelper.player:get_buff_time('Облик лютого медведя') > 0) then
        return self:bear_single()
    end
end

function BHelper.modules.druid.default:rotation_multiple()
    if (BHelper.player:get_buff_time('Облик кошки') > 0) then
        return self:cat_multiple()
    end

    if (BHelper.player:get_buff_time('Облик лютого медведя') > 0) then
        return self:bear_multiple()
    end
end

function BHelper.modules.druid.default:cat_single()
    if ((BHelper.target:check_cast()) and (BHelper.player:can_cast_on_enemy('Калечение')) and
        (self.vars.silence)) then return BHelper.keybinds:show_spell('Калечение') end

    if ((BHelper.player:get_buff_time('Дикий рев') == 0) and
        (BHelper.player:can_cast('Дикий рев'))) then
        return BHelper.keybinds:show_spell('Дикий рев')
    end

    if ((BHelper.player:get_buff_time('Дикий рев') <= 3) and
        (BHelper.player:can_cast('Дикий рев')) and (BHelper.player:check_combo_points(4))) then
        return BHelper.keybinds:show_spell('Дикий рев')
    end

    if ((BHelper.player:get_buff_time('Дикий рев') <= 4) and
        (((BHelper.target:get_debuff_time('Разорвать') + 1) >
            BHelper.player:get_buff_time('Дикий рев')) and
            ((BHelper.target:get_debuff_time('Разорвать') - 1) <
                BHelper.player:get_buff_time('Дикий рев'))) and
        (BHelper.player:can_cast('Дикий рев'))) then
        return BHelper.keybinds:show_spell('Дикий рев')
    end

    if ((BHelper.player:get_buff_time('Ясность мысли') == 0) and
        (BHelper.target:get_debuff_time('Глубокая рана') > 0) and
        (BHelper.player:get_buff_time(50334) == 0) and
        (BHelper.target:get_debuff_time('Разорвать', true) >= 2) and
        (BHelper.player:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        return BHelper.keybinds:show_spell('Волшебный огонь (зверь)')
    end

    if ((BHelper.target:get_debuff_time('Увечье (кошка)') == 0) and
        (BHelper.target:get_debuff_time('Увечье (медведь)') == 0) and
        (BHelper.target:get_debuff_time('Травма') == 0) and
        (BHelper.player:can_cast_on_enemy('Увечье (кошка)'))) then
        return BHelper.keybinds:show_spell('Увечье (кошка)')
    end

    if (BHelper.player:get_buff_time('Ясность мысли') > 0) then
        if (BHelper.vars.behind_of_target) then
            if (BHelper.player:can_cast_on_enemy('Полоснуть')) then
                return BHelper.keybinds:show_spell('Полоснуть')
            end
        else
            if (BHelper.player:can_cast_on_enemy('Увечье (кошка)')) then
                return BHelper.keybinds:show_spell('Увечье (кошка)')
            end
        end
    end

    if ((BHelper.player:get_power() <= 30) and
        (BHelper.player:can_cast('Тигриное неистовство'))) then
        return BHelper.keybinds:show_spell('Тигриное неистовство')
    end

    if ((BHelper.target:get_debuff_time('Разорвать', true) == 0) and
        (BHelper.player:check_combo_points(5)) and
        (BHelper.player:can_cast_on_enemy('Разорвать'))) then
        return BHelper.keybinds:show_spell('Разорвать')
    end

    if ((BHelper.target:get_debuff_time('Разорвать', true) >= 4) and
        (BHelper.player:get_buff_time('Дикий рев') >= 4) and
        ((BHelper.player:get_power() <= 45) or (BHelper.player:get_buff_time(50334) > 0)) and
        (BHelper.player:check_combo_points(5)) and
        (BHelper.player:can_cast_on_enemy('Свирепый укус'))) then
        return BHelper.keybinds:show_spell('Свирепый укус')
    end

    if ((BHelper.target:get_debuff_time('Глубокая рана', true) == 0) and
        (BHelper.player:can_cast_on_enemy('Глубокая рана'))) then
        return BHelper.keybinds:show_spell('Глубокая рана')
    end

    if (BHelper.vars.behind_of_target) then
        if (BHelper.player:can_cast_on_enemy('Полоснуть')) then
            return BHelper.keybinds:show_spell('Полоснуть')
        end
    else
        if (BHelper.player:can_cast_on_enemy('Увечье (кошка)')) then
            return BHelper.keybinds:show_spell('Увечье (кошка)')
        end
    end
end

function BHelper.modules.druid.default:bear_single()
    if (BHelper.player:can_cast('Трепка')) then
        BHelper.keybinds:show_attack('Трепка')
    end

    if ((BHelper.target:check_cast()) and (BHelper.player:can_cast_on_enemy('Оглушить')) and
        (self.vars.silence)) then return BHelper.keybinds:show_spell('Оглушить') end

    if ((BHelper.player:get_buff_time('Ясность мысли') == 0) and
        (BHelper.player:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        return BHelper.keybinds:show_spell('Волшебный огонь (зверь)')
    end

    if (BHelper.player:can_cast_on_enemy('Увечье (медведь)')) then
        return BHelper.keybinds:show_spell('Увечье (медведь)')
    end

    if (((BHelper.target:get_debuff_time('Растерзать', true) <= 2) or
        (BHelper.target:get_debuff_count('Растерзать', true) < 5)) and
        (BHelper.player:can_cast_on_enemy('Растерзать'))) then
        return BHelper.keybinds:show_spell('Растерзать')
    end

    if (BHelper.player:can_cast('Размах (медведь)')) then
        return BHelper.keybinds:show_spell('Размах (медведь)')
    end
end

function BHelper.modules.druid.default:cat_multiple()
    if ((BHelper.player:get_buff_time('Ясность мысли') == 0) and
        (BHelper.player:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        return BHelper.keybinds:show_spell('Волшебный огонь (зверь)')
    end

    if ((BHelper.player:get_power() <= 30) and
        (BHelper.player:can_cast('Тигриное неистовство'))) then
        return BHelper.keybinds:show_spell('Тигриное неистовство')
    end

    if ((BHelper.player:get_buff_time('Дикий рев') == 0)) then
        if (BHelper.player:can_cast('Дикий рев')) then
            return BHelper.keybinds:show_spell('Дикий рев')
        end

        if (BHelper.player:can_cast_on_enemy('Глубокая рана')) then
            return BHelper.keybinds:show_spell('Глубокая рана')
        end
    else
        if (BHelper.player:can_cast_on_enemy('Размах (кошка)')) then
            return BHelper.keybinds:show_spell('Размах (кошка)')
        end
    end
end

function BHelper.modules.druid.default:bear_multiple()
    if (BHelper.player:can_cast('Трепка')) then
        BHelper.keybinds:show_attack('Трепка')
    end

    if ((BHelper.player:get_buff_time('Ясность мысли') == 0) and
        (BHelper.player:can_cast_on_enemy('Волшебный огонь (зверь)'))) then
        return BHelper.keybinds:show_spell('Волшебный огонь (зверь)')
    end

    if (BHelper.player:can_cast('Размах (медведь)')) then
        return BHelper.keybinds:show_spell('Размах (медведь)')
    end
end
