BHelper.macros = {}

function BHelper.macros:get_formatted_name(name)
    return self._name_prefix .. string.lower(name)
end

function BHelper.macros:create(name, command, slot, global, icon)
    slot = slot or 0
    icon = icon or 1

    self:delete(name)
    if (CreateMacro(self:get_formatted_name(name), icon, command, not global and true or false) > 0) then
        if (slot > 0) then self:put_to_panel(name, slot) end
        return true
    end
    return false
end

function BHelper.macros:put_to_panel(name, slot)
    PickupMacro(self:get_formatted_name(name))
    PlaceAction(slot)
    ClearCursor()
end

function BHelper.macros:delete(name, global)
    if (global) then
        for i = 36, 1, -1 do
            local macro_name = (select(1, GetMacroInfo(i)))
            if ((macro_name) and (macro_name == self:get_formatted_name(name))) then
                DeleteMacro(i)
                return true
            end
        end
    else
        for i = 54, 37, -1 do
            local macro_name = (select(1, GetMacroInfo(i)))
            if ((macro_name) and (macro_name == self:get_formatted_name(name))) then
                DeleteMacro(i)
                return true
            end
        end
    end
    return false
end

function BHelper.macros:delete_all(global)
    local result = false
    if (global) then
        for i = 36, 1, -1 do
            local macro_name = (select(1, GetMacroInfo(i)))
            if ((macro_name) and (string.find(macro_name, '^' .. self._name_prefix))) then
                DeleteMacro(i)
                result = true
            end
        end
    else
        for i = 54, 37, -1 do
            local macro_name = (select(1, GetMacroInfo(i)))
            if ((macro_name) and (string.find(macro_name, '^' .. self._name_prefix))) then
                DeleteMacro(i)
                result = true
            end
        end
    end
    return result
end

function BHelper.macros:init()
    self._name_prefix = 'BH: '
end
BHelper.macros:init()
