function HelloWorld.craft.mailbox:init()
    self.vars.open = false

    self:register_event('MAIL_CLOSED')
    self:register_event('MAIL_INBOX_UPDATE')

    -- self:set_action('step_1')
end

function HelloWorld.craft.mailbox:step_1()
    if (self.vars.open == false) then
        HelloWorld:keystroke(12, 0, 0, 0, 1)
    else
        self:set_action('step_2')
    end
end

function HelloWorld.craft.mailbox:open_click()
    if (self.vars.open == true) then return end
    -- self.vars.open = true
    -- self:init()
    print('click')
    SendChatMessage('.i m', 'SAY')
    -- self.craft.mailbox:add_cooldown(7)
end

function HelloWorld.craft.mailbox:MAIL_INBOX_UPDATE()
    self.vars.open = true
    -- self:add_cooldown(5)
end

-- function HelloWorld.craft.mailbox:step_2()
--     if (not self.vars.open) then self:set_action('step_1') end

--     if ((select(2, GetInboxNumItems())) > 0) then
--         if ((select(1, GetInboxNumItems())) > 0) then
--             local _, _, sender, _, money, CODAmount, _, hasItem = GetInboxHeaderInfo(1)
--             if (CODAmount > 0) and (InboxItemCanDelete(1) == nil) then
--                 -- ReturnInboxItem(1)
--                 return
--             elseif (CODAmount > 0) and (InboxItemCanDelete(1) == 1) then
--                 -- DeleteInboxItem(1)
--                 return
--             end
--             if (money > 0) then
--                 -- TakeInboxMoney(1)
--                 return
--             end
--             if (hasItem ~= nil) then
--                 if (self.parent:get_bag_free_slots() - 3 >= hasItem) then
--                     print('take items')
--                     -- AutoLootMailItem(1)
--                     return
--                 else
--                     self.parent:set_action('crafting')
--                     CloseMail()
--                 end
--             else
--                 DeleteInboxItem(1)
--                 return
--             end
--         end
--     else
--         self.parent:set_action('crafting')
--         CloseMail()
--     end
-- end

function HelloWorld.craft.mailbox:MAIL_CLOSED()
    print('ЗАКРЫЛИ ПОЧТУ')
    self.vars.open = false
end
