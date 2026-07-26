import keyboard
import mouse

from time import sleep
from win32gui import GetForegroundWindow
from win32process import GetWindowThreadProcessId
from psutil import Process
from PIL import ImageGrab

keyboard._winkeyboard._setup_name_tables()

while True:
    try:
        process_name = Process(GetWindowThreadProcessId(GetForegroundWindow())[1]).name().lower()
    except:
        process_name = ''

    if (process_name == 'wow.exe'):
        try:
            image = ImageGrab.grab()
            for i in range(0, 3):
                pixel_color = image.getpixel((i, 0))
                if (pixel_color[0] == 44):
                    key_code = pixel_color[2]

                    if (key_code != 0):
                        keyboard.press(29)
                        keyboard.press(56)
                        keyboard.press(42)
                        keyboard.send(key_code)
                        keyboard.release(42)
                        keyboard.release(56)
                        keyboard.release(29)

                    if (pixel_color[3] == 1):
                        sleep(0.1)
                        mouse.click()
        except:
            pass
    sleep(0.05)
