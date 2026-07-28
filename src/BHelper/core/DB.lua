BHelper.DB = {}

function BHelper.DB:get_DB()
    local profile = self:get_current_profile()
    if (profile == nil) then return nil end

    if (BHelperDB[self:get_current_profile()] == nil) then self:create_profile(profile) end

    return BHelperDB[self:get_current_profile()]
end

function BHelper.DB:get_current_profile()
    if (BHelperDB.selected_profiles[BHelper:get_player_spec()] ~= nil) then
        return BHelperDB.selected_profiles[BHelper:get_player_spec()]
    else
        return nil
    end
end

function BHelper.DB:create_profile(profile)
    if (BHelperDB[profile] ~= nil) then return false end

    BHelperDB[profile] = {}
    BHelperDB[profile].module = BHelper:get_player_class()
    BHelperDB[profile].action = 'rotation_single'
    BHelperDB[profile].type = 'battle' -- 'heal' 'tank' 'craft'

    return true
end

function BHelper.DB:init()
    setmetatable(BHelper.DB, {
        __call = function(self)
            return self:get_DB()
        end
    })

    if (BHelperDB == nil) then
        BHelperDB = {}
        BHelperDB.selected_profiles = {'main', 'main'}
        self:create_profile('main')
    end
end
BHelper.DB:init()
