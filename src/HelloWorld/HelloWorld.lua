HelloWorld:register_event('PLAYER_LOGIN')
function HelloWorld:PLAYER_LOGIN()
    HelloWorld()
    Keystroke()

    HelloWorld._debug = false
    HelloWorld:get_route()

    CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
        HelloWorld:_update(elapsed)
        Keystroke:_update(elapsed)
    end)

    self.state_frame = CreateFrame('Frame')
    self.state_frame:SetSize(50, 50)
    self.state_frame:SetFrameStrata('tooltip')
    self.state_frame:SetPoint('center', UIParent, 'center', 0, -160)
    self.state_frame.texture = self.state_frame:CreateTexture(nil, 'tooltip')
    self.state_frame.texture:SetAllPoints(self.state_frame)
    self.state_frame.texture:SetTexture('Interface\\AddOns\\HelloWorld\\textures\\warning.tga')
    self.state_frame:Hide()
end

function HelloWorld:get_route()
    -- if (self:get_player_name() == 'Колотая') then
    --     self:set_route('craft')
    --     self.craft:stop()
    -- else
    --     self:set_route('war')
    -- end
    self:set_route('war')
end

function HelloWorld:get_player_name()
    return (select(1, UnitName('player')))
end
