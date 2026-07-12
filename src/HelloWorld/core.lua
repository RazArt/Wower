function Module(name, parent) -- Module class
    local obj = {}

    if (parent ~= nil) then
        obj.name = parent.name .. '/' .. name or name
        obj.parent = parent
        obj.root = obj.parent.root
    else
        obj.name = name
        obj.parent = obj
        obj.root = obj
    end
    obj._event_frame = CreateFrame('Frame')
    obj._event_frame._parent = obj
    obj._event_frame:SetScript('OnEvent', function(self, event, ...)
        local frame_parent = self:GetParent()
        self._parent[event](self._parent, ...)
    end)

    obj._route = ''
    obj._runing = true
    obj._cooldown = false
    obj.vars = {}
    obj.timers = {}
    obj._debug = true

    function obj:register_event(event)
        self:print('register_event <', event, '>')
        self._event_frame:RegisterEvent(event)
    end

    function obj:_init()
        self:print('init')
        if (type(rawget(self, 'init')) == 'function') then self:init() end
    end

    function obj:_uninit()
        self:print('uninit')
        obj.vars = {}
        obj.timers = {}
        self._event_frame:UnregisterAllEvents()
        if (type(rawget(self, 'uninit')) == 'function') then self:uninit() end
    end

    function obj:_update(elapsed)
        if (not self._runing) then return end

        for i = 1, #self.timers do
            if (self.timers[i] ~= nil) then
                self.timers[i][1] = self.timers[i][1] + elapsed
                if self.timers[i][1] >= self.timers[i][2] then
                    self.timers[i][3]()
                    self.timers[i][1] = 0
                    if (not self.timers[i][4]) then table.remove(self.timers, i) end
                end
            end
        end

        if (obj._cooldown) then return end

        if (type(rawget(self, 'update')) == 'function') then self:update() end
        if (rawget(self, self._route) ~= nil) then
            if (type(rawget(self, self._route)) == 'table') then
                self[self._route]:_update(elapsed)
            elseif (type(rawget(self, self._route)) == 'function') then
                self[self._route](self)
            end
        end
    end

    function obj:set_route(route, caller)
        caller = caller or self

        if (route == '') then
            self:print('set_route < \'\' >')
            self._route = route
            caller:_uninit()
        elseif ((self._route ~= route) and (rawget(self, route) ~= nil)) then
            self:print('set_route <', route, '>')
            self._route = route
            if (type(rawget(self, self._route)) == 'table') then
                caller:_uninit()
                self[self._route]:_init()
            end
        end
    end

    function obj:create_timer(count, func, repeating, name)
        self:print('create_timer <', count, '>')
        name = name or false
        repeating = repeating or false

        if (name ~= false) then
            for i = 1, #self.timers do
                if (self.timers[i][5] == name) then table.remove(self.timers, i) end
            end
        end

        table.insert(self.timers, {0, count, func, repeating, name})
    end

    function obj:add_cooldown(count)
        self:print('add_cooldown <', count, '>')
        self._cooldown = true
        self:create_timer(count, function()
            self:print('cooldown < off >')
            self._cooldown = false
        end, false, self.name .. '_cooldown')
    end

    function obj:toggle()
        if (self._runing) then
            self:stop()
        else
            self:start()
        end
    end

    function obj:start()
        self:print('start')
        self._runing = true
        HelloWorld.state_frame:Show()
    end

    function obj:stop()
        self:print('stop')
        self._runing = false
        HelloWorld.state_frame:Hide()
    end

    function obj:print(...)
        -- if (obj._debug) then print(self.name, '->', ...) end
    end

    setmetatable(obj, {
        __index = function(self, name)
            if (name ~= '') then
                self:print('create <', name, '>')
                self[name] = Module(name, self)
                return self[name]
            end
        end,
        __call = function(self)
            self:_init()
        end
    })

    return obj
end

HelloWorld = Module('HelloWorld')
Keystroke = Module('Keystroke')

