function BHelper.modules.warlock.default:init()
    self.settings.type = 'battle'
    self.settings.only_combat_start = true

    if (self.vars.silence == nil) then self.vars.silence = false end

    BHelper.keybinds:bind_spell('Демоническое могущество')
    BHelper.keybinds:bind_spell('Проклятие стихий')
    BHelper.keybinds:bind_spell('Проклятие рока')
    BHelper.keybinds:bind_spell('Жизнеотвод')
    BHelper.keybinds:bind_spell('Метаморфоза')
    BHelper.keybinds:bind_spell('Жертвенный костер')
    BHelper.keybinds:bind_spell('Стрела Тьмы')
    BHelper.keybinds:bind_spell('Жертвенный огонь')
    BHelper.keybinds:bind_spell('Порча')
    BHelper.keybinds:bind_spell('Ожог души')
    BHelper.keybinds:bind_spell('Испепеление')
    BHelper.keybinds:bind_spell('')
    BHelper.keybinds:bind_spell('')
    BHelper.keybinds:bind_spell('')

    BHelper.keybinds:bind_item('Освященные перчатки мрачного шабаша')
end

function BHelper.modules.warlock.default:macros()

    BHelper.macros:create('S', '/cast Огненная глыба\n/bh sa rotation_single\n/bh', 13,
                          1263)
    BHelper.macros:create('M', '/cast Огненный столб\n/bh sa rotation_multiple\n/bh',
                          14, 1264)
end

function BHelper.modules.warlock.default:update()

end

function BHelper.modules.warlock.default:rotation_single()

    if ((BHelper.player:check_equipped_item(
        'Освященные перчатки мрачного шабаша')) and
        (BHelper.player:can_use_item(
            'Освященные перчатки мрачного шабаша'))) then
        BHelper.keybinds:show_item(
            'Освященные перчатки мрачного шабаша')
        return true
    end

end

function BHelper.modules.warlock.default:rotation_multiple()

end
