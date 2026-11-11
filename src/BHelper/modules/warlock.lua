function BHelper.modules.warlock.default:init()
    vars = self.vars

    if (not vars.pet_control) then vars.pet_control = true end

    BHelper.keybinds:bind_item('Освященные перчатки мрачного шабаша')
end

function BHelper.modules.warlock.default:macros()
    BHelper.macros:create('S', '/cast Огненная глыба\n/bh sa rotation_single\n/bh', 13, 1263)
    BHelper.macros:create('M', '/cast Огненный столб\n/bh sa rotation_multiple\n/bh', 14, 1264)
end

function BHelper.modules.warlock.default:execute()

end

function BHelper.modules.warlock.default:rotation_single()

    if ((BHelper.player:is_equipped_item('Освященные перчатки мрачного шабаша')) and
        (BHelper.player:can_use_item('Освященные перчатки мрачного шабаша'))) then
        BHelper.keybinds:show_item('Освященные перчатки мрачного шабаша')
        return true
    end

end

function BHelper.modules.warlock.default:rotation_multiple()

end
