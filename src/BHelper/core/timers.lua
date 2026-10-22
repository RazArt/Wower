BHelper.timers = {}

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
    name = name:lower()
    repeating = repeating or false

    if (name ~= '') then self:delete(name) end
    table.insert(self._timers, {0, count, func, repeating, name})
end

function BHelper.timers:delete(name)
    name = name or ''
    name = name:lower()

    for i = #self._timers, 1, -1 do if (self._timers[i][5] == name) then table.remove(self._timers, i) end end
end

function BHelper.timers:init()
    self._timers = {}

    CreateFrame('Frame'):SetScript('OnUpdate', function(_, elapsed)
        self:update(elapsed)
    end)
end
BHelper.timers:init()
