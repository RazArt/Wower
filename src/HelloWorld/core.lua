function module(name, parent)
    parent = parent or UIParent
    local obj = {}

    obj.name = name
    obj.parent = parent
    obj.action = ''
    obj.runing = true
    obj.vars = {}

    function obj:init()
        self:print('init')
    end

    function obj:update()
        if (not self.runing) then return end

        if (rawget(self, self.action) ~= nil) then
            if (type(rawget(self, self.action)) == 'table') then
                self[self.action]:update()
            elseif (type(rawget(self, self.action)) == 'function') then
                self[self.action](self)
            end
        end
    end

    function obj:set_action(action)
        if (rawget(self, action) ~= nil) then
            self:print('set_action', action)
            self.action = action
            if (type(rawget(self, self.action)) == 'table') then self[self.action]:init() end
        end
    end

    function obj:toggle()
        if (self.runing) then
            self:stop()
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
        self:print('cooldown <', time, '>')
        self.runing = false
        HelloWorld:create_timer(time, function()
            self:print('cooldown < off >')
            self.runing = true
        end, false, self.name .. '_cooldown')
    end

    function obj:print(...)
        print(self.name, '->', ...)
    end

    setmetatable(obj, {
        __index = function(self, name)
            if (name ~= '') then
                self:print('create <' .. name .. '>')
                self[name] = module(self.name .. '/' .. name, self)
                return self[name]
            end
        end,
        __call = function(self)
            self:init()
        end
    })

    return obj
end
