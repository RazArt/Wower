BHelper.pool = {}

local pools = {}
local max_pool_size = 200

function BHelper.pool:fetch(tag)
    tag = tag or 'default'

    local pool = pools[tag]
    if (not pool) then
        pools[tag] = {}
        pools[tag][0] = 0
    else
        local length = pool[0]
        if length > 0 then
            local obj = pool[length]
            pool[length] = nil
            pool[0] = length - 1
            return obj
        end
    end

    return {}
end

function BHelper.pool:release(obj, tag, no_clear)
    tag = tag or 'default'

    local pool = pools[tag]
    if (not pool) then
        pools[tag] = {}
        pools[tag][0] = 0
        pool = pools[tag]
    end

    local length = pool[0] + 1
    if length > max_pool_size then return false end

    if (not no_clear) then
        setmetatable(obj, nil)
        wipe(obj)
    end

    pool[length] = obj
    pool[0] = length
    return true
end

-- function BHelper.pool:print(obj, sep)
--     sep = sep or ''
--     for k, v in pairs(obj) do
--         print(sep, '"', type(v), '"', k, '=>', v)
--         if (type(v) == 'table') then pool:print(v, sep .. '   ') end
--     end
-- end

-- function BHelper.pool:test()
--     local test = {}
--     for i = 1, 1000 do
--         local test2 = BHelper.pool:fetch('threat')
--         test2.guid = 'asdgsedfghserh'
--         test2.threat = 75
--         table.insert(test, test2)
--     end

--     print('---------')
--     BHelper.pool:print(test)
--     print('---------')

--     for i = 1, #test do pool:release(test[i], 'threat', true) end
--     wipe(test)

--     print('---------')
--     print(#pools.threat)
--     print(pools.threat[0])
--     print('---------')
-- end
