BHelper.modules = {}

function BHelper.modules:module(profiles)
    profiles = profiles or {}
    local obj = {}

    obj.common = {}

    for _, profile in pairs(profiles) do
        obj[profile] = {}
        local profile = obj[profile]
        profile._event_frame = CreateFrame('Frame')
        profile._event_frame:SetScript('OnEvent', function(_, event, ...)
            profile[event](profile, ...)
        end)

        function profile:register_event(event)
            self._event_frame:RegisterEvent(event)
        end
    end

    function obj:_init()
        BHelper.core:print('_init')

        local module = BHelper.core.module:get()
        local profile = BHelper.core.profile:get()

        if ((module) and (module.init)) then module:init() end
        if ((profile) and (profile.init)) then profile:init() end

        if ((profile) and (profile.settings.type ~= 'heal') and (profile.settings.type ~= 'craft')) then
            BHelper.keybinds:bind_macro('Target')
            BHelper.keybinds:bind_macro('Stop')
            BHelper.keybinds:bind_macro('PetAttack')
            BHelper.keybinds:bind_macro('PetFollow')
        end
    end

    function obj:_macros()
        BHelper.core:print('_macros')

        local module = BHelper.core.module:get()
        local profile = BHelper.core.profile:get()

        if ((module) and (module.macros)) then module:macros() end
        if ((profile) and (profile.macros)) then profile:macros() end
    end

    function obj:_update()
        local stop_flag = false
        local module = BHelper.core.module:get()
        local profile = BHelper.core.profile:get()
        local action = BHelper.core.action:get()

        if (SpellIsTargeting()) then return BHelper.keybinds:show_click() end

        if ((not stop_flag) and (profile.settings.type ~= 'heal') and
            (profile.settings.type ~= 'craft') and (not BHelper.player:can_target_attack())) then
            stop_flag = BHelper.keybinds:show_macro('Target')
        end
        if ((not stop_flag) and (module) and (module.update)) then
            stop_flag = module:update()
        end
        if ((not stop_flag) and (profile) and (profile.update)) then
            stop_flag = profile:update()
        end
        if ((not stop_flag) and action) then action(profile) end
    end
    return obj
end

function BHelper.modules:init()
    self.auction = self:module()
    self.crafting = self:module()
    self.mailbox = self:module()

    self.deathknight = self:module({'default'})
    self.druid = self:module({'default', 'balance'})
    self.hunter = self:module({'default'})
    self.mage = self:module({'default'})
    self.paladin = self:module({'default', 'proto'})
    self.priest = self:module({'default'})
    self.rogue = self:module({'default'})
    self.shaman = self:module({'default'})
    self.warlock = self:module({'default'})
    self.warrior = self:module({'default', 'proto'})
end
BHelper.modules:init()
