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

        obj.state_frame = CreateFrame('Frame')
        obj.state_frame:SetSize(50, 50)
        obj.state_frame:SetFrameStrata('tooltip')
        obj.state_frame:SetPoint('center', UIParent, 'center', 0, -160)
        obj.state_frame.texture = obj.state_frame:CreateTexture(nil, 'tooltip')
        obj.state_frame.texture:SetAllPoints(obj.state_frame)
        obj.state_frame.texture:SetTexture('Interface\\AddOns\\HelloWorld\\textures\\warning.tga')
        obj.state_frame:Hide()

        obj._runing = false
        obj._cooldown = false
        obj._timers = {}
        obj._debug = true
    end

    obj._event_frame = CreateFrame('Frame')
    obj._event_frame._parent = obj
    obj._event_frame:SetScript('OnEvent', function(self, event, ...)
        self._parent[event](self._parent, ...)
    end)

    obj._route = ''
    obj.vars = {}

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

        self.vars = {}
        self:delete_timer()
        self._event_frame:UnregisterAllEvents()

        if (type(rawget(self, 'uninit')) == 'function') then self:uninit() end
    end

    function obj:_update(elapsed)
        if (not self.root._runing) then return end

        for i = #self.root._timers, 1, -1 do
            self.root._timers[i][1] = self.root._timers[i][1] + elapsed
            if self.root._timers[i][1] >= self.root._timers[i][2] then
                self.root._timers[i][3]()
                if (not self.root._timers[i][4]) then
                    table.remove(self.root._timers, i)
                else
                    self.root._timers[i][1] = 0
                end
            end
        end

        if (self.root._cooldown) then return end

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
            -- Подумать над возвращением на шаги и init()
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

    function obj:create_timer(count, func, name, repeating)
        name = name or ''
        full_name = self.name .. '/' .. name
        repeating = repeating or false

        self:print('create_timer <', count, '>', full_name)

        if (name ~= '') then self:delete_timer(name) end
        table.insert(self.root._timers, {0, count, func, repeating, full_name})
    end

    function obj:delete_timer(name)
        name = name or ''

        for i = #self.root._timers, 1, -1 do
            if (string.find(self.root._timers[i][5], '^' .. self.name .. '/' .. name)) then
                table.remove(self.root._timers, i)
            end
        end
    end

    function obj:add_cooldown(count)
        self:print('add_cooldown <', count, '>')
        self.root._cooldown = true
        self:create_timer(count, function()
            self:print('cooldown < off >')
            self.root._cooldown = false
        end, 'cooldown')
    end

    function obj:toggle()
        if (self.root._runing) then
            self:stop()
        else
            self:start()
        end
    end

    function obj:start()
        self:print('start')
        self.root._runing = true
        self.root.state_frame:Show()
    end

    function obj:stop()
        self:print('stop')
        self.root._runing = false
        self.root.state_frame:Hide()
    end

    function obj:print(...)
        if (self.root._debug) then print(self.name, '->', ...) end
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

