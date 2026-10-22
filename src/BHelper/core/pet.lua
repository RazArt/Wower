BHelper.pet = {}

function BHelper.pet:get_GUID()
    return UnitGUID('pet') or nil
end

function BHelper.pet:can_target_attack()
    if (not BHelper.player:can_target_attack()) then return false end
    if (UnitIsUnit('pettarget', 'target')) then return false end

    if (BHelper.target:get_name() == 'Ледяная сфера') then return false end
    if (BHelper.target:get_name() == 'Ледяной шар') then return false end
    if (BHelper.target:get_name() == 'Зловещий дух') then return false end
    if (BHelper.target:get_name() == 'Волдырный зомби') then return false end
    if ((BHelper.target:get_name() == 'Имирьярская повелительница льда') and
        (BHelper.auras:target('Арктический холод') > 0)) then return false end

    return true
end

function BHelper.pet:check_control()
    if (not UnitExists('pet')) then return false end
    if (UnitIsDeadOrGhost('pet')) then return false end
    if (((select(1, UnitName('pet'))) == 'Вепрь')) then return false end
    return BHelper.core.profile:get().vars.pet_control
end
