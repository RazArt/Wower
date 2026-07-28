BHelper.DB = {}

function BHelper.DB:reload()
    self.profile = nil
    self.DB = nil
    self.vars = nil
    self.module = nil
    self.action = nil
end

function BHelper.DB:get_DB() -- удалять self.DB self.vars после смены спека, профиля
    if (self.DB) then return self.DB end

    local profile = self:get_profile()
    if ((BHelperDB[profile] == nil) or (type(BHelperDB[profile]) ~= 'table')) then
        BHelperDB[profile] = {}
    end

    if (not BHelper:is_module_exist(BHelperDB[profile].module)) then
        BHelperDB[profile].module = BHelper:get_player_class()
    end

    if (not BHelper:is_action_exist(BHelperDB[profile].module, profile, BHelperDB[profile].action)) then
        BHelperDB[profile].action = ''
    end

    if ((BHelperDB[profile].type ~= 'battle') or (BHelperDB[profile].type ~= 'heal') or
        (BHelperDB[profile].type ~= 'craft')) then BHelperDB[profile].type = 'battle' end

    if ((BHelperDB[profile].vars == nil) or (type(BHelperDB[profile].vars) ~= 'table')) then
        BHelperDB[profile].vars = {}
    end

    self.DB = BHelperDB[profile]

    return self.DB
end

function BHelper.DB:get_vars() -- удалять self.DB self.vars после смены спека, профиля, модуля
    if (self.vars) then return self.vars end

    local DB = self:get_DB()
    if ((DB.vars[DB.module] == nil) or (type(DB.vars[DB.module]) ~= 'table')) then
        DB.vars[DB.module] = {}
    end

    self.vars = DB.vars[DB.module]

    return self.vars
end

function BHelper.DB:get_profile()
    if (self.profile) then return self.profile end

    local profile = BHelperDB.selected_profiles[BHelper:get_player_spec()]
    if (profile and string.match(profile, '^[_%w]+$')) then
        self.profile = profile
    else
        BHelperDB.selected_profiles[BHelper:get_player_spec()] = self._default_profile
        self.profile = self._default_profile
    end

    return self.profile
end

function BHelper.DB:set_profile(profile)
    profile = string.lower(profile)

    if (string.match(profile, '^[_%w]+$')) then
        BHelperDB.selected_profiles[BHelper:get_player_spec()] = profile
        self:reload()

        return true
    end

    return false
end

function BHelper.DB:init()
    setmetatable(BHelper.DB, {
        __call = function(self)
            return self:get_DB()
        end
    })

    self._default_profile = 'default'

    if ((BHelperDB == nil) or (type(BHelperDB) ~= 'table')) then BHelperDB = {} end
    if ((BHelperDB.selected_profiles == nil) or (type(BHelperDB.selected_profiles) ~= 'table')) then
        BHelperDB.selected_profiles = {self._default_profile, self._default_profile}
    end
end

