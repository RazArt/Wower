from threading import Thread
from time import sleep
from PIL import ImageGrab

import Wower.config as config

_running = False
_pixel_colors = []


def start():
    global _running
    _running = True

    Thread(target=update_info, daemon=True).start()


def stop():
    global _running
    _running = False


def update_info():
    global _pixel_colors

    while _running == True:
        try:
            image = ImageGrab.grab()
            _pixel_colors = []

            info = image.getpixel((0, 0))
            if (info[0] > 0 and info[0] in config.class_hotkeys
                    and info[1] in config.class_hotkeys[info[0]]):
                config.user_hotkeys = config.class_hotkeys[info[0]][info[1]]
                for position in range(1, 101):
                    if (image.getpixel((position, 0))[1] == 255):
                        _pixel_colors.append(position)
            else:
                config.user_hotkeys = {}

        finally:
            sleep(0.05)


def get_pixel_colors():
    return _pixel_colors
