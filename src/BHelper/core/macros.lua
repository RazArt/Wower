BHelper.macros = {}

local keybinds = {}

local icons = {}

function BHelper.macros:namespace_init()
    keybinds = BHelper.keybinds
end

local function delete(name)
    DeleteMacro(GetMacroIndexByName(name:lower()))
end

function BHelper.macros:create(name, command, icon)
    name = ((name) and (type(name) == 'string')) and name:lower() or ''
    icon = (icon) and self:icon(icon) or 1

    delete(name)
    CreateMacro(name, icon, command, (GetNumMacros() == 36))
    keybinds:bind_macro(name)
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
