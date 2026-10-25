BHelper.pet = {}

local auras = {}
local core = {}
local keybinds = {}
local macros = {}
local modules = {}
local pet = {}
local player = {}
local pool = {}
local target = {}
local threat = {}
local timers = {}

function BHelper.pet:namespace_init()
    auras = BHelper.auras
    core = BHelper.core
    keybinds = BHelper.keybinds
    macros = BHelper.macros
    modules = BHelper.modules
    pet = BHelper.pet
    player = BHelper.player
    pool = BHelper.pool
    target = BHelper.target
    threat = BHelper.threat
    timers = BHelper.timers
end

function BHelper.pet:GUID()
    return UnitGUID('pet') or nil
end

function BHelper.pet:exist()
    return (UnitExists('pet')) and true or false
end

function BHelper.pet:name()
    return pet._name
end

function BHelper.pet:alive()
    return (not UnitIsDeadOrGhost('pet')) and true or false
end

function BHelper.pet:can_target_attack()
    if (not player:can_target_attack()) then return false end
    if (UnitIsUnit('pettarget', 'target')) then return false end

    if (target:name() == 'Ледяная сфера') then return false end
    if (target:name() == 'Ледяной шар') then return false end
    if (target:name() == 'Зловещий дух') then return false end
    if (target:name() == 'Волдырный зомби') then return false end
    if ((target:name() == 'Имирьярская повелительница льда') and
        (target:aura('Арктический холод') > 0)) then return false end

    return true
end

function BHelper.pet:has_control()
    if (not pet:exist()) then return false end
    if (not pet:alive()) then return false end
    if (pet:name() == 'Вепрь') then return false end
    return core.profile:get().vars.pet_control
end
