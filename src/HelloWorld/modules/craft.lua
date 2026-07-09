function HelloWorld.craft:init()
    self:set_module('crafting')
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

function HelloWorld.craft:get_bag_free_slots()
    local free_slots_count = 0
    for bag_num = 0, 4 do
        free_slots_count = free_slots_count + (select(1, GetContainerNumFreeSlots(bag_num)))
    end
    return free_slots_count
end

