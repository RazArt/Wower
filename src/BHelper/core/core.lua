BHelper.core = {}
BHelper.core.module = {}
BHelper.core.profile = {}
BHelper.core.action = {}

function BHelper.core:start()
    if ((BHelper.core.profile:get().settings.only_combat_start) and (not BHelper.player:check_combat_state()) and
        (not BHelper.target:enemy_on_combat())) then return end
    if (IsMounted()) then return false end

    BHelper.auras:update()
    BHelper.vars.cooldown_berserker = true
    BHelper.timers:create(2, function()
        BHelper.vars.cooldown_berserker = false
    end, 'cooldown_berserker')

    BHelper._runing = true
    BHelper.state_frame:Show()

    local profile = BHelper.core.profile:get()
    if (profile.start) then profile:start() end
end

function BHelper.core:stop()
    BHelper._runing = false
    BHelper._cooldown = false
    BHelper.vars.cooldown_berserker = false

    BHelper.state_frame:Hide()

    BHelper.keybinds:show_macro('Stop', 0.1)
    if (BHelper.pet:check_control()) then BHelper.keybinds:show_pet('Follow', 0.1) end

    local profile = BHelper.core.profile:get()
    if (profile.stop) then profile:stop() end
end

function BHelper.core:toggle()
    if (BHelper._runing) then
        BHelper.core:stop()
    else
        BHelper.core:start()
    end
end

function BHelper.core:init_DB()
    if ((not BHelperDB) or (type(BHelperDB) ~= 'table')) then BHelperDB = {} end
    if ((not BHelperDB[BHelper.player:get_spec()]) or (type(BHelperDB[BHelper.player:get_spec()]) ~= 'table')) then
        BHelperDB[BHelper.player:get_spec()] = {}
    end
end

function BHelper.core:reload()
    BHelper.core:init_DB()

    BHelper.core.module._table = nil
    BHelper.core.profile._table = nil
    BHelper.core.action._table = nil

    BHelper.core.module:load()
    local module = BHelper.core.module:get()
    if (not module) then
        BHelper.core.module:set()
        return false
    end

    BHelper.core.profile:load()
    local profile = BHelper.core.profile:get()
    if (not profile) then
        BHelper.core.profile:set()
        return false
    end

    BHelper.core:print('loaded ->', BHelper.core.module:get_name(), BHelper.core.profile:get_name())

    BHelper.keybinds:unbind_all()
    BHelper.macros:delete_all()
    BHelper.core:create_shared_macros()

    local player_spec = BHelper.player:get_spec()
    local module_name = BHelper.core.module:get_name()
    local profile_name = BHelper.core.profile:get_name()

    if (not BHelperDB[player_spec]['modules']) then BHelperDB[player_spec]['modules'] = {} end
    if (not BHelperDB[player_spec]['modules'][module_name]) then BHelperDB[player_spec]['modules'][module_name] = {} end
    if (not BHelperDB[player_spec]['modules'][module_name][profile_name]) then
        BHelperDB[player_spec]['modules'][module_name][profile_name] = {}
    end
    if (not BHelperDB[player_spec]['modules'][module_name][profile_name].settings) then
        BHelperDB[player_spec]['modules'][module_name][profile_name].settings = {}
    end
    if (not BHelperDB[player_spec]['modules'][module_name][profile_name].vars) then
        BHelperDB[player_spec]['modules'][module_name][profile_name].vars = {}
    end

    profile.settings = BHelperDB[player_spec]['modules'][module_name][profile_name].settings
    profile.vars = BHelperDB[player_spec]['modules'][module_name][profile_name].vars

    module:_init()
    module:_macros()
end

function BHelper.core.module:load()
    local name = BHelper.core.module:get_name()
    if (BHelper.core.module:exist(name)) then BHelper.core.module._table = BHelper.modules[name] end
    return nil
end

function BHelper.core.module:get()
    return BHelper.core.module._table
end

function BHelper.core.module:set(name)
    name = (name) and name:lower() or BHelper.player:get_class()
    if (BHelper.core.module:exist(name)) then
        BHelper.core:print('set_module -> ', name)
        local player_spec = BHelper.player:get_spec()
        BHelperDB[player_spec].module_name = name
        BHelperDB[player_spec].profile_name = nil
        BHelper.core:reload()
        return true
    end
    return false
end

function BHelper.core.module:get_name()
    return BHelperDB[BHelper.player:get_spec()].module_name
end

function BHelper.core.module:exist(name)
    name = (name) and name:lower() or ''
    if (rawget(BHelper.modules, name)) then return true end
    return false
end

function BHelper.core.profile:load()
    local name = BHelper.core.profile:get_name()
    if (BHelper.core.profile:exist(name)) then BHelper.core.profile._table = BHelper.core.module:get()[name] end
    return nil
end

function BHelper.core.profile:get()
    return BHelper.core.profile._table
end

function BHelper.core.profile:set(name)
    name = (name) and name:lower() or 'default'
    if (BHelper.core.profile:exist(name)) then
        BHelper.core:print('set_profile -> ', name)
        local player_spec = BHelper.player:get_spec()
        BHelperDB[player_spec].profile_name = name
        BHelper.core:reload()
        return true
    end
    return false
end

function BHelper.core.profile:get_name()
    return BHelperDB[BHelper.player:get_spec()].profile_name
end

function BHelper.core.profile:exist(name)
    name = (name) and name:lower() or ''
    if (rawget(BHelper.core.module:get(), name)) then return true end
    return false
end

function BHelper.core.action:get()
    return BHelper.core.action._table
end

function BHelper.core.action:set(name)
    name = (name) and name:lower() or 'default'

    local profile = BHelper.core.profile:get()
    if ((profile) and (rawget(profile, name))) then
        BHelper.core.action._table = BHelper.core.profile:get()[name]
        return true
    end
    return false
end

function BHelper.core:set_var(var, value)
    local vars = BHelper.core.profile:get().vars

    if (value == "true") then value = true end
    if (value == "false") then value = false end
    if (vars[var] ~= nil) then vars[var] = value end
end

function BHelper.core:toggle_var(var)
    local vars = BHelper.core.profile:get().vars
    if (vars[var] ~= nil) then
        if (vars[var]) then
            BHelper.core:print('var_toggle <', var, '>', false)
            vars[var] = false
        else
            BHelper.core:print('var_toggle <', var, '>', true)
            vars[var] = true
        end
    end
end

function BHelper.core:cooldown(count)
    BHelper._cooldown = true
    BHelper.timers:create(count, function()
        BHelper._cooldown = false
    end, 'cooldown')
end

function BHelper.core:print(...)
    if (BHelper._debug) then print('\124cffff00ffBHelper\124r', '->', ...) end
end

-- function BHelper.core:create_shared_macros()
--     if ((BHelper.player:get_class() == 'hunter') or (BHelper.player:get_class() == 'warlock') or
--         (BHelper.player:get_class() == 'deathknight')) then
--         BHelper.macros:create('PetAttack', '/petattack [@target]', 19, 417)
--         BHelper.macros:create('PetFollow', '/petfollow', 20, 414)
--     end

--     BHelper.macros:create('Target', '/targetenemy\n/startattack\n/bh c', 0)
--     BHelper.macros:create('Stop', '/stopcasting\n/stopattack\n/cleartarget', 0)
--     BHelper.macros:create('Макросы', '/macro', 60, 524)
--     BHelper.macros:create('Roll', '/roll', 52, 1056)
--     BHelper.macros:create('Reload', '/reload', 49, 1058)
--     BHelper.macros:create('Focus', '/focus', 53, 395)
--     BHelper.macros:create('Баджи',
--                           '/script local function buy (n,q) for i=1,100 do if n==GetMerchantItemInfo(i) then BuyMerchantItem(i,q) end end end buy (\'Эмблема героизма\',80)',
--                           0, 689)

--     BHelper.macros:create('S', '/startattack\n/bh sa rotation_single\n/bh', 13, 605)
--     BHelper.macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh', 14, 606)
-- end

function BHelper.core:create_shared_macros()
    if ((BHelper.player:get_class() == 'hunter') or (BHelper.player:get_class() == 'warlock') or
        (BHelper.player:get_class() == 'deathknight')) then
        BHelper.macros:create('PetAttack', '/petattack [@target]', 19, 973)
        BHelper.macros:create('PetFollow', '/petfollow', 20, 970)
    end

    BHelper.macros:create('Target', '/targetenemy\n/startattack\n/bh c', 0, 711)
    BHelper.macros:create('Stop', '/petfollow\n/stopcasting\n/stopattack\n/cleartarget', 0)
    BHelper.macros:create('Аук', '/s .i au', 60, 1935)
    BHelper.macros:create('Банк', '/s .i b', 59, 1933)
    BHelper.macros:create('Почта', '/s .i m', 58, 1931)
    BHelper.macros:create('Магазин', '/s .i v', 57, 1929)
    BHelper.macros:create('Воскрешение', '/s .i massrevive', 56, 1927)
    BHelper.macros:create('Макросы', '/macro', 55, 1123)
    BHelper.macros:create('Тренер', '/s .i t', 0, 1930)
    BHelper.macros:create('Roll', '/roll', 52, 1836)
    BHelper.macros:create('Reload', '/reload', 49, 1838)
    BHelper.macros:create('Focus', '/focus', 53, 921)
    BHelper.macros:create('Баджи',
                          '/script local function buy (n,q) for i=1,100 do if n==GetMerchantItemInfo(i) then BuyMerchantItem(i,q) end end end buy (\'Эмблема героизма\',80)',
                          0, 1374)
    BHelper.macros:create('LADY', '/cleartarget\n/equipset LADY', 26, 1545)
    BHelper.macros:create('PVE', '/cleartarget\n/equipset pve', 27, 199)

    BHelper.macros:create('S', '/startattack\n/bh sa rotation_single\n/bh', 13, 1263)
    BHelper.macros:create('M', '/startattack\n/bh sa rotation_multiple\n/bh', 14, 1264)
end
