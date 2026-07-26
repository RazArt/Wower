BHelper:register_event('PLAYER_LOGIN')
function BHelper:PLAYER_LOGIN()
    BHelper()
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
    self.state_frame.texture:SetTexture('Interface\\AddOns\\BHelper\\textures\\warning.tga')
    self.state_frame:Hide()

    CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
        BHelper:_update(elapsed)
        Keystroke:_update(elapsed)
    end)

end

function BHelper:get_route()
    if (self.player.name == 'Колотая') then
        self:set_route('craft')
        self.craft:stop()
    else
        self:set_route('war')
    end
    -- self:set_route('war')
end

function BHelper:get_player_name()
    return (select(1, UnitName('player')))
end

function BHelper:get_player_class()
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

function BHelper:get_player_spec()
    return GetSpecialization('player')
end

function BHelper:get_player_level()
    return UnitLevel('player')
end

local function commands(msg, editbox)
    msg = msg .. '\n'
    local args = {}

    for arg in string.gmatch(msg, '([^%s]+)') do table.insert(args, arg) end

    if ((args[1] == 'toggle') or (#args == 0)) then
        BHelper:toggle()
    elseif (args[1] == 'start') then
        BHelper:start()
    elseif (args[1] == 'stop') then
        BHelper:stop()
    else
        BHelper:print('Неизвестная команда')
    end
end

SLASH_BHELPER1, SLASH_BHELPER2 = '/bhelper', '/bh'
SlashCmdList["BHELPER"] = commands
