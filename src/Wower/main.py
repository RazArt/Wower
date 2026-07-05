from threading import Thread
from time import sleep
from win32gui import GetForegroundWindow
from win32process import GetWindowThreadProcessId
from psutil import Process

import Wower.screen_scan as screen_scan
import Wower.hotkeys as hotkeys

_runing = False


def check_active_process():
    global _runing

    while True:
        try:
            process_name = Process(
                GetWindowThreadProcessId(
                    GetForegroundWindow())[1]).name().lower()
        except:
            process_name = ''

        if (process_name == 'wow.exe' and _runing == False):
            _runing = True
            screen_scan.start()
            hotkeys.start()
            print('Start')
        elif (process_name != 'wow.exe' and _runing == True):
            _runing = False
            screen_scan.stop()
            hotkeys.stop()
            print('Stop')
        sleep(0.2)


Thread(target=check_active_process).start()
