-- добавить во все макросы
-- if ((((items[34056] ~= nil) and (items[34056] > 2)) or
--     ((items[34053] ~= nil) and (items[34053] > 2))) and (self:can_cast())) then
--     self:frames(10):Show()
-- else
--     self:frames(10):Hide()
-- end
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
function HelloWorld.craft.crafting:init()
    self:set_step(1)
end

function HelloWorld.craft.crafting:step_1()
    self:toggle()
    self:add_cooldown(20)
    if (GetItemCount(41512) > 0) then
        if (self:can_cast()) then
            HelloWorld:show(11)
        else
            HelloWorld:hide(11)
        end
    else
        HelloWorld:hide(11)
        self:set_step(2)
    end
end

function HelloWorld.craft.crafting:step_2()
    local items = self:get_bag_items_count()
    if ((GetItemCount(41510) > 2) and (GetItemCount(38426) > 0) and
        (self.parent:get_bag_free_slots() > 1)) then
        if (self:can_cast()) then
            HelloWorld:show(12)
        else
            HelloWorld:hide(12)
        end
    else
        if (GetItemCount(41512) > 0) then
            self:set_step(1)
        else
            self:set_step(3)
        end
        HelloWorld:hide(12)
    end
end

function HelloWorld.craft.crafting:step_3()
    if (self.parent:get_bag_free_slots() > 2) then
        if (GetItemCount(33470) > 4) then
            if (self:can_cast()) then
                HelloWorld:show(13)
            else
                HelloWorld:hide(13)
            end
        else
            if (GetItemCount(41510) > 2 and (GetItemCount(38426) > 0)) then
                self:set_step(2)
            else
                self:set_step(1)
                self:set_parent_module('auction')
            end
            HelloWorld:hide(13)
        end
    else
        self:set_step(0)
        -- Закончили работать, сумки забиты
        HelloWorld:hide(13)
    end
end

function HelloWorld.craft.crafting:can_cast()
    if (UnitCastingInfo('player')) then return false end
    if (UnitChannelInfo('player')) then return false end
    return true
end

function HelloWorld.craft.crafting:get_craftskill_index(name)
    for i = GetNumTradeSkills(), 1, -1 do
        if ((select(2, GetTradeSkillInfo(i)) == "header")) then ExpandTradeSkillSubClass(i) end
    end
    for i = 1, GetNumTradeSkills() do
        if ((select(1, GetTradeSkillInfo(i))) == name) then return i end
    end
    return 0
end

function HelloWorld.craft.crafting:craft_item(name)
    index = self:get_craftskill_index(name)
    if (index > 0) then
        if ((select(3, GetTradeSkillInfo(index))) > 0) then DoTradeSkill(index) end
    end
end
