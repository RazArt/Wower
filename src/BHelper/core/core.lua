BHelper.core = {}
BHelper.core.module = {}
BHelper.core.profile = {}
BHelper.core.action = {}

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
local DB = {}

local module = nil
local profile = nil
local action = nil

function BHelper.core:namespace_init()
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
    DB = BHelper.DB
end

function BHelper.core:start()
    if ((core.profile:get().settings.only_combat_start) and (not player:on_combat()) and (not target:on_combat())) then
        return false
    end
    if (player:is_mounted()) then return false end

    core.profile:get().burst_cooldown = true
    timers:create(2, function()
        core.profile:get().burst_cooldown = false
    end, 'burst_cooldown')

    core._runing = true
    BHelper.state_frame:Show()

    if (core.profile:get().start) then core.profile:get():start() end
end

function BHelper.core:stop()
    core._runing = false
    core._cooldown = false
    core.profile:get().burst_cooldown = false

    BHelper.state_frame:Hide()

    keybinds:show_macro('Stop', 0.1)
    if (pet:has_control()) then keybinds:show_pet('Follow', 0.1) end
    if (core.profile:get().stop) then core.profile:get():stop() end
end

function BHelper.core:toggle()
    if (core._runing) then
        core:stop()
    else
        core:start()
    end
end

function BHelper.core:reload()
    DB:recache()
    module = nil
    profile = nil
    action = nil

    if (not core.module:get()) then
        core.module:set()
        return false
    end

    if (not core.profile:get()) then
        core.profile:set()
        return false
    end

    core.profile:get().settings = DB:profile_settings()
    core.profile:get().vars = DB:profile_vars()

    keybinds:unbind_all()
    macros:clear()
    core:create_shared_macros()

    core.module:get():_init()
    core.module:get():_macros()

    core.profile:get():_init()
    core.profile:get():_macros()

    -- core.profile:get().settings = DB:profile_settings()
    -- core.profile:get().vars = DB:profile_vars()

    -- keybinds:unbind_all()
    -- macros:clear()
    -- core:create_shared_macros()

    -- core.module:get():_init()
    -- core.module:get():_macros()

    -- core.module:get():_init()
    -- core.module:get():_macros()
end

function BHelper.core:set_var(var, value)
    local vars = core.profile:get().vars

    if (value == 'true') then value = true end
    if (value == 'false') then value = false end
    if (vars[var] ~= nil) then vars[var] = value end
end

function BHelper.core:toggle_var(var)
    local vars = core.profile:get().vars

    if (vars[var] ~= nil) then
        if (vars[var]) then
            core:print('var_toggle <', var, '>', false)
            vars[var] = false
        else
            core:print('var_toggle <', var, '>', true)
            vars[var] = true
        end
    end
end

function BHelper.core:add_cooldown(count)
    core._cooldown = true
    timers:create(count, function()
        core._cooldown = false
    end, 'cooldown')
end

function BHelper.core:runing()
    return core._runing
end

function BHelper.core:cooldown()
    return core._cooldown
end

function BHelper.core:get_update_time()
    return core.update_time
end

function BHelper.core:print(...)
    if (core._debug) then print('\124cffff00ffBHelper\124r', '->', ...) end
end

-- function BHelper.core:create_shared_macros()
--     if ((player:class() == 'hunter') or (player:class() == 'warlock') or
--         (player:class() == 'deathknight')) then
--         macros:create('PetAttack', '/petattack [@target]', 19, 417)
--         macros:create('PetFollow', '/petfollow', 20, 414)
--     end

--     macros:create('Target', '/targetenemy\n/startattack\n/bh c', 0)
--     macros:create('Stop', '/stopcasting\n/stopattack\n/cleartarget', 0)
--     macros:create('Макросы', '/macro', 60, 524)
--     macros:create('Roll', '/roll', 52, 1056)
--     macros:create('Reload', '/reload', 49, 1058)
--     macros:create('Focus', '/focus', 53, 395)
--     macros:create('Баджи',
--                           '/script local function buy (n,q) for i=1,100 do if n==GetMerchantItemInfo(i) then BuyMerchantItem(i,q) end end end buy (\'Эмблема героизма\',80)',
--                           0, 689)

--     macros:create('S', '/startattack\n/bh sa rotation_single\n/bh', 13, 605)
--     macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh', 14, 606)
-- end

function BHelper.core:create_shared_macros()
    if ((player:class() == 'hunter') or (player:class() == 'warlock') or (player:class() == 'deathknight')) then
        macros:create('PetAttack', '/petattack [@target]', 19, 973)
        macros:create('PetFollow', '/petfollow', 20, 970)
    end
    macros:create('Target', '/targetenemy\n/startattack\n/bh c', 0, 711)
    macros:create('Stop', '/stopcasting\n/stopattack\n/cleartarget', 0)
    macros:create('Аук', '/s .i au', 60, 1935)
    macros:create('Банк', '/s .i b', 59, 1933)
    macros:create('Почта', '/s .i m', 58, 1931)
    macros:create('Магазин', '/s .i v', 57, 1929)
    macros:create('Воскрешение', '/s .i massrevive', 56, 1927)
    macros:create('Макросы', '/macro', 55, 1123)
    macros:create('Тренер', '/s .i t', 0, 1930)
    macros:create('Roll', '/roll', 52, 1836)
    macros:create('Reload', '/reload', 49, 1838)
    macros:create('Focus', '/focus', 53, 921)
    macros:create('Баджи',
                  '/script local function buy (n,q) for i=1,100 do if n==GetMerchantItemInfo(i) then BuyMerchantItem(i,q) end end end buy (\'Эмблема героизма\',80)',
                  0, 1374)
    macros:create('LADY', '/cleartarget\n/equipset [noequipped:Оружие] pve; LADY', 26, 1545)
    macros:create('S', '/startattack\n/bh sa rotation_single\n/bh', 13, 1263)
    macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh', 14, 1264)
end

function BHelper.core.module:get()
    if (module) then return module end
    local name = DB:module_name()
    if (core.module:exist(name)) then module = modules[name] end
    return module
end

function BHelper.core.module:set(name)
    name = (name) and name:lower() or player:class()
    if (core.module:exist(name)) then
        core:print('set_module -> ', name)
        DB:module_name(name)
        core:reload()
        return true
    end
    return false
end

function BHelper.core.module:exist(name)
    name = (name) and name:lower() or ''
    if (rawget(modules, name)) then return true end
    return false
end

function BHelper.core.profile:get()
    if (profile) then return profile end
    local name = DB:profile_name()
    if (core.profile:exist(name)) then profile = core.module:get()[name] end
    return profile
end

function BHelper.core.profile:set(name)
    name = (name) and name:lower() or 'default'
    if (core.profile:exist(name)) then
        core:print('set_profile -> ', name)
        DB:profile_name(name)
        core:reload()
        return true
    end
    return false
end

function BHelper.core.profile:exist(name)
    name = (name) and name:lower() or ''
    if ((core.module:get()) and (rawget(core.module:get(), name))) then return true end
    return false
end

function BHelper.core.action:get()
    return action
end

function BHelper.core.action:set(name)
    name = (name) and name:lower() or 'default'
    if ((core.profile:get()) and (rawget(core.profile:get(), name))) then
        action = core.profile:get()[name]
        return true
    end
    return false
end

function BHelper.core:init()
    self._runing = false
    self._cooldown = false
    self._debug = true
    self.update_time = 0.1
end
BHelper.core:init()
