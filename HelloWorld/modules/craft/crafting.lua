function HelloWorld.craft.crafting:init()
    print('reinit crafting')
end

function HelloWorld.craft.crafting:update()

end

-- function HelloWorld.craft:can_cast()
--     if (UnitCastingInfo('player')) then return false end
--     if (UnitChannelInfo('player')) then return false end
--     return true
-- end

-- function HelloWorld.craft:crafting_step_1()
--     -- print(self.name)
--     -- print('New craftdfgedre')
-- end

-- function HelloWorld.craft:get_craftskill_num_available(index)
--     return (select(3, GetcraftSkillInfo(index)))
-- end

-- function HelloWorld.craft:get_craftskill_index(name)
--     for i = GetNumcraftSkills(), 1, -1 do
--         if ((select(2, GetcraftSkillInfo(i)) == "header")) then ExpandcraftSkillSubClass(i) end
--     end
--     for i = 1, GetNumcraftSkills() do
--         if ((select(1, GetcraftSkillInfo(i))) == name) then return i end
--     end
--     return 0
-- end

-- function HelloWorld.craft:craft_item(name)
--     index = self:get_craftskill_index(name)
--     if (index > 0) then
--         num_available = self:get_craftskill_num_available(index)
--         if (num_available > 0) then DocraftSkill(index) end
--     end
-- end

-- function HelloWorld.craft:crafting()
--     local items = self:get_bag_items_count()
--     if ((((items[34056] ~= nil) and (items[34056] > 2)) or
--         ((items[34053] ~= nil) and (items[34053] > 2))) and (self.can_cast())) then
--         self:frames(10):Show()
--     else
--         self:frames(10):Hide()
--     end
--     if (self.vars.crafting.step == 1) then
--         if ((items[41512] ~= nil) and (items[41512] > 0)) then
--             if (self.can_cast()) then
--                 self:frames(11):Show()
--             else
--                 self:frames(11):Hide()
--             end
--         else
--             self.vars.crafting.step = 2
--             self:frames(11):Hide()
--         end
--     end
--     if (self.vars.crafting.step == 2) then
--         if (((items[41510] ~= nil) and (items[41510] > 2)) and
--             ((items[38426] ~= nil) and (items[38426] > 0)) and (self:get_bag_free_slots() > 1)) then
--             if (self.can_cast()) then
--                 self:frames(12):Show()
--             else
--                 self:frames(12):Hide()
--             end
--         else
--             if ((items[41512] ~= nil) and (items[41512] > 0)) then
--                 self.vars.crafting.step = 1
--             else
--                 self.vars.crafting.step = 3
--             end
--             self:frames(12):Hide()
--         end
--     end
--     if (self.vars.crafting.step == 3) then
--         if (self:get_bag_free_slots() > 2) then
--             if (((items[33470] ~= nil) and (items[33470] > 4))) then
--                 if (self.can_cast()) then
--                     self:frames(13):Show()
--                 else
--                     self:frames(13):Hide()
--                 end
--             else
--                 if (items[41510] ~= nil) and (items[41510] > 2) then
--                     self.vars.crafting.step = 2
--                 else
--                     self.vars.crafting.step = 1
--                     self.vars.step = 3
--                 end
--                 self:frames(13):Hide()
--             end
--         else
--             self.vars.crafting.step = 1
--             self.vars.step = 0 -- Закончили работать, сумки забиты
--             self:frames(13):Hide()
--         end
--     end
-- end
