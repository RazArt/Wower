import keyboard
import mouse
from threading import Thread
from time import sleep
from random import randint

import Wower.config as config

_running = False
_hotkey_pressed = {}


def start():
    global _running, _hotkey_pressed
    _running = True

    Thread(target=_check_key_state, daemon=True).start()


def stop():
    global _running
    _running = False


def _check_key_state():
    global _running, _hotkey_pressed

    while _running == True:
        for hotkey, properties in config.user_hotkeys.items():

            if (not get_key_state(hotkey)
                    and _hotkey_pressed.setdefault(hotkey, False) == True):
                _hotkey_pressed[hotkey] = False
            if (get_key_state(hotkey)
                    and _hotkey_pressed.setdefault(hotkey, False) == False):
                _hotkey_pressed[hotkey] = True
                print(f'Do "{properties[0]}"')
                Thread(target=properties[0], args=(hotkey, ),
                       daemon=True).start()
        sleep(0.05)


def get_key_state(scan_code):
    return keyboard.is_pressed(scan_code)


def get_mouse_state(button):
    return mouse.is_pressed(button)


def key_send(scan_code, shift=False, ctrl=False, alt=False):
    print(f'Send "{scan_code}" {shift=} {ctrl=} {alt=}')

    if (shift == True):
        keyboard.press(42)
    if (ctrl == True):
        keyboard.press(29)
    if (alt == True):
        keyboard.press(56)

    keyboard.send(scan_code)

    if (shift == True):
        keyboard.release(42)
    if (ctrl == True):
        keyboard.release(29)
    if (alt == True):
        keyboard.release(56)


def click_send():
    mouse.click()
