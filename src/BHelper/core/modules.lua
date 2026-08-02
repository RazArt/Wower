BHelper.modules = {}

function BHelper.modules:module(profiles)
    profiles = profiles or {}
    local obj = {}

    obj.common = {}
    for _, profile in pairs(profiles) do obj[profile] = {} end

    function obj:_init()
        BHelper:print('_init')
        self.vars = BHelper.DB:get_vars()

        local profile_name = BHelper.DB:get_profile_name()
        if ((self['common']) and (self['common']['init'])) then self['common'].init(self) end
        if ((self[profile_name]) and (self[profile_name]['init'])) then
            self[profile_name].init(self)
        end
    end

    function obj:_macros()
        BHelper:print('_macros')
        local profile_name = BHelper.DB:get_profile_name()
        if ((self['common']) and (self['common']['macros'])) then self['common'].macros(self) end
        if ((self[profile_name]) and (self[profile_name]['macros'])) then
            self[profile_name].macros(self)
        end
    end

    function obj:_update()

        local stop_flag = false
        local profile_name = BHelper.DB:get_profile_name()
        if ((not stop_flag) and (self['common']) and (self['common']['update'])) then
            stop_flag = self['common']:update(self)
        end
        if ((not stop_flag) and (self[profile_name]) and (self[profile_name]['update'])) then
            stop_flag = self[profile_name].update(self)
        end
        if ((BHelper.DB().type ~= 'heal') and (BHelper.DB().type ~= 'craft') and
            (not BHelper:can_attack())) then
            stop_flag = BHelper.keybinds:show_macro('Цель')
        end
        local action = BHelper:get_action()
        if ((not stop_flag) and (action)) then stop_flag = action(self) end
    end

    setmetatable(obj, {
        __index = function(self, name)
            if ((name ~= '') and (name ~= 'vars') and (BHelperDB ~= nil)) then
                local profile_name = BHelper.DB:get_profile_name()
                if ((rawget(self, profile_name)) and (rawget(self[profile_name], name))) then
                    return self[profile_name][name]
                end
                if ((rawget(self, 'common')) and (rawget(self['common'], name))) then
                    return self['common'][name]
                end
                return nil
            end
            return nil
        end
    })

    return obj
end

function BHelper.modules:init()
    self.auction = self:module()
    self.crafting = self:module()
    self.mailbox = self:module()

    self.deathknight = self:module({'default'})
    self.druid = self:module({'default', 'balance'})
    self.hunter = self:module({'default'})
    self.mage = self:module({'default', 'ffb'})
    self.paladin = self:module({'default'})
    self.priest = self:module({'default'})
    self.rogue = self:module({'default'})
    self.shaman = self:module({'default'})
    self.warlock = self:module({'default'})
    self.warrior = self:module({'default'})
end
BHelper.modules:init()
