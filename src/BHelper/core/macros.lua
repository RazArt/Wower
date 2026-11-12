BHelper.macros = {}

local icons = {}

local function icon_index(name)
    name = ((name) and (type(name) == 'string')) and ('Interface\\Icons\\' .. name) or ''
    for i = 1, #icons do if (icons[i] == name) then return i end end
end

function BHelper.macros:create(name, command, icon)
    name = ((name) and (type(name) == 'string')) and name:lower() or ''
    icon = (icon) and icon_index(icon) or 1

    DeleteMacro(GetMacroIndexByName(name))
    CreateMacro(name, icon, command, (GetNumMacros() == 36))
end

function BHelper.macros:clear()
    for i = 54, 1, -1 do DeleteMacro(i) end
end

local function init()
    for i = 1, GetNumMacroIcons() do icons[i] = GetMacroIconInfo(i) end
end
init()
