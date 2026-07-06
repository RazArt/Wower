HelloWorld = CreateFrame('Frame', nil, UIParent)
HelloWorld.name = 'HelloWorld'

HelloWorld:SetScript('OnEvent', function(self, event, ...)
    self[event](self, ...)
end)

HelloWorld:RegisterEvent("PLAYER_LOGIN")
function HelloWorld:PLAYER_LOGIN()
    self.base_frame = CreateFrame('Frame', nil, self)
    self.base_frame.frames = {}

    self.variables = {}
    self.variables['classes'] = {
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

    self:SetScale(0.79)
    self.base_frame:SetSize(101, 1)
    self.base_frame:SetFrameStrata('tooltip')
    self.base_frame:SetPoint('topleft', UIParent, 0, 0)

    local frames = self.base_frame.frames
    for i = 0, 100 do
        frames[i] = CreateFrame('Frame', nil, self.base_frame)
        frames[i]:SetSize(1, 1)
        frames[i]:SetFrameStrata('tooltip')
        frames[i]:SetPoint('topleft', i, 0)
        frames[i].texture = frames[i]:CreateTexture(nil, 'tooltip')
        frames[i].texture:SetAllPoints(frames[i])
        frames[i].texture:SetTexture(0, 1, 0, 1)
        frames[i]:Hide()
    end

    frames[0]:Show()
    if (self:get_player_name() ~= 'Колотая') then
        self.base_frame.frames[0].texture:SetTexture(self:get_player_class() / 255,
                                                     self.get_player_spec() / 255, 0)

        local func = 'rotation_' .. self:get_player_class() .. '_' .. self.get_player_spec()
        if (self[func .. '_init'] ~= nil) then self[func .. '_init'](self) end
        if (self[func] ~= nil) then self:SetScript('OnUpdate', self[func]) end
    else
        self.base_frame.frames[0].texture:SetTexture(50 / 255, 1 / 255, 0)

        if (self['trade_init'] ~= nil) then self['trade_init'](self) end
        if (self['trade'] ~= nil) then self:SetScript('OnUpdate', self['trade']) end
    end

end

function HelloWorld:show()
    self.base_frame:Show()
end
function HelloWorld:hide()
    self.base_frame:Hide()
end

function HelloWorld:check_chat_editbox()
    if ((ACTIVE_CHAT_EDIT_BOX ~= nil) and (self.visible)) then
        self.visible = false
        self:hide()
        return false
    elseif ((ACTIVE_CHAT_EDIT_BOX == nil) and (not self.visible)) then
        self.visible = true
        self:show()
        return true
    end
end

function HelloWorld:frames(pos)
    return self.base_frame.frames[pos]
end

function HelloWorld:get_player_name()
    return (select(1, UnitName('player')))
end

function HelloWorld:get_player_class()
    return self.variables.classes[(select(2, UnitClass('player'))):lower()]
end

function HelloWorld:get_player_spec()
    return GetSpecialization('player')
end

function HelloWorld:get_player_level()
    return UnitLevel('player')
end

function HelloWorld:get_health_on_percent()
    return UnitHealth('player') / UnitHealthMax('player') * 100
end

function HelloWorld:get_mana_on_percent()
    return UnitMana('player') / UnitManaMax('player') * 100
end

function HelloWorld:get_health()
    return UnitHealth('player')
end

function HelloWorld:get_mana()
    return UnitMana('player')
end

function HelloWorld:get_power()
    return UnitPower('player')
end

function HelloWorld:get_combo_points()
    return GetComboPoints('player', 'target')
end

function HelloWorld:get_spell_cooldown(spellname)
    local start, duration, _ = GetSpellCooldown(spellname);
    local cd_time = start + duration - GetTime()

    if cd_time < 0 then
        return 0
    else
        return cd_time
    end
end

function HelloWorld:can_cast(spellname)
    if (not (select(1, IsUsableSpell(spellname)))) then return false end
    if (UnitCastingInfo('player')) then return false end
    if (UnitChannelInfo('player')) then return false end
    if (self:get_spell_cooldown(spellname) > 0) then return false end
    return true
end

function HelloWorld:can_cast_on_enemy(spellname)
    if (not self:can_cast(spellname)) then return false end
    if (UnitIsDeadOrGhost('target')) then return false end
    if (UnitCanAttack('player', 'target') ~= 1) then return false end
    if (IsSpellInRange(spellname, 'target') ~= 1) then return false end
    return true
end

function HelloWorld:can_cast_on_point(spellname)
    if (not self:can_cast(spellname)) then return false end
    if (UnitExists('mouseover') ~= 1) then return false end
    return true
end

function HelloWorld:get_ememy_debuff_time(spellname, player)
    player = player or false

    _, _, _, _, _, _, expirationTime, unitCaster = UnitDebuff('target', spellname)

    if ((player) and (unitCaster ~= 'player')) then return 0 end
    if (expirationTime == nil) then return 0 end

    return expirationTime - GetTime()
end

function HelloWorld:get_player_buff_time(spellname)
    player = player or false

    _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff('player', spellname)

    if ((player) and (unitCaster ~= 'player')) then return 0 end
    if (expirationTime == nil) then return 0 end

    return expirationTime - GetTime()
end

function HelloWorld:is_enemy_cast()
    if (UnitCastingInfo('target')) then return true end
    if (UnitChannelInfo('target')) then return true end
    return false
end

function HelloWorld:general_update()
    self:check_chat_editbox()

    if (not self.visible) then return false end

    if (not UnitExists('target')) then
        self:frames(1):Show()
    else
        self:frames(1):Hide()
    end

    if ((self:get_health_on_percent() < 10) and (GetItemCount(33447) > 0) and
        ((select(1, GetItemCooldown(33447))) == 0)) then
        self:frames(2):Show()
    else
        self:frames(2):Hide()
    end

    if ((self:get_mana_on_percent() < 10) and (GetItemCount(33448) > 0) and
        ((select(1, GetItemCooldown(33448))) == 0)) then
        self:frames(3):Show()
    else
        self:frames(3):Hide()
    end

    return true
end

function HelloWorld:rotation_3_1_init()
    self.variables['mana_regeneration'] = false
end

function HelloWorld:rotation_3_1()
    if (not self:general_update()) then return false end

    if ((self:get_mana_on_percent('player') < 20) and (not self.variables['mana_regeneration'])) then
        self.variables['mana_regeneration'] = true
    elseif ((self:get_mana_on_percent('player') > 60) and (self.variables['mana_regeneration'])) then
        self.variables['mana_regeneration'] = false
    end

    if ((self.variables['mana_regeneration'] == false) and
        (self:get_player_buff_time('Дух дракондора') == 0) and
        (self:get_player_buff_time('Дух дикой природы') == 0) and
        (self:can_cast('Дух дракондора'))) then
        self:frames(10):Show()
    else
        self:frames(10):Hide()
    end

    if ((self.variables['mana_regeneration'] == true) and
        (self:get_player_buff_time('Дух гадюки') == 0) and
        (self:get_player_buff_time('Дух дикой природы') == 0) and
        (self:can_cast('Дух гадюки'))) then
        self:frames(11):Show()
    else
        self:frames(11):Hide()
    end

    if ((self:get_player_buff_time('Аура меткого выстрела') == 0) and
        (self:can_cast('Аура меткого выстрела'))) then
        self:frames(12):Show()
    else
        self:frames(12):Hide()
    end

    if (self:is_enemy_cast() and self:can_cast_on_enemy('Глушащий выстрел')) then
        self:frames(13):Show()
    else
        self:frames(13):Hide()
    end

    if ((self:get_ememy_debuff_time('Метка охотника') == 0) and
        (self:can_cast_on_enemy('Метка охотника')) and (IsShiftKeyDown() ~= 1)) then
        self:frames(14):Show()
    else
        self:frames(14):Hide()
    end

    if ((self.variables['mana_regeneration'] == false) and
        (self:get_ememy_debuff_time('Укус змеи', true) == 0) and
        (self:can_cast_on_enemy('Укус змеи'))) then
        self:frames(15):Show()
    else
        self:frames(15):Hide()
    end

    if ((self.variables['mana_regeneration'] == true) and
        (self:get_ememy_debuff_time('Укус гадюки', true) == 0) and
        (self:can_cast_on_enemy('Укус гадюки'))) then
        self:frames(16):Show()
    else
        self:frames(16):Hide()
    end

    if (self:can_cast_on_enemy('Убийственный выстрел')) then
        self:frames(17):Show()
    else
        self:frames(17):Hide()
    end

    if (self:can_cast_on_enemy('Выстрел химеры')) then
        self:frames(18):Show()
    else
        self:frames(18):Hide()
    end

    if (self:can_cast_on_enemy('Прицельный выстрел')) then
        self:frames(19):Show()
    else
        self:frames(19):Hide()
    end

    if (self:can_cast_on_enemy('Чародейский выстрел')) then
        self:frames(20):Show()
    else
        self:frames(20):Hide()
    end

    if (self:can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        self:frames(21):Show()
    else
        self:frames(21):Hide()
    end

    if (self:can_cast_on_enemy('Верный выстрел')) then
        self:frames(22):Show()
    else
        self:frames(22):Hide()
    end

    if (self:can_cast_on_point('Град стрел')) then
        self:frames(23):Show()
    else
        self:frames(23):Hide()
    end
    -- /cast [@target,help,nodead][@focus,help,nodead][@targettarget,help,nodead] Маленькие хитрости
end

function HelloWorld:rotation_4_1()
    if (not self:general_update()) then return false end

    if (self:is_enemy_cast() and self:can_cast_on_enemy('Пинок')) then
        self:frames(10):Show()
    else
        self:frames(10):Hide()
    end

    if ((self:get_player_buff_time('Мясорубка') < 2) and
        (self:can_cast('Мясорубка')) and (self:get_combo_points() > 3)) then
        self:frames(11):Show()
    else
        self:frames(11):Hide()
    end

    if ((self:get_ememy_debuff_time('Рваная рана', true) == 0) and
        (self:can_cast('Рваная рана')) and (self:get_combo_points() > 4)) then
        self:frames(12):Show()
    else
        self:frames(12):Hide()
    end

    if ((self:get_ememy_debuff_time('Рваная рана', true) > 4) and
        (self:can_cast('Потрошение')) and (self:get_combo_points() > 3)) then
        self:frames(13):Show()
    else
        self:frames(13):Hide()
    end

    if (self:can_cast('Коварный удар')) then
        self:frames(14):Show()
    else
        self:frames(14):Hide()
    end

    if (self:can_cast('Веер клинков')) then
        self:frames(15):Show()
    else
        self:frames(15):Hide()
    end
end
