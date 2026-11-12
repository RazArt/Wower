BHelper.timers = {}

local timers = {}

local function update(elapsed)
    for i = #timers, 1, -1 do
        timers[i][1] = timers[i][1] + elapsed
        if timers[i][1] >= timers[i][2] then
            local func = timers[i][3]
            if (not timers[i][4]) then
                table.remove(timers, i)
            else
                timers[i][1] = 0
            end
            func()
        end
    end
end

function BHelper.timers:create(count, func, name, repeating)
    name = (name) and name:lower() or ''
    if (name ~= '') then self:delete(name) end
    table.insert(timers, {0, count, func, repeating, name})
end

function BHelper.timers:delete(name)
    name = (name) and name:lower() or ''
    for i = #timers, 1, -1 do if (timers[i][5] == name) then table.remove(timers, i) end end
end

local function init()
    local update_time = 0

    CreateFrame('Frame'):SetScript('OnUpdate', function(_, elapsed)
        update_time = update_time + elapsed
        if (update_time >= 0.05) then
            update(update_time)
            update_time = 0
        end
    end)
end
init()
