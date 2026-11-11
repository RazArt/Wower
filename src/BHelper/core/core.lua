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

local update_time = 0.1
local debug = true
local execution = false
local cooldown = false

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
    if ((not player:on_combat()) and (not target:on_combat())) then return false end

    core.profile:get().burst_cooldown = true
    timers:create(2, function()
        core.profile:get().burst_cooldown = false
    end, 'burst_cooldown')

    execution = true

    if (core.profile:get().start) then core.profile:get():start() end
end

function BHelper.core:stop()
    execution = false
    cooldown = false
    core.profile:get().burst_cooldown = false

    if (core.profile:get().stop) then core.profile:get():stop() end
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

    profile.settings = DB:profile_settings()
    profile.vars = DB:profile_vars()

    keybinds:unbind_all()
    keybinds:bind_macro('Target')

    macros:clear()
    core:macros()

    if (module.init) then module:init() end
    if (module.macros) then module:macros() end
    if (module.put) then module:put() end

    if (profile.init) then profile:init() end
    if (profile.macros) then profile:macros() end
    if (profile.put) then profile:put() end

    if (not profile.settings.type) then profile.settings.type = 'battle' end
    if ((profile.settings.type == 'battle') and (not profile.vars.silence)) then profile.vars.silence = false end

    if (profile.settings.usable_equip) then player:equip_set(profile.settings.usable_equip) end
end

function BHelper.core:execute()
    if (BHelper.pet:has_control()) then keybinds:show_pet((pet:can_target_attack()) and 1 or 0) end

    if ((core:execution()) and (not core:cooldown())) then
        local stop_flag = false
        local module = BHelper.core.module:get()
        local profile = BHelper.core.profile:get()
        local action = BHelper.core.action:get()

        if (BHelper.player:spell_is_targeting()) then BHelper.keybinds:show_click() end

        if ((not stop_flag) and (profile.settings.type == 'battle') and (not BHelper.player:can_target_attack())) then
            stop_flag = BHelper.keybinds:show_macro('Target')
        end

        if ((not stop_flag) and (module.execute)) then stop_flag = module:execute() end
        if ((not stop_flag) and (profile.execute)) then stop_flag = profile:execute() end
        if ((not stop_flag) and (action)) then action(profile) end
    end
end

function BHelper.core:set_var(var, value)
    local vars = core.profile:get().vars

    if (value == 'true') then value = true end
    if (value == 'false') then value = false end
    if (vars[var] ~= nil) then
        core:print('var set <', var, '>', value)
        vars[var] = value
    end
end

function BHelper.core:toggle_var(var)
    local vars = core.profile:get().vars

    if (vars[var] ~= nil) then
        if (vars[var]) then
            core:print('var toggle <', var, '>', false)
            vars[var] = false
        else
            core:print('var toggle <', var, '>', true)
            vars[var] = true
        end
    end
end

function BHelper.core:add_cooldown(count)
    cooldown = true
    timers:create(count, function()
        cooldown = false
    end, 'cooldown')
end

function BHelper.core:execution()
    return execution
end

function BHelper.core:cooldown()
    return cooldown
end

function BHelper.core:get_update_time()
    return update_time
end

function BHelper.core:print(...)
    if (debug) then print('\124cffff00ffBHelper\124r', '->', ...) end
end

function BHelper.core.module:get()
    if (module) then return module end
    local name = DB:module_name()
    if (core.module:exist(name)) then
        core:print('load module -> ', name)
        module = modules[name]
    end
    return module
end

function BHelper.core.module:set(name)
    name = (name) and name:lower() or player:class()
    if (core.module:exist(name)) then
        core:print('set module -> ', name)
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
    if (core.profile:exist(name)) then
        core:print('load profile -> ', name)
        profile = core.module:get()[name]
    end
    return profile
end

function BHelper.core.profile:set(name)
    name = (name) and name:lower() or 'default'
    if (core.profile:exist(name)) then
        core:print('set profile -> ', name)
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
    if ((core.profile:get()) and (rawget(core.profile:get(), name)) and (action ~= core.profile:get()[name])) then
        action = core.profile:get()[name]
        return true
    end
    return false
end

function BHelper.core:macros()
    -- /run print(123)\n
    macros:create('Start', '/targetlastenemy\n/startattack\n/bh start')
    keybinds:bind_macro('Start', 'INSERT')

    macros:create('Stop', '/bh stop\n/stopcasting\n/stopattack')
    keybinds:bind_macro('Stop', 'DELETE')

    if ((player:class() == 'hunter') or (player:class() == 'warlock') or (player:class() == 'deathknight')) then
        macros:create('PetAttack', '/petattack [@target]', 'Ability_Vehicle_PlayerLoaded')
        keybinds:bind_macro('PetAttack', 'HOME')
        keybinds:put_macro('PetAttack', 19)

        macros:create('PetFollow', '/petfollow', 'Ability_Vehicle_LoadSelfCatapult')
        keybinds:bind_macro('PetFollow', 'END')
        keybinds:put_macro('PetFollow', 20)

        macros:create('PetControl', '/bh tv pet_control', 'Spell_Magic_PolymorphPig')
    end

    macros:create('Target', '/targetenemy\n/startattack')

    macros:create('Silence', '/bh tv silence', 'Spell_Shadow_SoothingKiss')
    keybinds:put_macro('Silence', 40)

    macros:create('Reload', '/reload', 'Spell_Shadow_SoulLeech_2')
    keybinds:put_macro('Reload', 49)

    macros:create('Roll', '/roll', 'Spell_Shadow_SoulLeech')
    keybinds:put_macro('Roll', 52)

    macros:create('Focus', '/focus', 'Ability_Spy')
    keybinds:put_macro('Focus', 53)

    macros:create('Макросы', '/macro', 'Spell_Arcane_Rune')
    keybinds:put_macro('Макросы', 55)

    if (GetRealmName() == 'WoW Circle 3.3.5a x1') then
        macros:create('Домой', '/s .vip home', 'Spell_Arcane_PortalDalaran')
        keybinds:put_macro('Домой', 56)

        macros:create('ГХ', '/s .gh tele', 'Spell_Arcane_TeleportShattrath')
        keybinds:put_macro('ГХ', 57)

        macros:create('Тренер', '/s .vip class', 'Spell_Arcane_FocusedPower')
        keybinds:put_macro('Тренер', 58)

        macros:create('Почта', '/s .vip mail', 'Ability_Hunter_MarkedForDeath')
        keybinds:put_macro('Почта', 59)

        macros:create('Банк', '/s .vip bank', 'Spell_Shadow_GhostKey')
        keybinds:put_macro('Банк', 60)
    end

    if (GetRealmName() == 'Isengard Tirion x2') then
        macros:create('Воскрешение', '/s .i massrevive', 'spell_yorsahj_bloodboil_blue')
        keybinds:put_macro('Воскрешение', 56)

        macros:create('Магазин', '/s .i v', 'spell_yorsahj_bloodboil_blue')
        keybinds:put_macro('Магазин', 57)

        macros:create('Почта', '/s .i m', 'spell_yorsahj_bloodboil_green')
        keybinds:put_macro('Почта', 58)

        macros:create('Банк', '/s .i b', 'spell_yorsahj_bloodboil_orange')
        keybinds:put_macro('Банк', 59)

        macros:create('Аук', '/s .i au', 'spell_yorsahj_bloodboil_purple')
        keybinds:put_macro('Аук', 60)

        macros:create('Тренер', '/s .i t', 'Spell_Arcane_FocusedPower')
    end

    macros:create('S', '/bh sa rotation_single', 'Spell_Fire_FelPyroblast')
    keybinds:put_macro('S', 13)

    macros:create('M', '/bh sa rotation_multiple', 'Spell_Fire_FelRainOfFire')
    keybinds:put_macro('M', 14)

    macros:create('LADY', '/cleartarget\n/equipset [noequipped:Оружие] pve; LADY', 'Spell_Magic_PolymorphRabbit')
    keybinds:put_macro('LADY', 26)

    macros:create('Баджи',
                  '/script local function buy (n,q) for i=1,100 do if n==GetMerchantItemInfo(i) then BuyMerchantItem(i,q) end end end buy (\'Эмблема героизма\',80)',
                  'Spell_Holy_EmpowerChampion')
end
