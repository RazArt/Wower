HelloWorld = module('HelloWorld')

HelloWorld:register_event("PLAYER_LOGIN")
function HelloWorld:PLAYER_LOGIN()
    self()
end

function HelloWorld:init()
    self._keystroke_timer = 0

    self._base_frame = CreateFrame('Frame', nil, UIParent)
    self._base_frame:SetScale(0.79)
    self._base_frame:SetSize(3, 1)
    self._base_frame:SetFrameStrata('tooltip')
    self._base_frame:SetPoint('topleft', UIParent, 0, 0)
    self._base_frame.frames = {}
    for i = 0, 2 do
        self._base_frame.frames[i] = CreateFrame('Frame', nil, self._base_frame)
        self._base_frame.frames[i]:SetSize(1, 1)
        self._base_frame.frames[i]:SetFrameStrata('tooltip')
        self._base_frame.frames[i]:SetPoint('topleft', i, 0)
        self._base_frame.frames[i].texture =
            self._base_frame.frames[i]:CreateTexture(nil, 'tooltip')
        self._base_frame.frames[i].texture:SetAllPoints(self._base_frame.frames[i])
    end
    self._base_frame.frames[0].texture:SetTexture(31 / 255, 11 / 255, 12 / 255)
    self._base_frame:Hide()

    if (self:get_player_name() ~= 'Колотая') then
        self:set_route('war')
    else
        self:set_route('craft')
    end

    self._event_frame:SetScript('OnUpdate', function(self, elapsed)
        self._parent:update(elapsed)
    end)
end

function HelloWorld:update(elapsed)
    self._keystroke_timer = self._keystroke_timer + elapsed
    if ((self._keystroke_timer >= 0.01) and (self._base_frame:IsVisible())) then
        self._base_frame:Hide()
    end

    if (ACTIVE_CHAT_EDIT_BOX ~= nil) then return false end

    self:_update(elapsed)
end

function HelloWorld:keystroke(key, click, shift, ctrl, alt)
    key = key or 0
    shift = shift or 0
    ctrl = ctrl or 0
    alt = alt or 0

    if (key <= 255) then
        self._base_frame.frames[1].texture:SetTexture(key / 255, 0, click / 255)
    else
        self._base_frame.frames[1].texture:SetTexture(255, (key - 255) / 255, click / 255)
    end
    self._base_frame.frames[2].texture:SetTexture(shift / 255, ctrl / 255, alt / 255)
    self._base_frame:Show()
    self._keystroke_timer = 0
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

    return classes[(select(2, UnitClass('player'))):lower()]
end

function HelloWorld:get_player_spec()
    return GetSpecialization('player')
end

function HelloWorld:get_player_level()
    return UnitLevel('player')
end

-- -- function printTable(tbl, indent)
-- --     if not indent then indent = 0 end
-- --     local tab_str = string.rep("○", indent)

-- --     for k, v in pairs(tbl) do
-- --         if type(v) == "table" then
-- --             if (k ~= 'parent') then
-- --                 print(tab_str, "[" .. k .. "]")
-- --                 printTable(v, indent + 1)
-- --             else
-- --                 print(tab_str, "[" .. k .. "] = " .. tostring(v.name))
-- --             end
-- --         else
-- --             print(tab_str, "[" .. k .. "] = " .. tostring(v))
-- --         end
-- --     end
-- -- end
