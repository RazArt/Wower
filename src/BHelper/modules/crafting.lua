-- добавить во все макросы
-- -- 41510 Рулон ледяной ткани
-- -- 41512 Ледотканые напульсники
-- -- 34054 Абсолютная пыль
-- -- 34056 Малая космическая субстанция
-- -- 34055 Великая космическая субстанция
-- -- 34053 Маленький осколок грез
-- -- 34052 Осколок грез
-- -- 34057 Кристалл пропасти
-- -- 38426 Этерниевая нить
-- -- 33470 Ледяная ткань
function BHelper.modules.crafting.common:init()
    self.settings.type = 'craft'

    BHelper.keybinds:bind_macro('Субстанция')
    BHelper.keybinds:bind_macro('Распыление')
    BHelper.keybinds:bind_macro('Брасы')
    BHelper.keybinds:bind_macro('Рулоны')
    BHelper.keybinds:bind_macro('Купить')
    BHelper.keybinds:bind_macro('Аукцион')
    BHelper.keybinds:bind_macro('Почта')
    BHelper.keybinds:bind_macro('Нитки')
    BHelper.keybinds:bind_macro('Start')

    BHelper.core.action:set('step_1')
end

-- function BHelper.modules.crafting.common:macros()
--     BHelper.macros:create('Субстанция',
--                           '#showtooltip\n/use Малая космическая субстанция')
--     BHelper.macros:create('Распыление',
--                           '#showtooltip\n/cast Распыление\n/use Ледотканые напульсники')
--     BHelper.macros:create('Брасы',
--                           '/run CloseTradeSkill()\n/cast Портняжное дело\n/run BHelper.modules.crafting.common:craft_item(\'Ледотканые напульсники\')')
--     BHelper.macros:create('Рулоны',
--                           '/run CloseTradeSkill()\n/cast Портняжное дело\n/run BHelper.modules.crafting.common:craft_item(\'Рулон ледяной ткани\')')
--     BHelper.macros:create('Купить', '/run HelloWorld.craft.auction:buy_click()')
--     BHelper.macros:create('Открыть Аукцион',
--                           '/run HelloWorld.craft.auction:open_click()')
--     BHelper.macros:create('Открыть Почта', '/run HelloWorld.craft.mailbox:open_click()')
--     BHelper.macros:create('Нитки', '/run BuyMerchantItem(6, 20)')

--     BHelper.macros:create('Start', '/bh', 13, false, 1263)
-- end

function BHelper.modules.crafting.common:update()
    if ((GetItemCount(34056) > 2) and (self.player:can_cast())) then
        BHelper.keybinds:show_macro('Субстанция')
        BHelper.core:cooldown(0.2)
    end
end

function BHelper.modules.crafting.common:step_1()
    if (GetItemCount(41512) > 0) then
        if (self.player:can_cast()) then BHelper.keybinds:show_macro('Распыление') end
    else
        BHelper.core.action:set('step_2')
    end
end

function BHelper.modules.crafting.common:step_2()
    if ((GetItemCount(41510) > 2) and (GetItemCount(38426) > 0) and
        (BHelper:get_bag_free_slots() > 1)) then
        if (self.player:can_cast()) then BHelper.keybinds:show_macro('Брасы') end
    else
        if (GetItemCount(41512) > 0) then
            BHelper.core.action:set('step_1')
        else
            BHelper.core.action:set('step_3')
        end
    end
end

function BHelper.modules.crafting.common:step_3()
    if (BHelper:get_bag_free_slots() <= 2) then BHelper.core:stop() end

    if (GetItemCount(33470) > 4) then
        if (self:can_cast()) then BHelper.keybinds:show_macro('Рулоны') end
    else
        if (GetItemCount(41510) > 2 and (GetItemCount(38426) > 0)) then
            BHelper.core.action:set('step_2')
        else
            -- BHelper.core.action:set('auction', self)
        end
    end
end

function BHelper.modules.crafting.common:can_cast()
    if (UnitCastingInfo('player')) then return false end
    if (UnitChannelInfo('player')) then return false end
    return true
end

function BHelper.modules.crafting.common:craft_item(name)
    for i = GetNumTradeSkills(), 1, -1 do
        if ((select(2, GetTradeSkillInfo(i)) == "header")) then ExpandTradeSkillSubClass(i) end
    end
    for i = 1, GetNumTradeSkills() do
        if ((select(1, GetTradeSkillInfo(i))) == name) then index = i end
    end
    if (index > 0) then
        if ((select(3, GetTradeSkillInfo(index))) > 0) then DoTradeSkill(index) end
    end
end
