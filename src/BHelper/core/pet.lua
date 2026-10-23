BHelper.pet = {}

local auras = {}
local core = {}
local keybinds = {}
local macros = {}
local modules = {}
local pet = {}
local player = {}
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
    target = BHelper.target
    threat = BHelper.threat
    timers = BHelper.timers
end

function BHelper.pet:get_GUID()
    return UnitGUID('pet') or nil
end

function BHelper.pet:can_target_attack()
    if (not player:can_target_attack()) then return false end
    if (UnitIsUnit('pettarget', 'target')) then return false end

    if (target:get_name() == 'Ледяная сфера') then return false end
    if (target:get_name() == 'Ледяной шар') then return false end
    if (target:get_name() == 'Зловещий дух') then return false end
    if (target:get_name() == 'Волдырный зомби') then return false end
    if ((target:get_name() == 'Имирьярская повелительница льда') and
        (target:aura('Арктический холод') > 0)) then return false end

    return true
end

function BHelper.pet:check_control()
    if (not UnitExists('pet')) then return false end
    if (UnitIsDeadOrGhost('pet')) then return false end
    if (UnitName('pet') == 'Вепрь') then return false end
    return core.profile:get().vars.pet_control
end
