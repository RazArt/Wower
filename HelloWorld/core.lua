function module(name, parent)
    parent = parent or UIParent
    local obj = {}

    obj.name = name
    obj.parent = parent
    obj.module = ''
    obj.step = 0
    obj.vars = {}

    function obj:init()
    end

    function obj:update()
        if (self.step == 0) then
            if (rawget(self, self.module) ~= nil) then self[self.module]:update() end
        else
            self['step_' .. self.step](self)
        end
    end

    function obj:set_module(module)
        if (rawget(self, module) ~= nil) then
            self.module = module
            HelloWorld:change_module_timer()
            self[self.module]:init()
        end
    end

    function obj:set_parent_module(module)
        if (rawget(self.parent, module) ~= nil) then
            self.parent.module = module
            -- HelloWorld:change_module_timer()
            self.parent[self.parent.module]:init()
        end
    end

    function obj:set_step(step)
        if ((step == 0) or (rawget(self, 'step_' .. step) ~= nil)) then self.step = step end
    end

    setmetatable(obj, {
        __index = function(self, name)
            self[name] = module(name, self)
            return self[name]
        end,

        __call = function(self)
            self:init()
        end
    })

    return obj
end
