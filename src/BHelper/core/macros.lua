BHelper.macros = {}

function BHelper.macros:create(name, command, slot, icon)
    name = name:lower()
    slot = slot or 0
    icon = icon or 1

    if (GetNumMacros() == 36) then per_char = true end

    self:delete(name)
    if (CreateMacro(name, icon, command, per_char)) then
        if (slot > 0) then self:put_to_panel(name, slot) end
        return true
    end
    return false
end

function BHelper.macros:put_to_panel(name, slot)
    name = name:lower()
    PickupMacro(name)
    PlaceAction(slot)
    ClearCursor()
end

function BHelper.macros:delete(name)
    name = name:lower()
    for i = 54, 1, -1 do if (GetMacroInfo(i) == name) then if (DeleteMacro(i)) then return true end end end
    return false
end

function BHelper.macros:clear()
    for i = 54, 1, -1 do DeleteMacro(i) end
end
