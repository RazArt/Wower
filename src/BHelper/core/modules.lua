BHelper.modules = {}

local function module_init(profiles)
    profiles = profiles or {'default'}
    local obj = {}

    for i = 1, #profiles do
        obj[profiles[i]] = {}
        local profile = obj[profiles[i]]

        profile._event_frame = CreateFrame('Frame')
        profile._event_frame:SetScript('OnEvent', function(_, event, ...)
            profile[event](profile, ...)
        end)
        function profile:register_event(event)
            profile._event_frame:RegisterEvent(event)
        end
    end

    return obj
end

local function init()
    BHelper.modules.deathknight = module_init({'default', 'damage'})
    BHelper.modules.druid = module_init({'default', 'balance'})
    BHelper.modules.hunter = module_init()
    BHelper.modules.mage = module_init()
    BHelper.modules.paladin = module_init({'default', 'proto'})
    BHelper.modules.priest = module_init()
    BHelper.modules.rogue = module_init()
    BHelper.modules.shaman = module_init()
    BHelper.modules.warlock = module_init()
    BHelper.modules.warrior = module_init({'default', 'proto'})

    BHelper.modules.auction = module_init()
    BHelper.modules.crafting = module_init()
    BHelper.modules.mailbox = module_init()
end
init()
