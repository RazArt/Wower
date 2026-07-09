function module(name, parent)
    parent = parent or UIParent
    local obj = {}

    obj.name = name
    obj.parent = parent
    obj.module = ''
    obj.step = 0
    obj.runing = true
    obj.cooldown = false
    obj.vars = {}

    function obj:init()
    end

    function obj:update()
        if (not self.runing) then return end
        if (self.cooldown) then return end

        if (self.step == 0) then
            if (rawget(self, self.module) ~= nil) then self[self.module]:update() end
        else

            self['step_' .. self.step](self)
        end
    end

    function obj:set_module(module)
        if (rawget(self, module) ~= nil) then
            self:print('set_module', module)
            self.module = module
            self[self.module]:init()
        end
    end

    function obj:set_parent_module(module)
        if (rawget(self.parent, module) ~= nil) then
            self:print('set_parent_module', module)
            self.parent.module = module
            self.parent[self.parent.module]:init()
        end
    end

    function obj:set_step(step)
        if ((step == 0) or (rawget(self, 'step_' .. step) ~= nil)) then
            self:print('set_step', step)
            self.step = step
        end
    end

    function obj:toggle()
        if (self.runing) then
            obj:stop()
        else
            self:start()
        end
    end

    function obj:start()
        self:print('start')
        self.runing = true
    end

    function obj:stop()
        self:print('stop')
        self.runing = false
    end

    function obj:add_cooldown(time)
        self:print('cooldown', time)
        self.cooldown = true
        HelloWorld:create_timer(time, function()
            self:print('cooldown off')
            self.cooldown = false
        end, false, self.name .. '_cooldown')
    end

    function obj:print(...)
        print(self.name, '->', ...)
    end

    setmetatable(obj, {
        __index = function(self, name)
            self[name] = module(self.name .. '/' .. name, self)
            return self[name]
        end,
        __call = function(self)
            self:init()
        end
    })

    return obj
end
