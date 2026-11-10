BHelper.macros = {}

local keybinds = {}

local icons = {}

function BHelper.macros:namespace_init()
    keybinds = BHelper.keybinds
end

function BHelper.macros:create(name, command, slot, icon)
    name = ((name) and (type(name) == 'string')) and name:lower() or ''
    slot = ((slot) and (type(slot) == 'number')) and slot or 0
    icon = (icon) and self:icon(icon) or 1

    self:delete(name)
    if (CreateMacro(name, icon, command, (GetNumMacros() == 36))) then
        if (slot > 0) then keybinds:put_macro(name, slot) end
    end
end

function BHelper.macros:delete(name)
    DeleteMacro(GetMacroIndexByName(name:lower()))
end

function BHelper.macros:clear()
    for i = 54, 1, -1 do DeleteMacro(i) end
end

function BHelper.macros:icon(name)
    name = ((name) and (type(name) == 'string')) and ('Interface\\Icons\\' .. name) or ''
    for index, icon in pairs(icons) do if (icon == name) then return index end end
end

local function init()
    for i = 1, GetNumMacroIcons() do icons[i] = GetMacroIconInfo(i) end
end
init()
