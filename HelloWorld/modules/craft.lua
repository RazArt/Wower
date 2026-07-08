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
function HelloWorld.craft:init()
    self:set_module('auction')
    self.vars.cooldown = false
end

function HelloWorld.craft:update()
    if (self.vars.cooldown) then return end
    if (self.step == 0) then
        if (rawget(self, self.module) ~= nil) then self[self.module]:update() end
    else
        self['step_' .. self.step](self)
    end
end

function HelloWorld.craft:set_cooldown(time)
    self.vars.cooldown = true
    self.parent:create_timer(time, function()
        self.vars.cooldown = false
    end, false, 'craft_cooldown')
end

-- function HelloWorld.craft:get_bag_free_slots()
--     local free_slots_count = 0
--     for bag_num = 0, 4 do
--         free_slots_count = free_slots_count + (select(1, GetContainerNumFreeSlots(bag_num)))
--     end
--     return free_slots_count
-- end
-- function HelloWorld.craft:get_bag_items_count()
--     local items = {}
--     for bag_num = 0, 4 do
--         for slot_num = 1, GetContainerNumSlots(bag_num) do
--             local item_id = GetContainerItemID(bag_num, slot_num)
--             if (item_id ~= nil) then
--                 if (items[item_id] == nil) then items[item_id] = 0 end
--                 items[item_id] = items[item_id] +
--                                      (select(2, GetContainerItemInfo(bag_num, slot_num)))
--             end
--         end
--     end
--     return items
-- end

