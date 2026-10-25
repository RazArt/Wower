BHelper.DB = {}

local DB = nil
local talent_group = 1
local module_name = nil
local profile_name = nil
local profile = nil

function BHelper.DB:recache()
    DB = nil
    talent_group = GetActiveTalentGroup() or 1
    module_name = nil
    profile_name = nil
    profile = nil
end

local function correct_name(name)
    return ((name) and (type(name) == 'string') and (string.match(name, "%a+") == name) and (string.len(name) <= 20))
end

function BHelper.DB:DB()
    if (DB) then return DB end
    if ((not BHelperDB) or (type(BHelperDB) ~= 'table')) then BHelperDB = {} end
    if ((not BHelperDB[talent_group]) or (type(BHelperDB[talent_group]) ~= 'table')) then
        BHelperDB[talent_group] = {}
    end
    DB = BHelperDB[talent_group]
    return DB
end

function BHelper.DB:module_name(name)
    local DB = self:DB()
    if ((name) and (correct_name(name))) then
        name = name:lower()
        DB.module_name = name
        module_name = name
    end
    if (module_name) then return module_name end
    if ((DB.module_name) and (correct_name(DB.module_name))) then module_name = DB.module_name:lower() end
    return module_name
end

function BHelper.DB:profile_name(name)
    local DB = self:DB()
    if ((name) and (correct_name(name))) then
        name = name:lower()
        DB.profile_name = name
        profile_name = name
    end
    if (profile_name) then return profile_name end
    if ((DB.profile_name) and (correct_name(DB.profile_name))) then profile_name = DB.profile_name:lower() end
    return profile_name
end

function BHelper.DB:profile()
    if (profile) then return profile end
    local DB = self:DB()
    local module_name = self:module_name(name)
    local profile_name = self:profile_name(name)
    if ((not module_name) or (not profile_name)) then return nil end
    if ((not DB.modules) or (type(DB.modules) ~= 'table')) then DB.modules = {} end
    if ((not DB.modules[module_name]) or (type(DB.modules[module_name]) ~= 'table')) then
        DB.modules[module_name] = {}
    end
    local module = DB.modules[module_name]
    if ((not module[profile_name]) or (type(module[profile_name]) ~= 'table')) then module[profile_name] = {} end
    profile = module[profile_name]
    return profile
end

function BHelper.DB:profile_settings()
    if (profile_settings) then return profile_settings end
    local profile = self:profile()
    if ((not profile.settings) or (type(profile.settings) ~= 'table')) then profile.settings = {} end
    profile_settings = profile.settings
    return profile_settings
end

function BHelper.DB:profile_vars()
    if (profile_vars) then return profile_vars end
    local profile = self:profile()
    if ((not profile.vars) or (type(profile.vars) ~= 'table')) then profile.vars = {} end
    profile_vars = profile.vars
    return profile_vars
end
