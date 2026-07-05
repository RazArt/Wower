import InWorker.screen_scan as screen_scan
import InWorker.hotkeys as hotkeys
import InWorker.config as config

_spheres = {}
_spells = {}
_spheres['selected'] = {'names': {0: '', 1: '', 2: ''}, 'count': {'quas': 0, 'wex': 0, 'exort': 0}}
_spheres['availability'] = {'quas': False, 'wex': False, 'exort': False}
_spells['selected_names'] = {0: '', 1: ''}
_spells['structures'] = {
    'cold_snap': {
        'quas': 3,
        'wex': 0,
        'exort': 0
    },
    'ghost_walk': {
        'quas': 2,
        'wex': 1,
        'exort': 0
    },
    'ice_wall': {
        'quas': 2,
        'wex': 0,
        'exort': 1
    },
    'emp': {
        'quas': 0,
        'wex': 3,
        'exort': 0
    },
    'tornado': {
        'quas': 1,
        'wex': 2,
        'exort': 0
    },
    'alacrity': {
        'quas': 0,
        'wex': 2,
        'exort': 1
    },
    'deafening_blast': {
        'quas': 1,
        'wex': 1,
        'exort': 1
    },
    'sun_strike': {
        'quas': 0,
        'wex': 0,
        'exort': 3
    },
    'forge_spirit': {
        'quas': 1,
        'wex': 0,
        'exort': 2
    },
    'chaos_meteor': {
        'quas': 0,
        'wex': 1,
        'exort': 2
    }
}


def init():
    global _spheres, _spells
    _spheres['selected'] = {'names': {0: '', 1: '', 2: ''}, 'count': {'quas': 0, 'wex': 0, 'exort': 0}}
    _spheres['availability'] = {'quas': False, 'wex': False, 'exort': False}
    _spells['selected_names'] = {0: '', 1: ''}

    _update()


def _update():
    global _spheres, _spells

    position = 0
    pixel_colors = screen_scan.get_pixel_colors()
    spells_colors = {
        'cold_snap': ((19, 36, 149), (80, 85, 107)),
        'ghost_walk': ((5, 13, 32), (60, 66, 71)),
        'ice_wall': ((168, 208, 236), (123, 136, 147)),
        'emp': ((43, 3, 48), (96, 82, 105)),
        'tornado': ((2, 44, 75), (68, 78, 88)),
        'alacrity': ((52, 24, 23), (63, 66, 71)),
        'deafening_blast': ((27, 69, 124), (75, 83, 99)),
        'sun_strike': ((242, 213, 109), (147, 140, 117)),
        'forge_spirit': ((35, 49, 64), (63, 69, 74)),
        'chaos_meteor': ((172, 92, 5), (86, 79, 79))
    }

    for color in pixel_colors[:12]:
        if (color == (40, 122, 175)):
            _spheres['selected']['names'][position] = 'quas'
            position += 1
        elif (color == (119, 56, 126)):
            _spheres['selected']['names'][position] = 'wex'
            position += 1
        elif (color == (146, 87, 28)):
            _spheres['selected']['names'][position] = 'exort'
            position += 1

    _spheres['selected']['count'] = {'quas': 0, 'wex': 0, 'exort': 0}
    for _, name in _spheres['selected']['names'].items():
        if (name != ''):
            _spheres['selected']['count'][name] += 1

    if not (_spheres['availability']['quas']):
        _spheres['availability']['quas'] = True if (pixel_colors[12] == (34, 40, 39)) else False
    if not (_spheres['availability']['wex']):
        _spheres['availability']['wex'] = True if (pixel_colors[13] == (34, 40, 39)) else False
    if not (_spheres['availability']['exort']):
        _spheres['availability']['exort'] = True if (pixel_colors[14] == (34, 40, 39)) else False

    for index in range(2):
        for spellname, colors_array in spells_colors.items():
            if (colors_array[0] == pixel_colors[index + 15] or colors_array[1] == pixel_colors[index + 15]):
                _spells['selected_names'][index] = spellname


def get_prepared_spellname():
    _update()

    for spellname in _spells['structures']:
        if ((_spheres['selected']['count']['quas'] == _spells['structures'][spellname]['quas']) and
            (_spheres['selected']['count']['wex'] == _spells['structures'][spellname]['wex']) and
            (_spheres['selected']['count']['exort'] == _spells['structures'][spellname]['exort'])):
            return spellname

    return None


def prepare_spheres(spellname):
    spellname = "cold_snap" if (spellname == "quas") else spellname
    spellname = "emp" if (spellname == "wex") else spellname
    spellname = "sun_strike" if (spellname == "exort") else spellname

    if (get_prepared_spellname() == spellname):
        return True

    for sphere_name in _spells['structures'][spellname]:
        if (_spells['structures'][spellname][sphere_name] > 0):
            if (_spheres['availability'][sphere_name] == False):
                return False

    spheres = {}
    spheres['names'] = _spheres['selected']['names'].copy()

    for index in range(3):
        del spheres['names'][index]
        spheres['counts'] = {'quas': 0, 'wex': 0, 'exort': 0}
        spheres['difference'] = {'quas': 0, 'wex': 0, 'exort': 0}

        for _, name in spheres['names'].items():
            if (name != ''):
                spheres['counts'][name] += 1

        for sphere_name in spheres['difference']:
            difference = _spells['structures'][spellname][sphere_name] - spheres['counts'][sphere_name]
            spheres['difference'][sphere_name] = difference if (difference > 0) else 0

        if (index == (sum(spheres['difference'].values()) - 1)):
            for sphere_name, count in spheres['difference'].items():
                for _ in range(count):
                    hotkeys.key_send(config.key_binds[sphere_name])
            return True

    return True


def use_invoke():
    if (screen_scan.get_pixel_colors()[17] != (240, 160, 37)):
        return False

    hotkeys.key_send(config.key_binds['invoke'])
    return True


def prepare(spellname):
    if (prepare_spheres(spellname) == False or use_invoke() == False):
        return False

    return True


def prepare_multicast(spellname_1, spellname_2, spellname_3=''):
    _update()

    if ((_spells['selected_names'][0] == spellname_1 and _spells['selected_names'][1] == spellname_2) or
        (_spells['selected_names'][1] == spellname_1 and _spells['selected_names'][0] == spellname_2)):
        pass
    elif (_spells['selected_names'][1] == spellname_1):
        prepare(spellname_1)
        prepare(spellname_2)
    elif (_spells['selected_names'][1] == spellname_2):
        prepare(spellname_2)
        prepare(spellname_1)
    elif (_spells['selected_names'][0] == spellname_1):
        prepare(spellname_2)
    elif (_spells['selected_names'][0] == spellname_2):
        prepare(spellname_1)
    else:
        prepare(spellname_1)
        prepare(spellname_2)

    if (spellname_3):
        prepare_spheres(spellname_3)


def use(spellname, preparation_mode=False):
    _update()

    if (preparation_mode):
        if ((_spells['selected_names'][0] == spellname)):
            return True
        else:
            return prepare(spellname)
    else:
        if (_spells['selected_names'][0] == spellname):
            hotkeys.key_send_alt(config.key_binds['spell_1'])
            return True
        elif (_spells['selected_names'][1] == spellname):
            hotkeys.key_send_alt(config.key_binds['spell_2'])
            return True
        elif (get_prepared_spellname() == spellname):
            if (use_invoke() == True):
                hotkeys.key_send_alt(config.key_binds['spell_1'])
                return True
            return False
        elif (prepare(spellname)):
            hotkeys.key_send_alt(config.key_binds['spell_1'])
            return True

    return False


def use_item(item_num):
    hotkeys.key_send(config.key_binds['item_' + str(item_num)])
    return True
