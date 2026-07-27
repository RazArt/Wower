BHelper.macros = {}

function BHelper.macros:create(name, command)
    self:delete(name)

    name = 'BH: ' .. string.lower(name)

    return CreateMacro(name, 1, command, true)
end

function BHelper.macros:delete(name)
    name = 'BH: ' .. string.lower(name)

    for i = 54, 37, -1 do
        local macro_name = (select(1, GetMacroInfo(i)))
        if ((macro_name ~= nil) and (macro_name == name)) then DeleteMacro(i) end
    end
end

function BHelper.macros:delete_all()
    for i = 54, 37, -1 do
        local macro_name = (select(1, GetMacroInfo(i)))
        if ((macro_name ~= nil) and (string.find(macro_name, '^BH: '))) then DeleteMacro(i) end
    end
end
