BHelper.modules = {}
-- Проверка баффа, дебафа, энергии, 
function BHelper.modules:module()
    local obj = {}

    obj.vars = {}

    function obj:_init()
        self._action = ''

        if (self.init ~= nil) then self:init() end
    end

    function obj:_update()
        if (self.update ~= nil) then self:update() end
        if (self[self._action] ~= nil) then self[self._action](self) end
    end

    function obj:_macros()
        if (self.macros ~= nil) then self:macros() end
    end

    -- obj._event_frame = CreateFrame('Frame')
    -- obj._event_frame:SetScript('OnEvent', function(_, event, ...)
    --     obj[event](obj, ...)
    -- end)

    -- function obj:register_event(event)
    --     self:print('register_event <', event, '>')

    --     self._event_frame:RegisterEvent(event)
    -- end

    return obj
end

function BHelper.modules:init()
    self.auction = self:module()
    self.crafting = self:module()
    self.mailbox = self:module()

    self.deathknight = self:module()
    self.druid = self:module()
    self.hunter = self:module()
    self.mage = self:module()
    self.paladin = self:module()
    self.priest = self:module()
    self.rogue = self:module()
    self.shaman = self:module()
    self.warlock = self:module()
    self.warrior = self:module()
end
BHelper.modules:init()

-- function BHelper:modules(name, parent)
--     local obj = {}

--     if (parent ~= nil) then
--         obj.name = parent.name .. '/' .. name or name
--         obj.parent = parent
--         obj.root = obj.parent.root
--     else
--         obj.name = name
--         obj.parent = obj
--         obj.root = obj

--         obj._runing = false
--         obj._cooldown = false
--         obj._timers = {}
--         obj._debug = true
--         obj.player = {}
--     end

--     obj._event_frame = CreateFrame('Frame')
--     obj._event_frame._parent = obj
--     obj._event_frame:SetScript('OnEvent', function(self, event, ...)
--         self._parent[event](self._parent, ...)
--     end)

--     obj._route = ''
--     obj.vars = {}

--     function obj:register_event(event)
--         self:print('register_event <', event, '>')

--         self._event_frame:RegisterEvent(event)
--     end

--     function obj:_uninit()
--         self:print('uninit')

--         self.vars = {}
--         self:delete_timer()
--         self._event_frame:UnregisterAllEvents()

--         if (type(rawget(self, 'uninit')) == 'function') then self:uninit() end
--     end

--     function obj:_update(elapsed)
--         if (not self.root._runing) then return end

--         for i = #self.root._timers, 1, -1 do
--             self.root._timers[i][1] = self.root._timers[i][1] + elapsed
--             if self.root._timers[i][1] >= self.root._timers[i][2] then
--                 self.root._timers[i][3]()
--                 if (not self.root._timers[i][4]) then
--                     table.remove(self.root._timers, i)
--                 else
--                     self.root._timers[i][1] = 0
--                 end
--             end
--         end

--         if (self.root._cooldown) then return end

--         if (type(rawget(self, 'update')) == 'function') then self:update() end
--         if (rawget(self, self._route) ~= nil) then
--             if (type(rawget(self, self._route)) == 'table') then
--                 self[self._route]:_update(elapsed)
--             elseif (type(rawget(self, self._route)) == 'function') then
--                 self[self._route](self)
--             end
--         end
--     end

--     function obj:set_route(route, caller)
--         caller = caller or self
--         if (route == '') then
--             self:print('set_route < \'\' >')
--             self._route = route
--             caller:_uninit()
--         elseif ((self._route ~= route) and (rawget(self, route) ~= nil)) then
--             self:print('set_route <', route, '>')
--             if (type(rawget(self, route)) == 'table') then
--                 caller:_uninit()
--                 self[route]:_init()
--             end
--             if ((type(rawget(self, route)) == 'function') and (route == '')) then
--                 self:_init()
--             end
--             self._route = route
--         end
--     end

--     function obj:var_toggle(var)
--         if (rawget(self.vars, var) ~= nil) then
--             if (self.vars[var]) then
--                 self:print('var_toggle <', var, '>', false)
--                 self.vars[var] = false
--             else
--                 self:print('var_toggle <', var, '>', true)
--                 self.vars[var] = true
--             end
--         end
--     end

--     setmetatable(obj, {
--         __index = function(self, name)
--             if (name ~= '') then
--                 self:print('create <', name, '>')
--                 self[name] = BHelper:modules(name, self)
--                 return self[name]
--             end
--         end,
--         __call = function(self)
--             self:_init()
--         end
--     })

--     return obj
-- end
