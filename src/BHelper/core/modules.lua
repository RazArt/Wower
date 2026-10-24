BHelper.modules = {}

local auras = {}
local core = {}
local keybinds = {}
local macros = {}
local modules = {}
local pet = {}
local player = {}
local tables = {}
local target = {}
local threat = {}
local timers = {}

function BHelper.modules:namespace_init()
    auras = BHelper.auras
    core = BHelper.core
    keybinds = BHelper.keybinds
    macros = BHelper.macros
    modules = BHelper.modules
    pet = BHelper.pet
    player = BHelper.player
    tables = BHelper.tables
    target = BHelper.target
    threat = BHelper.threat
    timers = BHelper.timers
end

function BHelper.modules:module(profiles)
    profiles = profiles or {}
    local obj = {}

    obj.common = {}

    for _, profile in pairs(profiles) do
        obj[profile] = {}
        local profile = obj[profile]

        profile.settings = {}
        profile.vars = {}

        profile._event_frame = CreateFrame('Frame')
        profile._event_frame:SetScript('OnEvent', function(_, event, ...)
            profile[event](profile, ...)
        end)

        function profile:register_event(event)
            profile._event_frame:RegisterEvent(event)
        end
    end

    function obj:_init()
        core:print('_init')

        if ((core.module:get()) and (core.module:get().init)) then core.module:get():init() end
        if ((core.profile:get()) and (core.profile:get().init)) then core.profile:get():init() end

        if ((core.profile:get()) and (core.profile:get().settings.type ~= 'heal') and
            (core.profile:get().settings.type ~= 'craft')) then
            keybinds:bind_macro('Target')
            keybinds:bind_macro('Stop')
            keybinds:bind_macro('PetAttack')
            keybinds:bind_macro('PetFollow')
        end
    end

    function obj:_macros()
        core:print('_macros')

        if ((core.module:get()) and (core.module:get().macros)) then core.module:get():macros() end
        if ((core.profile:get()) and (core.profile:get().macros)) then core.profile:get():macros() end
    end

    function obj:_execute()
        local stop_flag = false

        if (player:spell_is_targeting()) then keybinds:show_click() end

        if ((not stop_flag) and (core.profile:get().settings.type == 'battle')) then
            if (not player:can_target_attack()) then
                stop_flag = keybinds:show_macro('Target')
            elseif ((pet:check_control()) and (pet:can_target_attack())) then
                keybinds:show_pet('Attack')
            end
        end
        if ((not stop_flag) and (core.module:get()) and (core.module:get().execute)) then
            stop_flag = core.module:get():execute()
        end
        if ((not stop_flag) and (core.profile:get()) and (core.profile:get().execute)) then
            stop_flag = core.profile:get():execute()
        end
        if ((not stop_flag) and (core.action:get())) then core.action:get()(core.profile:get()) end
    end
    return obj
end

function BHelper.modules:init()
    self.auction = self:module()
    self.crafting = self:module()
    self.mailbox = self:module()

    self.deathknight = self:module({'default', 'fdk'})
    self.druid = self:module({'default', 'balance'})
    self.hunter = self:module({'default'})
    self.mage = self:module({'default'})
    self.paladin = self:module({'default', 'proto'})
    self.priest = self:module({'default'})
    self.rogue = self:module({'default'})
    self.shaman = self:module({'default'})
    self.warlock = self:module({'default'})
    self.warrior = self:module({'default', 'proto', 'proto_farm'})
end
BHelper.modules:init()
