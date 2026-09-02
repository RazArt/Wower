BHelper.macros = {}

-- function BHelper.macros:create(name, command, slot, global, icon)
--     name = string.lower(name)
--     slot = slot or 0
--     icon = icon or 1

--     self:delete(name, global)
--     if (CreateMacro(name, icon, command, not global and true or false) > 0) then
--         if (slot > 0) then self:put_to_panel(name, slot) end
--         return true
--     end
--     return false
-- end

function BHelper.macros:create(name, command, slot, icon)
    name = string.lower(name)
    slot = slot or 0
    icon = icon or 1

    if (GetNumMacros() == 36) then per_char = true end

    self:delete(name)
    if (CreateMacro(name, icon, command, per_char) > 0) then
        if (slot > 0) then self:put_to_panel(name, slot) end
        return true
    end
    return false
end

function BHelper.macros:put_to_panel(name, slot)
    name = string.lower(name)
    PickupMacro(name)
    PlaceAction(slot)
    ClearCursor()
end

function BHelper.macros:delete(name)
    name = string.lower(name)
    for i = 54, 1, -1 do
        local macro_name = (select(1, GetMacroInfo(i)))
        if ((macro_name) and (macro_name == name)) then
            if (DeleteMacro(i)) then return true end
        end
    end
    return false
end

function BHelper.macros:delete_all()
    local result = false
    for i = 54, 1, -1 do if (DeleteMacro(i)) then result = true end end
    return result
end
