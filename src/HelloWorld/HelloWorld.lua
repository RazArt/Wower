HelloWorld:register_event('PLAYER_LOGIN')
function HelloWorld:PLAYER_LOGIN()
    HelloWorld()
    Keystroke()

    HelloWorld:get_route()
    CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
        HelloWorld:_update(elapsed)
        Keystroke:_update(elapsed)
    end)
end

function HelloWorld:update(elapsed)
    Keystroke:show(15, 0, 0, 0, 1)
end

function HelloWorld:get_route()
    if (self:get_player_name() == 'Колотая') then
        self:set_route('craft')
    else
        self:set_route('war')
    end
end
-- 
function HelloWorld:get_player_name()
    return (select(1, UnitName('player')))
end
-- function HelloWorld:get_player_class()
--     local classes = {
--         warrior = '1',
--         paladin = '2',
--         hunter = '3',
--         rogue = '4',
--         priest = '5',
--         deathknight = '6',
--         shaman = '7',
--         mage = '8',
--         warlock = '9',
--         druid = '11'
--     }
--     return classes[(select(2, UnitClass('player'))):lower()]
-- end
-- function HelloWorld:get_player_spec()
--     return GetSpecialization('player')
-- end
-- function HelloWorld:get_player_level()
--     return UnitLevel('player')
-- end
