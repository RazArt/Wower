function Keystroke:init(name)
    self._debug = false
    self._runing = true
    self.base_frame = CreateFrame('Frame')
    self.base_frame:SetScale(0.71)
    self.base_frame:SetSize(9, 1)
    self.base_frame:SetFrameStrata('tooltip')
    self.base_frame:SetPoint('topleft', UIParent, 0, 0)
    self.base_frame.frames = {}
    for i = 0, 5 do
        self.base_frame.frames[i] = CreateFrame('Frame', nil, self.base_frame)
        self.base_frame.frames[i]:SetSize(1, 1)
        self.base_frame.frames[i]:SetFrameStrata('tooltip')
        self.base_frame.frames[i]:SetPoint('topleft', i, 0)
        self.base_frame.frames[i].texture = self.base_frame.frames[i]:CreateTexture(nil, 'tooltip')
        self.base_frame.frames[i].texture:SetAllPoints(self.base_frame.frames[i])
    end
    self.base_frame.frames[0].texture:SetTexture(31 / 255, 11 / 255, 12 / 255)
    self.base_frame.frames[3].texture:SetTexture(31 / 255, 11 / 255, 12 / 255)
    self.base_frame:Hide()
end

function Keystroke:base_show(num, key, click, ctrl, alt, shift)
    if (ACTIVE_CHAT_EDIT_BOX ~= nil) then return end

    key = key or false
    click = click or false
    ctrl = ctrl or false
    alt = alt or false
    shift = shift or false

    if (key ~= falae) and (key <= 255) then
        self.base_frame.frames[1].texture:SetTexture(key / 255, 0, (click and 1 or 0) / 255)
    elseif (key ~= falae) and (key > 255) then
        self.base_frame.frames[1].texture:SetTexture(255, (key - 255) / 255,
                                                     (click and 1 or 0) / 255)
    end
    self.base_frame.frames[2].texture:SetTexture((ctrl and 1 or 0) / 255, (alt and 1 or 0) / 255,
                                                 (shift and 1 or 0) / 255)
    self.base_frame:Show()

    self:create_timer(0.05, function()
        self.base_frame.frames[1].texture:SetTexture(0, 0, 0)
        self.base_frame.frames[2].texture:SetTexture(0, 0, 0)
        self.base_frame:Hide()
    end, 'hide')
end

function Keystroke:show_2(key, click, ctrl, alt, shift)
    if (ACTIVE_CHAT_EDIT_BOX ~= nil) then return end

    key = key or false
    click = click or false
    ctrl = ctrl or false
    alt = alt or false
    shift = shift or false

    if (key ~= falae) and (key <= 255) then
        self.base_frame.frames[3].texture:SetTexture(key / 255, 0, (click and 1 or 0) / 255)
    elseif (key ~= falae) and (key > 255) then
        self.base_frame.frames[3].texture:SetTexture(255, (key - 255) / 255,
                                                     (click and 1 or 0) / 255)
    end
    self.base_frame.frames[4].texture:SetTexture((ctrl and 1 or 0) / 255, (alt and 1 or 0) / 255,
                                                 (shift and 1 or 0) / 255)
    self.base_frame:Show()

    self:create_timer(0.05, function()
        self.base_frame.frames[3].texture:SetTexture(0, 0, 0)
        self.base_frame.frames[4].texture:SetTexture(0, 0, 0)
        self.base_frame:Hide()
    end, 'hide')
end
