import keyboard

from time import sleep
from win32gui import GetForegroundWindow
from win32process import GetWindowThreadProcessId
from psutil import Process
from PIL import ImageGrab

keyboard._winkeyboard._setup_name_tables()


def check_active_process():
    while True:
        try:
            process_name = Process(GetWindowThreadProcessId(
                GetForegroundWindow())[1]).name().lower()
        except:
            process_name = ''

        if (process_name == 'wow.exe'):
            try:
                image = ImageGrab.grab()
                if (image.getpixel((0, 0)) == (31, 11, 12)):
                    key_code = image.getpixel((1, 0))[0] + image.getpixel((1, 0))[1]
                    key_modifiers = image.getpixel((2, 0))

                    if (key_code == 0):
                        continue
                    else:
                        # print(
                        #     f'send "{key_code}" {key_modifiers[0]} {key_modifiers[1]} {key_modifiers[0]}'
                        # )

                        if (key_modifiers[0] == 1):
                            keyboard.press(42)
                        if (key_modifiers[1] == 1):
                            keyboard.press(29)
                        if (key_modifiers[2] == 1):
                            keyboard.press(56)

                        keyboard.send(key_code)

                        if (key_modifiers[0] == 1):
                            keyboard.release(42)
                        if (key_modifiers[1] == 1):
                            keyboard.release(29)
                        if (key_modifiers[2] == 1):
                            keyboard.release(56)
            except:
                pass
        sleep(0.1)


check_active_process()
