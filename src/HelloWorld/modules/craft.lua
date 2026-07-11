function HelloWorld.craft:init()
    self:set_route('crafting')
end

function HelloWorld.craft:get_bag_free_slots()
    local free_slots_count = 0
    for bag_num = 0, 4 do
        free_slots_count = free_slots_count + (select(1, GetContainerNumFreeSlots(bag_num)))
    end
    return free_slots_count
end
