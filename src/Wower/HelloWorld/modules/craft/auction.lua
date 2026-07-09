function HelloWorld.craft.auction:init()
    self.vars.open = false
    self.vars.page = 0
    self.vars.change_page = true
    self.vars.item_num = 1
    self.vars.item_list = {
        {'Абсолютная пыль', 60000}, {'Ледяная ткань', 13000},
        {'Рулон ледяной ткани', 50000}
    }
    self.vars.list_updated = false
    self.vars.lot_index = 0
    self.vars.click_wait = false

    HelloWorld.event_frame:RegisterEvent('AUCTION_ITEM_LIST_UPDATE')
    HelloWorld.event_frame:RegisterEvent('AUCTION_HOUSE_SHOW')
end

function HelloWorld.craft.auction:step_1()
    if (self.vars.open == true) then return end
    HelloWorld:show(30)
end

function HelloWorld.craft.auction:step_2()
    if (not self.vars.open) then return end
    if ((select(1, CanSendAuctionQuery())) == 1) then
        QueryAuctionItems(self.vars.item_list[self.vars.item_num][1], 0, 0, 0, 0, 0, self.vars.page,
                          false, 0, 0)
        self:set_step(3)
        self.parent:set_cooldown(1)
        return
    end
end

function HelloWorld.craft.auction:step_3()
    if (not self.vars.open) then return end

    if (self.vars.list_updated == true) then
        local batch = (select(1, GetNumAuctionItems('list')))
        self.vars.list_updated = false
        self.vars.lot_index = batch
        if (batch > 0) then
            self:set_step(4)
        else
            if (self.vars.item_num < #self.vars.item_list) then
                self.vars.item_num = self.vars.item_num + 1
                self.vars.page = 0
            else
                self:set_parent_module('mailbox')
                CloseAuctionHouse()
            end
            self:set_step(2)
        end
    end
end

function HelloWorld.craft.auction:step_4()
    if (not self.vars.open) then return end

    if (self.vars.click_wait == true) then return end
    if (self.vars.lot_index > 0) then
        local _, _, count, _, _, _, _, _, buyoutPrice, _, _, owner, sold = GetAuctionItemInfo(
                                                                               "list",
                                                                               self.vars.lot_index)
        if ((HelloWorld:get_player_name() ~= owner) and (GetMoney() > buyoutPrice) and
            (buyoutPrice > 0) and (sold == 0) and
            (buyoutPrice / count <= self.vars.item_list[self.vars.item_num][2])) then
            HelloWorld:show(31)
            self.vars.click_wait = true
            self.vars.buyout_price = buyoutPrice
            self.vars.change_page = false
            return
        end
        self.vars.lot_index = self.vars.lot_index - 1
    else
        if (self.vars.change_page) then self.vars.page = self.vars.page + 1 end
        self.vars.change_page = true
        self:set_step(2)
    end
end

function HelloWorld.craft.auction:buy_click()
    if (not self.vars.open) then return end

    if (self.vars.click_wait == false) then return end
    PlaceAuctionBid("list", self.vars.lot_index, self.vars.buyout_price)
    self.vars.click_wait = false
    self.vars.lot_index = self.vars.lot_index - 1
    HelloWorld:hide(31)
    self.parent:set_cooldown(2)
end

function HelloWorld.craft.auction:open()
    if (self.vars.open == true) then return end

    HelloWorld:hide(30)
    self.vars.open = true
    SendChatMessage('.i au', 'SAY')
    self:set_step(2)

    self.parent:set_cooldown(1)
end

function HelloWorld:AUCTION_ITEM_LIST_UPDATE()
    if (self.craft.auction.step == 3) then self.craft.auction.vars.list_updated = true end
end

function HelloWorld:AUCTION_HOUSE_SHOW()
    SortAuctionItems("list", "bid")
end
