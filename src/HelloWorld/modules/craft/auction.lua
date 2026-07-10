function HelloWorld.craft.auction:init()
    self.vars.open = false
    self.vars.page = 0
    self.vars.change_page = true
    self.vars.item_num = 1
    self.vars.item_list = {
        {'Абсолютная пыль', 70000}, {'Ледяная ткань', 10000},
        {'Рулон ледяной ткани', 50000}
    }
    self.vars.list_updated = false
    self.vars.lot_index = 0
    self.vars.click_wait = false
    self:register_event('AUCTION_ITEM_LIST_UPDATE')
    self:register_event('AUCTION_HOUSE_SHOW')
    self:register_event('AUCTION_HOUSE_CLOSED')

    self:set_route('step_1')
end

function HelloWorld.craft.auction:step_1()
    if (self.vars.open == false) then
        HelloWorld:keystroke(13, 0, 0, 0, 1)
    else
        self:set_route('step_2')
    end
end

function HelloWorld.craft.auction:open_click()
    if (self.vars.open == true) then return end

    self:init()
    SendChatMessage('.i au', 'SAY')
end

function HelloWorld.craft.auction:AUCTION_HOUSE_SHOW()
    SortAuctionItems("list", "bid")
    self.vars.open = true
    self:set_route('step_2')
    self:add_cooldown(2)
end

function HelloWorld.craft.auction:step_2()
    if (not self.vars.open) then self:set_route('step_1') end

    if ((select(1, CanSendAuctionQuery())) == 1) then
        QueryAuctionItems(self.vars.item_list[self.vars.item_num][1], 0, 0, 0, 0, 0, self.vars.page,
                          false, 0, 0)
        self:set_route('step_3')
        self:add_cooldown(1)
    end
end

function HelloWorld.craft.auction:AUCTION_ITEM_LIST_UPDATE()
    if (self.action == 'step_3') then self.vars.list_updated = true end
end

function HelloWorld.craft.auction:step_3()
    if (not self.vars.open) then self:set_route('step_1') end

    if (self.vars.list_updated == true) then
        local batch = (select(1, GetNumAuctionItems('list')))
        self.vars.list_updated = false
        self.vars.lot_index = batch
        if (batch > 0) then
            self:set_route('step_4')
        else
            if (self.vars.item_num < #self.vars.item_list) then
                self.vars.item_num = self.vars.item_num + 1
                self.vars.page = 0
                self:set_route('step_2')
            else
                CloseAuctionHouse()
                self.parent:set_route('mailbox', self)
                -- self:set_route('step_1') -- Debug
            end
        end
    end
end

function HelloWorld.craft.auction:step_4()
    if (not self.vars.open) then self:set_route('step_1') end
    if (self.vars.click_wait == true) then HelloWorld:keystroke(6, 0, 0, 0, 1) end

    if (self.vars.lot_index > 0) then
        local _, _, count, _, _, _, _, _, buyoutPrice, _, _, owner, sold = GetAuctionItemInfo(
                                                                               "list",
                                                                               self.vars.lot_index)
        if ((HelloWorld:get_player_name() ~= owner) and (GetMoney() > buyoutPrice) and
            (buyoutPrice > 0) and (sold == 0) and
            (buyoutPrice / count <= self.vars.item_list[self.vars.item_num][2])) then
            self.vars.buyout_price = buyoutPrice
            self.vars.change_page = false
            self.vars.click_wait = true
            return
        end
        self.vars.lot_index = self.vars.lot_index - 1
    else
        if (self.vars.change_page) then self.vars.page = self.vars.page + 1 end
        self.vars.change_page = true
        self:set_route('step_2')
    end
end

function HelloWorld.craft.auction:buy_click()
    if (self.vars.click_wait == false) then return end

    self.vars.click_wait = false
    PlaceAuctionBid("list", self.vars.lot_index, self.vars.buyout_price)
    self.vars.lot_index = self.vars.lot_index - 1
    self:add_cooldown(2)
end

function HelloWorld.craft.auction:AUCTION_HOUSE_CLOSED()
    self.vars.open = false
end
