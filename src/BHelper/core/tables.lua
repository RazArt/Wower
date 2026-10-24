BHelper.tables = {}

local auras = {}
local core = {}
local keybinds = {}
local macros = {}
local modules = {}
local pet = {}
local player = {}
local tables = {}
local target = {}
local threat = {}
local timers = {}
local DB = {}

function BHelper.tables:namespace_init()
    auras = BHelper.auras
    core = BHelper.core
    keybinds = BHelper.keybinds
    macros = BHelper.macros
    modules = BHelper.modules
    pet = BHelper.pet
    player = BHelper.player
    tables = BHelper.tables
    target = BHelper.target
    threat = BHelper.threat
    timers = BHelper.timers
    DB = BHelperDB
end

function BHelper.tables:get(type)
    type = type or 'default'
    if (not tables._tables[type]) then tables._tables[type] = {} end
    return table.remove(tables._tables[type]) or {}
end

function BHelper.tables:release(obj, type, no_clear)
    type = type or 'default'
    if (not no_clear) then wipe(obj) end
    tables._tables[type] = tables._tables[type] or {}
    table.insert(tables._tables[type], obj)
end

function BHelper.tables:print(obj, sep)
    sep = sep or ''
    for k, v in pairs(obj) do
        print(sep, '"', type(v), '"', k, '=>', v)
        if (type(v) == 'table') then tables:print(v, sep .. '   ') end
    end
end

function BHelper.tables:init()
    self._tables = {}
end
BHelper.tables:init()

