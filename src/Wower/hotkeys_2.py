from pynput import mouse, keyboard
from threading import Thread
from time import sleep
from random import randint

import Wower.config as config

_key_pressed = {}
_keyboard_listener = None
_keyboard_controller = keyboard.Controller()
_mouse_controller = mouse.Controller()


def key_send(key, shift=False, ctrl=False, alt=False):
    if (shift == True):
        _keyboard_controller.press(keyboard.Key.shift)
    if (ctrl == True):
        _keyboard_controller.press(keyboard.Key.ctrl)
    if (alt == True):
        _keyboard_controller.press(keyboard.Key.alt)

    _keyboard_controller.press(key)
    _keyboard_controller.release(key)

    if (shift == True):
        _keyboard_controller.release(keyboard.Key.shift)
    if (ctrl == True):
        _keyboard_controller.release(keyboard.Key.ctrl)
    if (alt == True):
        _keyboard_controller.release(keyboard.Key.alt)


def click_send():
    _mouse_controller.click(mouse.Button.left)


def _keyboard_on_press(key):

    global _key_pressed
    try:
        if (_key_pressed.setdefault(key.char, False) == False):
            _key_pressed[key.char] = True
            print(12)
            Thread(target=config.user_hotkeys[key.char][0],
                   args=(key.char, ),
                   daemon=True).start()
    except:
        pass


def _keyboard_on_release(key):
    global _key_pressed

    try:
        _key_pressed[key.char] = False
    except:
        pass


def get_key_state(key):
    return _key_pressed.setdefault(key, False)


def start():
    global _keyboard_listener
    _keyboard_listener = keyboard.Listener(on_press=_keyboard_on_press,
                                           on_release=_keyboard_on_release)
    _keyboard_listener.start()


def stop():
    _keyboard_listener.stop()
