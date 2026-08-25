function BHelper.modules.auction.common:init()
    self.vars.open = false
    self.vars.page = 0
    self.vars.change_page = true
    self.vars.item_num = 1
    self.vars.item_list = {
        {'Абсолютная пыль', 60000}, {'Ледяная ткань', 10000},
        {'Осколок грез', 500000}, {'Кристалл пропасти', 500000},
        {'Рулон ледяной ткани', 50000}
    }
    self.vars.list_updated = false
    self.vars.lot_index = 0
    self.vars.click_wait = false
    self:register_event('AUCTION_ITEM_LIST_UPDATE')
    self:register_event('AUCTION_HOUSE_SHOW')
    self:register_event('AUCTION_HOUSE_CLOSED')

    BHelper.core.action:set('step_1')
end

function BHelper.modules.auction.common:step_1()
    if (self.vars.open == false) then BHelper.keybinds:show_spell(13, false, false, true) end
end

function BHelper.modules.auction.common:open_click()
    if (self.vars.open == true) then return end
    self.vars.open = true
    SendChatMessage('.i au', 'SAY')
end

function BHelper.modules.auction.common:AUCTION_HOUSE_show_spell()
    SortAuctionItems("list", "bid")
    BHelper.core.action:set('step_2')
    BHelper.core:cooldown(2)
end

function BHelper.modules.auction.common:step_2()
    if (not self.vars.open) then BHelper.core.action:set('step_1') end

    if ((select(1, CanSendAuctionQuery())) == 1) then
        QueryAuctionItems(self.vars.item_list[self.vars.item_num][1], 0, 0, 0, 0, 0, self.vars.page,
                          false, 0, 0)
        BHelper.core.action:set('step_3')
        BHelper.core:cooldown(1)
    end
end

function BHelper.modules.auction.common:AUCTION_ITEM_LIST_UPDATE()
    if (self._route == 'step_3') then self.vars.list_updated = true end
end

function BHelper.modules.auction.common:step_3()
    if (not self.vars.open) then BHelper.core.action:set('step_1') end

    if (self.vars.list_updated == true) then
        local batch = (select(1, GetNumAuctionItems('list')))
        self.vars.list_updated = false
        self.vars.lot_index = batch
        if (batch > 0) then
            BHelper.core.action:set('step_4')
        else
            if (self.vars.item_num < #self.vars.item_list) then
                self.vars.item_num = self.vars.item_num + 1
                self.vars.page = 0
                BHelper.core.action:set('step_2')
            else
                CloseAuctionHouse()
                self.parent.core.action:set('mailbox', self)
            end
        end
    end
end

function BHelper.modules.auction.common:step_4()
    if (not self.vars.open) then BHelper.core.action:set('step_1') end
    if (self.vars.click_wait == true) then BHelper.keybinds:show_spell(6, false, false, true) end

    if (self.vars.lot_index > 0) then
        local name, _, count, _, _, _, _, _, buyoutPrice, _, _, owner, sold = GetAuctionItemInfo(
                                                                                  "list", self.vars
                                                                                      .lot_index)
        if ((name == self.vars.item_list[self.vars.item_num][1]) and
            (BHelper.player:get_name() ~= owner) and (GetMoney() > buyoutPrice) and
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
        BHelper.core.action:set('step_2')
    end
end

function BHelper.modules.auction.common:buy_click()
    if (self.vars.click_wait == false) then return end

    self.vars.click_wait = false
    PlaceAuctionBid("list", self.vars.lot_index, self.vars.buyout_price)
    self.vars.lot_index = self.vars.lot_index - 1
    BHelper.core:cooldown(1)
end

function BHelper.modules.auction.common:AUCTION_HOUSE_CLOSED()
    self.vars.open = false
end
