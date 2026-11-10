BHelper.icons = {}

local base = CreateFrame('Frame')
local groups = {}
local icons = {}

function BHelper.icons:add(name, width, height, texture)
    local icon = CreateFrame('Frame', nil, base)
    local base_width, base_height = base:GetSize()

    base_width = base_width + width
    if (base_height < height) then base_height = height end
    base:SetSize(base_width, base_height)

    icon:SetSize(width, height)
    icon:SetFrameStrata('tooltip')

    if (#icons > 0) then
        icon:SetPoint('bottomleft', icons[#icons], 'bottomright')
    else
        icon:SetPoint('bottomleft', base, 'bottomleft')
    end

    icon.texture = icon:CreateTexture(nil, 'tooltip')
    icon.texture:SetAllPoints(icon)
    icon.texture:SetTexture(texture)

    table.insert(icons, icon)
    print(#icons)
end

function BHelper.icons:init()
    -- base:SetSize(0, 0)
    -- base:SetFrameStrata('tooltip')
    -- base:SetPoint('center', UIParent, 'center', 0, -160)
    -- base.texture = base:CreateTexture(nil, 'tooltip')
    -- base.texture:SetAllPoints(base)
    -- base.texture:SetTexture(0, 1, 0)

    -- base:SetMovable(true)
    -- base:EnableMouse(true)
    -- base:RegisterForDrag("LeftButton")
    -- base:SetScript("OnDragStart", function()
    --     base:StartMoving()
    -- end)
    -- base:SetScript("OnDragStop", function()
    --     base:StopMovingOrSizing()
    -- end)
    -- base:Hide()
end
-- function BHelper.icons:init()
--     self.state_frame = CreateFrame('Frame')
--     self.state_frame:SetSize(50, 50)
--     self.state_frame:SetFrameStrata('tooltip')
--     self.state_frame:SetPoint('center', UIParent, 'center', 0, -160)
--     self.state_frame.texture = self.state_frame:CreateTexture(nil, 'tooltip')
--     self.state_frame.texture:SetAllPoints(self.state_frame)
--     self.state_frame.texture:SetTexture('Interface\\AddOns\\BHelper\\textures\\warning.tga')
--     self.state_frame:Hide()
-- end
BHelper.icons:init()
