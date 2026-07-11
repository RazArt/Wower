function Keystroke:init(name, parent)
    self._debug = false
    self.base_frame = CreateFrame('Frame')
    self.base_frame:SetScale(0.71)
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
end

function Keystroke:show(key, click, shift, ctrl, alt)
    key = key or 0
    click = click or 0
    shift = shift or 0
    ctrl = ctrl or 0
    alt = alt or 0

    if (key <= 255) then
        self.base_frame.frames[1].texture:SetTexture(key / 255, 0, click / 255)
    else
        self.base_frame.frames[1].texture:SetTexture(255, (key - 255) / 255, click / 255)
    end
    self.base_frame.frames[2].texture:SetTexture(shift / 255, ctrl / 255, alt / 255)
    self.base_frame:Show()

    self:create_timer(0.05, function()
        self.base_frame:Hide()
    end, false, 'hide')
end
