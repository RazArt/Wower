HelloWorld = module('HelloWorld')

HelloWorld.event_frame = CreateFrame('Frame', nil, UIParent)
HelloWorld.event_frame:SetScript('OnEvent', function(self, event, ...)
    HelloWorld[event](HelloWorld, ...)
end)
HelloWorld.event_frame:SetScript('OnUpdate', function(self, elapsed)
    HelloWorld:update(elapsed)
end)
HelloWorld.event_frame:RegisterEvent("PLAYER_LOGIN")

function HelloWorld:PLAYER_LOGIN()
    HelloWorld()
end

function HelloWorld:init()
    self.timers = {}
    self.runing = true
    self.cooldown = false

    self.base_frame = CreateFrame('Frame')
    self.base_frame:SetScale(0.79)
    self.base_frame:SetSize(50, 1)
    self.base_frame:SetFrameStrata('tooltip')
    self.base_frame:SetPoint('topleft', UIParent, 0, 0)
    self.base_frame.frames = {}
    for i = 0, 50 do
        self.base_frame.frames[i] = CreateFrame('Frame', nil, self.base_frame)
        self.base_frame.frames[i]:SetSize(1, 1)
        self.base_frame.frames[i]:SetFrameStrata('tooltip')
        self.base_frame.frames[i]:SetPoint('topleft', i, 0)
        self.base_frame.frames[i].texture = self.base_frame.frames[i]:CreateTexture(nil, 'tooltip')
        self.base_frame.frames[i].texture:SetAllPoints(self.base_frame.frames[i])
        self.base_frame.frames[i].texture:SetTexture(0, 1, 0, 1)
        self.base_frame.frames[i]:Hide()
    end
    self.base_frame.frames[0]:Show()

    self:set_module('craft')
end

function HelloWorld:update(elapsed)
    self:check_chat_editbox()
    if (not self.runing) then return end
    self:check_timers(elapsed)
    if (self.cooldown) then return end
    self[self.module]:update()

end

function HelloWorld:check_timers(elapsed)
    for i = 1, #self.timers do
        if (self.timers[i] ~= nil) then
            self.timers[i].isTime = self.timers[i].isTime + elapsed
            if self.timers[i].isTime >= self.timers[i].count then
                self.timers[i].func()
                self.timers[i].isTime = 0
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
                 {isTime = 0, count = count, func = func, repeating = repeating, name = name})
end

function HelloWorld:check_chat_editbox()
    if ((ACTIVE_CHAT_EDIT_BOX ~= nil) and (self.base_frame:IsVisible())) then
        self:stop()
    elseif ((ACTIVE_CHAT_EDIT_BOX == nil) and (not self.base_frame:IsVisible())) then
        self:start()
    end
end

function HelloWorld:start()
    self.runing = true
    self.base_frame:Show()
end

function HelloWorld:stop()
    self.runing = false
    self.base_frame:Hide()
end

function HelloWorld:show(pos)
    self.base_frame.frames[pos]:Show()
end

function HelloWorld:hide(pos)
    self.base_frame.frames[pos]:Hide()
end

function HelloWorld:get_player_name()
    return (select(1, UnitName('player')))
end

function HelloWorld:change_module_timer()
    self.cooldown = true
    self:create_timer(3, function()
        self.cooldown = false
    end, false, 'general_cooldown')
end

-- function HelloWorld:get_player_class()
--     return self.vars.classes[(select(2, UnitClass('player'))):lower()]
-- end
-- function HelloWorld:get_player_spec()
--     return GetSpecialization('player')
-- end
-- function HelloWorld:get_player_level()
--     return UnitLevel('player')
-- end

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
