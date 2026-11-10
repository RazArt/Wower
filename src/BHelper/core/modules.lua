BHelper.modules = {}

local function module_init(profiles)
    profiles = profiles or {}
    local obj = {}

    for _, profile in pairs(profiles) do
        obj[profile] = {}
        local profile = obj[profile]

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
    BHelper.modules.auction = module_init({'common'})
    BHelper.modules.crafting = module_init({'common'})
    BHelper.modules.mailbox = module_init({'common'})

    BHelper.modules.deathknight = module_init({'default', 'damage', 'adk'})
    BHelper.modules.druid = module_init({'default', 'balance'})
    BHelper.modules.hunter = module_init({'default'})
    BHelper.modules.mage = module_init({'default'})
    BHelper.modules.paladin = module_init({'default', 'proto'})
    BHelper.modules.priest = module_init({'default'})
    BHelper.modules.rogue = module_init({'default'})
    BHelper.modules.shaman = module_init({'default'})
    BHelper.modules.warlock = module_init({'default'})
    BHelper.modules.warrior = module_init({'default', 'proto', 'proto_farm'})
end
init()
