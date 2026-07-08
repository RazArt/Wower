function HelloWorld.craft.mailbox:init()
    print('reinit mailbox')
end

function HelloWorld.craft.mailbox:step_1()
    CheckInbox()
    local numItems, totalItems = GetInboxNumItems()
    local _, _, sender, _, money, CODAmount, _, hasItem = GetInboxHeaderInfo(1)

    if (CODAmount > 0) and (InboxItemCanDelete(1) == nil) then
        ReturnInboxItem(1)
        self.parent:set_cooldown(1)
        return
    elseif (CODAmount > 0) and (InboxItemCanDelete(1) == 1) then
        DeleteInboxItem(1)
        self.parent:set_cooldown(1)
        return
    end
    if (money > 0) then
        TakeInboxMoney(1)
        self.parent:set_cooldown(1)
    end
    if (hasItem == nil) then
        DeleteInboxItem(1)
        self.parent:set_cooldown(1)
        return
    else
        if (self.get_bag_free_slots() - 3 >= hasItem) then
            AutoLootMailItem(i)
            self.parent:set_cooldown(1)
        end
    end
end
