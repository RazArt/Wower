HelloWorld:register_event('PLAYER_LOGIN')
function HelloWorld:PLAYER_LOGIN()
    HelloWorld()
    Keystroke()

    self.player.name = self:get_player_name()
    self.player.class = self:get_player_class()
    self.player.spec = self:get_player_spec()
    self.player.level = self:get_player_level()

    self:get_route()

    self.state_frame = CreateFrame('Frame')
    self.state_frame:SetSize(50, 50)
    self.state_frame:SetFrameStrata('tooltip')
    self.state_frame:SetPoint('center', UIParent, 'center', 0, -160)
    self.state_frame.texture = self.state_frame:CreateTexture(nil, 'tooltip')
    self.state_frame.texture:SetAllPoints(self.state_frame)
    self.state_frame.texture:SetTexture('Interface\\AddOns\\HelloWorld\\textures\\warning.tga')
    self.state_frame:Hide()

    CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
        HelloWorld:_update(elapsed)
        Keystroke:_update(elapsed)
    end)

end

function HelloWorld:get_route()
    if (self.player.name == 'Колотая') then
        self:set_route('craft')
        self.craft:stop()
    else
        self:set_route('war')
    end
    -- self:set_route('war')
end

function HelloWorld:get_player_name()
    return (select(1, UnitName('player')))
end

function HelloWorld:get_player_class()
    local classes = {
        warrior = '1',
        paladin = '2',
        hunter = '3',
        rogue = '4',
        priest = '5',
        deathknight = '6',
        shaman = '7',
        mage = '8',
        warlock = '9',
        druid = '11'
    }
    return (select(2, UnitClass('player'))):lower()
end

function HelloWorld:get_player_spec()
    return GetSpecialization('player')
end

function HelloWorld:get_player_level()
    return UnitLevel('player')
end
