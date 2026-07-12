HelloWorld:register_event('PLAYER_LOGIN')
function HelloWorld:PLAYER_LOGIN()
    HelloWorld()
    Keystroke()

    self:get_route()

    CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
        HelloWorld:_update(elapsed)
        Keystroke:_update(elapsed)
    end)

    self:create_timer(15, function()
        print(123123123)
    end, 'hide')
end

function HelloWorld:get_route()
    -- if (self:get_player_name() == 'Колотая') then
    --     self:set_route('craft')
    --     self.craft:stop()
    -- else
    --     self:set_route('war')
    -- end
    self:set_route('war')
end

function HelloWorld:get_player_name()
    return (select(1, UnitName('player')))
end
