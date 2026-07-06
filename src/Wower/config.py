import Wower.user_actions as user_actions

user_hotkeys = {}
class_hotkeys = {}

class_hotkeys[3] = {}
class_hotkeys[3][1] = {
    18: (user_actions.do_rotation_3_1_1, ),
    19: (user_actions.do_rotation_3_1_2, ),
}

class_hotkeys[4] = {}
class_hotkeys[4][1] = {
    18: (user_actions.do_rotation_4_1_1, ),
    19: (user_actions.do_rotation_4_1_2, ),
}

class_hotkeys[50] = {}
class_hotkeys[50][1] = {
    18: (user_actions.do_trade, ),
}
