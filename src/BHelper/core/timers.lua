BHelper.timers = {}
BHelper.timers._timers = {}

function BHelper.timers:update(elapsed)
    for i = #self._timers, 1, -1 do
        self._timers[i][1] = self._timers[i][1] + elapsed
        if self._timers[i][1] >= self._timers[i][2] then
            self._timers[i][3]()
            if (not self._timers[i][4]) then
                table.remove(self._timers, i)
            else
                self._timers[i][1] = 0
            end
        end
    end
end

function BHelper.timers:create(count, func, name, repeating)
    name = name or ''
    repeating = repeating or false

    if (name ~= '') then self:delete(string.lower(name)) end
    table.insert(self._timers, {0, count, func, repeating, string.lower(name)})
end

function BHelper.timers:delete(name)
    name = name or ''

    for i = #self._timers, 1, -1 do
        if (string.find(self._timers[i][5], '^' .. name)) then table.remove(self._timers, i) end
    end
end

-- function BHelper.timer:cooldown(count)
--     self:print('add_cooldown <', count, '>')
--     self._cooldown = true
--     self:create_timer(count, function()
--         self:print('cooldown < off >')
--         self._cooldown = false
--     end, 'cooldown')
-- end
