HelloWorld = CreateFrame('Frame', nil, UIParent)
HelloWorld.name = 'HelloWorld'
HelloWorld.trade = {}
HelloWorld.trade.name = 'TradeName'
HelloWorld.trade.parent = HelloWorld

HelloWorld:SetScript('OnEvent', function(self, event, ...)
    self[event](self, ...)
end)

HelloWorld:RegisterEvent("PLAYER_LOGIN")
function HelloWorld:PLAYER_LOGIN()
    self.base_frame = CreateFrame('Frame', nil, self)
    self.base_frame.frames = {}

    self.vars = {}
    self.vars.classes = {
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

        if (self.trade.init ~= nil) then self.trade:init() end
        if (self['trade'] ~= nil) then
            self:SetScript('OnUpdate', function(self, elapsed)
                self.trade:update()
            end)
        end
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
    return self.vars.classes[(select(2, UnitClass('player'))):lower()]
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

    local _, _, _, _, _, _, expirationTime, unitCaster = UnitDebuff('target', spellname)

    if ((player) and (unitCaster ~= 'player')) then return 0 end
    if (expirationTime == nil) then return 0 end

    return expirationTime - GetTime()
end

function HelloWorld:get_player_buff_time(spellname)
    player = player or false

    local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff('player', spellname)

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
    self.vars.mana_regeneration = false
end

function HelloWorld:rotation_3_1()
    if (not self:general_update()) then return false end

    if ((self:get_mana_on_percent('player') < 20) and (not self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = true
    elseif ((self:get_mana_on_percent('player') > 60) and (self.vars.mana_regeneration)) then
        self.vars.mana_regeneration = false
    end

    if ((self.vars.mana_regeneration == false) and
        (self:get_player_buff_time('Дух дракондора') == 0) and
        (self:get_player_buff_time('Дух дикой природы') == 0) and
        (self:can_cast('Дух дракондора'))) then
        self:frames(10):Show()
    else
        self:frames(10):Hide()
    end

    if ((self.vars.mana_regeneration == true) and
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

    if ((self.vars.mana_regeneration == false) and
        (self:get_ememy_debuff_time('Укус змеи', true) == 0) and
        (self:can_cast_on_enemy('Укус змеи'))) then
        self:frames(15):Show()
    else
        self:frames(15):Hide()
    end

    if ((self.vars.mana_regeneration == true) and
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

function HelloWorld.trade:init()
    self.step = 1
    self.vars = {}
    self.vars.auc_query_timer = false
    self.vars.auc_buy_timer = false
    self.vars.auc_page = 0
    self.vars.auc_query_send = false
    self.vars.auc_list_update = false
    self.vars.auc_open = false
    self.vars.auc_item_num = 1
    self.vars.auc_item_list = {
        {'Льняная сумка', 10000}, {'Абсолютная пыль', 60000},
        {'Ледяная ткань', 15000}, {'Рулон ледяной ткани', 50000}
    }

    -- 41510 Рулон ледяной ткани
    -- 41512 Ледотканые напульсники
    -- 34054 Абсолютная пыль
    -- 34056 Малая космическая субстанция
    -- 34055 Великая космическая субстанция
    -- 34053 Маленький осколок грез
    -- 34052 Осколок грез
    -- 34057 Кристалл пропасти
    -- 38426 Этерниевая нить
    -- 33470 Ледяная ткань
end

function HelloWorld.trade:update()
    if (self.step == 1) then
        self:craft()
    elseif (self.step == 2) then
        self:mail()
    elseif (self.step == 3) then
        self:auction()
    end
end

function HelloWorld.trade:craft()
    local items = self:get_bag_items_count()

    if ((((items[34056] ~= nil) and (items[34056] > 2)) or
        ((items[34053] ~= nil) and (items[34053] > 2))) and (self.can_cast())) then
        self:frames(10):Show()
    else
        self:frames(10):Hide()
    end

    if ((items[41512] ~= nil) and (items[41512] > 0) and (self.can_cast())) then
        self:frames(11):Show()
    else
        self:frames(11):Hide()
    end

    if (((items[41510] ~= nil) and (items[41510] > 2)) and
        ((items[38426] ~= nil) and (items[38426] > 0)) and (self.can_cast()) and
        self:get_bag_free_slots() > 1) then
        self:frames(12):Show()
    else
        self:frames(12):Hide()
    end

    if (((items[33470] ~= nil) and (items[33470] > 4)) and (self.can_cast()) and
        self:get_bag_free_slots() > 1) then
        self:frames(13):Show()
    else
        self:frames(13):Hide()
    end

    if (((items[41512] == nil) or (items[41512] == 0)) and
        (((items[41510] == nil) or (items[41510] < 3)) or
            ((items[38426] == nil) or (items[38426] == 0))) and
        ((items[33470] == nil) or (items[33470] < 5))) then
        print('Step 1 stop')
        self.step = 3
    end
end
function HelloWorld.trade:mail()
    CheckInbox()
    local numItems, totalItems = GetInboxNumItems()

    for i = numItems, 1, -1 do
        local _, _, sender, _, money, CODAmount, _, hasItem = GetInboxHeaderInfo(i)

        if (CODAmount > 0) and (InboxItemCanDelete(i) == nil) then
            -- ReturnInboxItem(i)
        elseif (CODAmount > 0) and (InboxItemCanDelete(i) == 1) then
            -- DeleteInboxItem(i)
        end

        if (money > 0) then TakeInboxMoney(i) end

        if (hasItem == nil) then
            -- DeleteInboxItem(i) 
        end

        if ((hasItem ~= nil) and (self.get_bag_free_slots() - 1 >= hasItem)) then
            -- AutoLootMailItem(i) 
        end
    end

    CheckInbox()
    local numItems, totalItems = GetInboxNumItems()
    if ((totalItems == 0) or (totalItems == numItems)) then
        print('Step 2 stop')
        CloseMail()
        self.step = 1
    end
end

function HelloWorld.trade:auction()
    local change_page = true

    if ((not self.vars.auc_query_timer) and (self.vars.auc_open) and
        ((select(1, CanSendAuctionQuery())) == 1)) then
        if (IsAuctionSortReversed("list", "bid") == nil) then
            SortAuctionItems("list", "bid")
            print('Сортируем')
        end

        if (self.vars.auc_query_send == false) then
            QueryAuctionItems(self.vars.auc_item_list[self.vars.auc_item_num][1], 0, 0, 0, 0, 0,
                              self.vars.auc_page, false, 0, 0)

            self.vars.auc_query_send = true
            self.vars.auc_query_timer = true
            C_Timer.After(2, function()
                self.vars.auc_query_timer = false
            end)
            print('Отправили запрос')
        end

        if ((self.vars.auc_list_update == true) and (self.vars.auc_query_send == true)) then
            self.vars.auc_list_update = false
            self.vars.auc_query_send = false

            local batch, _ = GetNumAuctionItems('list')
            print(self.vars.auc_item_list[self.vars.auc_item_num][1],
                  'Перебираю страницу', self.vars.auc_page,
                  ' всего элементов', batch)
            if (batch > 0) then
                for index = batch, 1, -1 do
                    local _, _, count, _, _, _, _, _, buyoutPrice, _, _, owner, sold =
                        GetAuctionItemInfo("list", index)
                    if (buyoutPrice / count <= self.vars.auc_item_list[self.vars.auc_item_num][2]) then
                        print(index, self.vars.auc_item_list[self.vars.auc_item_num][1], count,
                              buyoutPrice, owner, sold)
                        -- change_page = false
                    end
                end

                if (change_page) then self.vars.auc_page = self.vars.auc_page + 1 end
                print('Закончил считать страницу')
            else
                self.vars.auc_page = 0
                if (self.vars.auc_item_num < #self.vars.auc_item_list) then
                    self.vars.auc_item_num = self.vars.auc_item_num + 1
                    print('Следующий предмет')
                else
                    print('Step 3 stop')
                    self.vars.auc_item_num = 1
                    self.step = 4
                    -- CloseAuctionHouse()
                end
            end
        end
        self.vars.auc_query_timer = true
        C_Timer.After(5, function()
            self.vars.auc_query_timer = false
        end)
    end
end

HelloWorld:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
function HelloWorld:AUCTION_ITEM_LIST_UPDATE()
    if (self.trade.vars.auc_query_send == true) then
        self.trade.vars.auc_list_update = true
        print('Получили ответ')
    end
end
HelloWorld:RegisterEvent("AUCTION_HOUSE_SHOW")
function HelloWorld:AUCTION_HOUSE_SHOW()
    self.trade.vars.auc_open = true
end
HelloWorld:RegisterEvent("AUCTION_HOUSE_CLOSED")
function HelloWorld:AUCTION_HOUSE_CLOSED()
    self.trade.vars.auc_open = false
    self.trade:init()
end

function HelloWorld.trade:send_auction_query(name, page)

end

function HelloWorld.trade:frames(pos)
    return self.parent.base_frame.frames[pos]
end

function HelloWorld.trade:can_cast()
    if (UnitCastingInfo('player')) then return false end
    if (UnitChannelInfo('player')) then return false end
    return true
end

function HelloWorld.trade:get_bag_free_slots()
    local free_slots_count = 0
    for bag_num = 0, 4 do
        free_slots_count = free_slots_count + (select(1, GetContainerNumFreeSlots(bag_num)))
    end
    return free_slots_count
end

function HelloWorld.trade:get_bag_items_count()
    local items = {}
    for bag_num = 0, 4 do
        for slot_num = 1, GetContainerNumSlots(bag_num) do
            local item_id = GetContainerItemID(bag_num, slot_num)
            if (item_id ~= nil) then
                if (items[item_id] == nil) then items[item_id] = 0 end
                items[item_id] = items[item_id] +
                                     (select(2, GetContainerItemInfo(bag_num, slot_num)))
            end
        end
    end
    return items
end

function HelloWorld.trade:get_tradeskill_num_available(index)
    return (select(3, GetTradeSkillInfo(index)))
end

function HelloWorld.trade:get_tradeskill_index(name)
    for i = GetNumTradeSkills(), 1, -1 do
        if ((select(2, GetTradeSkillInfo(i)) == "header")) then ExpandTradeSkillSubClass(i) end
    end
    for i = 1, GetNumTradeSkills() do
        if ((select(1, GetTradeSkillInfo(i))) == name) then return i end
    end
    return 0
end

function HelloWorld.trade:craft_item(name)
    index = self:get_tradeskill_index(name)
    if (index > 0) then
        num_available = self:get_tradeskill_num_available(index)
        if (num_available > 0) then DoTradeSkill(index) end
    end
end

function sleep(seconds)
    local start_time = GetTime()
    while GetTime() - start_time < seconds do end
    return true
end
