function HelloWorld.craft.mailbox:init()
    self.vars.open = false
end

function HelloWorld.craft.mailbox:step_1()
    if (self.vars.open == true) then return end
    HelloWorld:show(20)
end

function HelloWorld.craft.mailbox:step_2()
    CheckInbox()
    if ((select(2, GetInboxNumItems())) == 0) then
        self:set_parent_module('crafting')
        CloseMail()
        return
    end

    local _, _, sender, _, money, CODAmount, _, hasItem = GetInboxHeaderInfo(1)
    if (CODAmount > 0) and (InboxItemCanDelete(1) == nil) then
        ReturnInboxItem(1)
        self.parent:set_cooldown(0.5)
        return
    elseif (CODAmount > 0) and (InboxItemCanDelete(1) == 1) then
        DeleteInboxItem(1)
        self.parent:set_cooldown(0.5)
        return
    end
    if (money > 0) then
        TakeInboxMoney(1)
        self.parent:set_cooldown(0.5)
    end
    if (hasItem == nil) then
        DeleteInboxItem(1)
        self.parent:set_cooldown(0.5)
        return
    else
        if (self.parent.get_bag_free_slots() - 3 >= hasItem) then
            AutoLootMailItem(1)
            self.parent:set_cooldown(0.5)
        else
            self:set_parent_module('crafting')
            CloseMail()
        end
    end
end

function HelloWorld.craft.mailbox:open()
    if (self.vars.open == true) then return end

    HelloWorld:hide(20)
    self.vars.open = true
    SendChatMessage('.i m', 'SAY')
    self:set_step(2)

    self.parent:set_cooldown(1)
end
