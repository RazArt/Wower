function Keystroke:init(name, parent)
    self._debug = false

    self._base_frame = CreateFrame('Frame')
    self._base_frame:SetScale(0.71)
    self._base_frame:SetSize(3, 1)
    self._base_frame:SetFrameStrata('tooltip')
    self._base_frame:SetPoint('topleft', UIParent, 0, 0)

    self._base_frame.texture = self._base_frame:CreateTexture(nil, 'tooltip')
    self._base_frame.texture:SetAllPoints(self._base_frame)
    self._base_frame.texture:SetTexture(0, 1, 0)

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
end

function Keystroke:show(key, click, shift, ctrl, alt)
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
    self:create_timer(0.05, function()
        self._base_frame:Hide()
    end, false, 'hide')
end
