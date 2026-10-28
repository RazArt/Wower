BHelper.macros = {}

function BHelper.macros:create(name, command, slot, icon)
    name = name:lower()
    slot = slot or 0
    icon = icon or 1

    self:delete(name)
    if (CreateMacro(name, icon, command, (GetNumMacros() == 36))) then
        if (slot > 0) then self:put_to_panel(name, slot) end
    end
end

function BHelper.macros:put_to_panel(name, slot)
    PickupMacro(name:lower())
    PlaceAction(slot)
    ClearCursor()
end

function BHelper.macros:delete(name)
    DeleteMacro(GetMacroIndexByName(name:lower()))
end

function BHelper.macros:clear()
    for i = 54, 1, -1 do DeleteMacro(i) end
end
