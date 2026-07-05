local event_frame = CreateFrame('Frame')
local spell_frames = {}
local player_variables = {}
player_variables['classes'] = {
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

function event_frame:OnEvent(event, ...) 
	self[event](self, ...) 
end

function event_frame:PLAYER_LOGIN()
    for i = 0, 100 do
        spell_frames[i] = CreateFrame('Frame', nil, UIParent)
        spell_frames[i]:SetScale(0.79)
        spell_frames[i]:SetSize(1, 1)
        spell_frames[i]:SetFrameStrata('tooltip')
        spell_frames[i]:SetPoint("TOPLEFT", UIParent, "TOPLEFT", i, 0)
        spell_frames[i].texture = spell_frames[i]:CreateTexture(nil, 'tooltip')
        spell_frames[i].texture:SetAllPoints(spell_frames[i])
        spell_frames[i].texture:SetTexture(0, 0, 0, 0)
        spell_frames[i]:Show()
    end
    spell_frames[0].texture:SetTexture(0, 0)

    player_variables['class'] = tostring(player_variables['classes'][(select(2, UnitClass('player'))):lower()])
    player_variables['spec'] = tostring(GetSpecialization('player'))
    player_variables['level'] = tostring(UnitLevel('player'))
    
    if (string.len(player_variables['class']) > 0) then
        player_variables['function'] = 'rotation_' .. player_variables['class'] .. '_' .. player_variables['spec']
        player_variables['function_init'] = 'rotation_' .. player_variables['class'] .. '_' .. player_variables['spec'] .. '_init'

        spell_frames[0].texture:SetTexture(tonumber(player_variables['class'], 10)/255, tonumber(player_variables['spec'], 10)/255, player_variables['level']/255)
        
        _G[player_variables['function_init']]()
        event_frame:SetScript("OnUpdate", _G[player_variables['function']])
    end
end

function check_chat_editbox()
    if (ACTIVE_CHAT_EDIT_BOX ~= nil) then
        for _, value in pairs(spell_frames) do
            value.texture:SetTexture(0, 0, 0, 0)
        end
        return false 
    end

    return true
end

function set_frame_state(pos, state)
    if state == 1 then
        spell_frames[pos].texture:SetTexture(0, 1, 0)
    else
        spell_frames[pos].texture:SetTexture(0, 0, 0, 0)
    end
end

function get_health_on_percent(unit)
    return UnitHealth(unit) / UnitHealthMax(unit) * 100
end

function get_mana_on_percent(unit)
    return UnitMana(unit) / UnitManaMax(unit) * 100
end

function can_cast(spellname)
    if not (select(1, IsUsableSpell(spellname))) then 
        return false end
    if (UnitCastingInfo('player')) then 
        return false end
    if (UnitChannelInfo('player')) then 
        return false end
    if ((select(2, GetSpellCooldown(spellname))) > 0) then 
        return false end
    return true
end

function can_cast_on_enemy(spellname)
    if not can_cast(spellname) then 
        return false end
    if UnitIsDeadOrGhost('target') then 
        return false end
    if (UnitCanAttack('player', 'target') ~= 1) then 
        return false end
    if (IsSpellInRange(spellname, 'target') ~= 1) then 
        return false end
    return true
end

function can_cast_on_point(spellname)
    if not can_cast(spellname) then 
        return false end
    if (UnitExists('mouseover') ~= 1) then 
        return false end
    return true
end

function check_ememy_debuff(spellname, player)
    player = player or false
    if (player and (select(8, UnitDebuff('target', spellname))) == 'player') then
        return true
    elseif (not player and UnitDebuff('target', spellname)) then
        return true
    end
    return false
end

function check_player_buff(spellname)
    if (UnitBuff('player', spellname)) then 
        return true end
    return false
end

function is_enemy_cast()
    if (UnitCastingInfo('target')) then 
        return true end
    if (UnitChannelInfo('target')) then 
        return true end
    return false
end

function general_update()
    if (not check_chat_editbox()) then
        return false end

    if (not UnitExists('target')) then
        set_frame_state(1, 1) else set_frame_state(1, 0) end

    if (get_health_on_percent('player') < 20) then
        set_frame_state(2, 1) else set_frame_state(2, 0) end

    if (get_mana_on_percent('player') < 10) then
        set_frame_state(3, 1) else set_frame_state(3, 0) end

    return true
end

function rotation_3_1_init()
    player_variables['mana_regeneration_mode'] = false
end

function rotation_3_1()
    if (not general_update()) then
        return false end
    
    if (get_mana_on_percent('player') < 20 and not player_variables['mana_regeneration_mode']) then
        player_variables['mana_regeneration_mode'] = true
    elseif (get_mana_on_percent('player') > 60 and player_variables['mana_regeneration_mode']) then
        player_variables['mana_regeneration_mode'] = false
    end

    if (player_variables['mana_regeneration_mode'] == false and 
        not check_player_buff('Дух дракондора') and 
        not check_player_buff('Дух дикой природы') and 
        can_cast('Дух дракондора')) then
        set_frame_state(10, 1) else set_frame_state(10, 0) end
    
    if (player_variables['mana_regeneration_mode'] == false and 
        not check_ememy_debuff('Укус змеи', true)  and
        can_cast_on_enemy('Укус змеи')) then
        set_frame_state(11, 1) else set_frame_state(11, 0) end

    if (player_variables['mana_regeneration_mode'] == true and 
        not check_player_buff('Дух гадюки') and 
        not check_player_buff('Дух дикой природы') and 
        can_cast('Дух гадюки')) then
        set_frame_state(12, 1) else set_frame_state(12, 0) end

    if (player_variables['mana_regeneration_mode'] == true and 
        not check_ememy_debuff('Укус гадюки', true) and
        can_cast_on_enemy('Укус гадюки')) then
        set_frame_state(13, 1) else set_frame_state(13, 0) end

    if (not check_player_buff('Аура меткого выстрела') and can_cast('Аура меткого выстрела')) then
        set_frame_state(14, 1) else set_frame_state(14, 0) end
    
    if (not check_ememy_debuff('Метка охотника') and can_cast_on_enemy('Метка охотника')) then
        set_frame_state(15, 1) else set_frame_state(15, 0) end

    if (can_cast_on_enemy('Убийственный выстрел')) then
        set_frame_state(16, 1) else set_frame_state(16, 0) end

    if (can_cast_on_enemy('Выстрел химеры')) then
        set_frame_state(17, 1) else set_frame_state(17, 0) end

    if (can_cast_on_enemy('Прицельный выстрел')) then
        set_frame_state(18, 1) else set_frame_state(18, 0) end

    if (can_cast_on_enemy('Чародейский выстрел')) then
        set_frame_state(19, 1) else set_frame_state(19, 0) end

    if (can_cast_on_point('Бросок ловушки: взрывная ловушка')) then
        set_frame_state(20, 1) else set_frame_state(20, 0) end

    if (can_cast_on_enemy('Верный выстрел')) then
        set_frame_state(21, 1) else set_frame_state(21, 0) end

    if (can_cast_on_point('Град стрел')) then
        set_frame_state(22, 1) else set_frame_state(22, 0) end
end

event_frame:SetScript('OnEvent', event_frame.OnEvent)
event_frame:RegisterEvent("PLAYER_LOGIN")