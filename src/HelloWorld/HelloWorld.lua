HelloWorld = module('HelloWorld')

HelloWorld.event_frame = CreateFrame('Frame', nil, UIParent)
HelloWorld.event_frame:SetScript('OnEvent', function(self, event, ...)
    HelloWorld[event](HelloWorld, ...)
end)
HelloWorld.event_frame:SetScript('OnUpdate', function(self, elapsed)
    HelloWorld:update_general(elapsed)
end)
HelloWorld.event_frame:RegisterEvent("PLAYER_LOGIN")

function HelloWorld:PLAYER_LOGIN()
    HelloWorld()
end

function HelloWorld:init()
    self.timers = {}
    -- self.runing = true
    self.runing = false

    self.base_frame = CreateFrame('Frame', nil, UIParent)
    self.base_frame:SetScale(0.79)
    self.base_frame:SetSize(3, 1)
    self.base_frame:SetFrameStrata('tooltip')
    self.base_frame:SetPoint('topleft', UIParent, 0, 0)
    self.base_frame.frames = {}
    for i = 0, 2 do
        self.base_frame.frames[i] = CreateFrame('Frame', nil, self.base_frame)
        self.base_frame.frames[i]:SetSize(1, 1)
        self.base_frame.frames[i]:SetFrameStrata('tooltip')
        self.base_frame.frames[i]:SetPoint('topleft', i, 0)
        self.base_frame.frames[i].texture = self.base_frame.frames[i]:CreateTexture(nil, 'tooltip')
        self.base_frame.frames[i].texture:SetAllPoints(self.base_frame.frames[i])
    end
    self.base_frame.frames[0].texture:SetTexture(31 / 255, 11 / 255, 12 / 255)
    self.base_frame:Hide()

    if (self:get_player_name() ~= 'Колотая') then
        self:set_action('war')
    else
        self:set_action('craft')
    end
end

function HelloWorld:update_general(elapsed)
    if (not self.runing) then return false end
    if (ACTIVE_CHAT_EDIT_BOX ~= nil) then return false end

    self:check_timers(elapsed)
    self:update()
end

function HelloWorld:can_work()

    return true
end

function HelloWorld:check_timers(elapsed)
    for i = 1, #self.timers do
        if (self.timers[i] ~= nil) then
            self.timers[i].time = self.timers[i].time + elapsed
            if self.timers[i].time >= self.timers[i].count then
                self.timers[i].func()
                self.timers[i].time = 0
                if (not self.timers[i].repeating) then table.remove(self.timers, i) end
            end
        end
    end
end

function HelloWorld:create_timer(count, func, repeating, name)
    local name = name or false
    local repeating = repeating or false

    if (name ~= false) then
        for i = 1, #self.timers do
            if (self.timers[i].name == name) then table.remove(self.timers, i) end
        end
    end

    table.insert(self.timers,
                 {time = 0, count = count, func = func, repeating = repeating, name = name})
end

function HelloWorld:show(key, shift, ctrl, alt)
    key = key or 0
    shift = shift or 0
    ctrl = ctrl or 0
    alt = alt or 0

    self:hide()
    if (key <= 255) then
        self.base_frame.frames[1].texture:SetTexture(key / 255, 0, 0)
    else
        self.base_frame.frames[1].texture:SetTexture(255, (key - 255) / 255, 0)
    end
    self.base_frame.frames[2].texture:SetTexture(shift / 255, ctrl / 255, alt / 255)
    self.base_frame:Show()

    HelloWorld:create_timer(0.05, function()
        self.base_frame:Hide()
    end, false, 'key_frame')
end

function HelloWorld:hide()
    self.base_frame:Hide()
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
