BHelper.core = {}
BHelper.core.module = {}
BHelper.core.profile = {}
BHelper.core.action = {}

local core = BHelper.core
local module = BHelper.core.module
local profile = BHelper.core.profile
local action = BHelper.core.action

local modules = BHelper.modules
local player = BHelper.player
local pet = BHelper.pet
local target = BHelper.target
local auras = BHelper.auras
local timers = BHelper.timers
local keybinds = BHelper.keybinds
local macros = BHelper.macros

function BHelper.core:init()
    core._runing = false
    core._cooldown = false
    core._debug = true
    core.update_time = 0.1
end

function BHelper.core:start()
    if ((profile:get().settings.only_combat_start) and (not player:check_combat_state()) and
        (not target:enemy_on_combat())) then return end
    if (player:is_mounted()) then return false end

    auras:update()
    BHelper.vars.cooldown_berserker = true
    timers:create(2, function()
        BHelper.vars.cooldown_berserker = false
    end, 'cooldown_berserker')

    core._runing = true
    BHelper.state_frame:Show()

    if (profile:get().start) then profile:get():start() end
end

function BHelper.core:stop()
    core._runing = false
    core._cooldown = false
    BHelper.vars.cooldown_berserker = false

    BHelper.state_frame:Hide()

    keybinds:show_macro('Stop', 0.1)
    if (pet:check_control()) then keybinds:show_pet('Follow', 0.1) end
    if (profile:get().stop) then profile:get():stop() end
end

function BHelper.core:toggle()
    if (core._runing) then
        core:stop()
    else
        core:start()
    end
end

function BHelper.core:reload()
    module._table = nil
    profile._table = nil
    action._table = nil

    module:load()
    if (not module:get()) then
        module:set()
        return false
    end

    profile:load()
    if (not profile:get()) then
        profile:set()
        return false
    end

    core:print('loaded ->', module:get_name(), profile:get_name())

    core:init_DB()
    keybinds:unbind_all()
    macros:delete_all()
    core:create_shared_macros()

    profile:get().settings = BHelperDB[player:get_spec()]['modules'][module:get_name()][profile:get_name()].settings
    profile:get().vars = BHelperDB[player:get_spec()]['modules'][module:get_name()][profile:get_name()].vars

    module:get():_init()
    module:get():_macros()
end

function BHelper.core:init_DB()
    local player_spec = player:get_spec()
    local module_name = module:get_name()
    local profile_name = profile:get_name()

    if ((not BHelperDB) or (type(BHelperDB) ~= 'table')) then BHelperDB = {} end

    if ((not BHelperDB[player_spec]) or (type(BHelperDB[player_spec]) ~= 'table')) then BHelperDB[player_spec] = {} end

    if ((not BHelperDB[player_spec]['modules']) or (type(BHelperDB[player_spec]['modules']) ~= 'table')) then
        BHelperDB[player_spec]['modules'] = {}
    end

    if ((not BHelperDB[player_spec]['modules'][module_name]) or
        (type(BHelperDB[player_spec]['modules'][module_name]) ~= 'table')) then
        BHelperDB[player_spec]['modules'][module_name] = {}
    end

    if ((not BHelperDB[player_spec]['modules'][module_name][profile_name]) or
        (type(BHelperDB[player_spec]['modules'][module_name][profile_name]) ~= 'table')) then
        BHelperDB[player_spec]['modules'][module_name][profile_name] = {}
    end

    if ((not BHelperDB[player_spec]['modules'][module_name][profile_name].settings) or
        (type(BHelperDB[player_spec]['modules'][module_name][profile_name].settings) ~= 'table')) then
        BHelperDB[player_spec]['modules'][module_name][profile_name].settings = {}
    end

    if ((not BHelperDB[player_spec]['modules'][module_name][profile_name].vars) or
        (type(BHelperDB[player_spec]['modules'][module_name][profile_name].vars) ~= 'table')) then
        BHelperDB[player_spec]['modules'][module_name][profile_name].vars = {}
    end
end

function BHelper.core:set_var(var, value)
    local vars = profile:get().vars

    if (value == "true") then value = true end
    if (value == "false") then value = false end
    if (vars[var] ~= nil) then vars[var] = value end
end

function BHelper.core:toggle_var(var)
    local vars = profile:get().vars

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
--     if ((player:get_class() == 'hunter') or (player:get_class() == 'warlock') or
--         (player:get_class() == 'deathknight')) then
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
    if ((player:get_class() == 'hunter') or (player:get_class() == 'warlock') or (player:get_class() == 'deathknight')) then
        macros:create('PetAttack', '/petattack [@target]', 19, 973)
        macros:create('PetFollow', '/petfollow', 20, 970)
    end

    macros:create('Target', '/targetenemy\n/startattack\n/bh c', 0, 711)
    macros:create('Stop', '/petfollow\n/stopcasting\n/stopattack\n/cleartarget', 0)
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
    macros:create('LADY', '/cleartarget\n/equipset LADY', 26, 1545)
    macros:create('PVE', '/cleartarget\n/equipset pve', 27, 199)

    macros:create('S', '/startattack\n/bh sa rotation_single\n/bh', 13, 1263)
    macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh', 14, 1264)
end

function BHelper.core.module:load()
    local name = module:get_name():lower()
    if (module:exist(name)) then module._table = modules[name] end
    return nil
end

function BHelper.core.module:get()
    return module._table
end

function BHelper.core.module:set(name)
    name = (name) and name:lower() or player:get_class()
    if (module:exist(name)) then
        core:print('set_module -> ', name)
        BHelperDB[player:get_spec()].module_name = name
        BHelperDB[player:get_spec()].profile_name = nil
        core:reload()
        return true
    end
    return false
end

function BHelper.core.module:get_name()
    return BHelperDB[player:get_spec()].module_name
end

function BHelper.core.module:exist(name)
    name = (name) and name:lower() or ''
    if (rawget(modules, name)) then return true end
    return false
end

function BHelper.core.profile:load()
    local name = profile:get_name():lower()
    if (profile:exist(name)) then profile._table = module:get()[name] end
    return nil
end

function BHelper.core.profile:get()
    return profile._table
end

function BHelper.core.profile:set(name)
    name = (name) and name:lower() or 'default'
    if (profile:exist(name)) then
        core:print('set_profile -> ', name)
        BHelperDB[player:get_spec()].profile_name = name
        core:reload()
        return true
    end
    return false
end

function BHelper.core.profile:get_name()
    return BHelperDB[player:get_spec()].profile_name
end

function BHelper.core.profile:exist(name)
    name = (name) and name:lower() or ''
    if (rawget(module:get(), name)) then return true end
    return false
end

function BHelper.core.action:get()
    return action._table
end

function BHelper.core.action:set(name)
    name = (name) and name:lower() or 'default'
    if ((profile:get()) and (rawget(profile:get(), name))) then
        action._table = profile:get()[name]
        return true
    end
    return false
end
