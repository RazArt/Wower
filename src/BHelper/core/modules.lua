BHelper.modules = {}

function BHelper.modules:module(profiles)
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

function BHelper.modules:init()
    self.auction = self:module({'common'})
    self.crafting = self:module({'common'})
    self.mailbox = self:module({'common'})

    self.deathknight = self:module({'default', 'damage', 'adk'})
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
