import win32gui
import win32api
import win32con
from time import sleep


def get_pixels_color(hwnd):
    result = []
    if (hwnd != 0):
        hwndDC = win32gui.GetWindowDC(hwnd)
        for i in range(0, 4):
            ret = win32gui.GetPixel(hwndDC, i, 0)
            r, g, b = ret & 0xff, (ret >> 8) & 0xff, (ret >> 16) & 0xff
            result.append((r, g, b))
        win32gui.ReleaseDC(hwnd, hwndDC)
        return result


def key_send(hwnd, key_code):
    key_press(hwnd, 16)
    key_press(hwnd, 17)
    key_press(hwnd, 18)
    key_press(hwnd, key_code)
    key_release(hwnd, key_code)
    key_release(hwnd, 18)
    key_release(hwnd, 17)
    key_release(hwnd, 16)


def key_press(hwnd, key_code):
    win32api.PostMessage(hwnd, win32con.WM_KEYDOWN, key_code, 0)


def key_release(hwnd, key_code):
    win32api.PostMessage(hwnd, win32con.WM_KEYUP, key_code, 0)


hwnd_wow = 0

while True:

    try:
        pixel_color = get_pixels_color(hwnd_wow)
        if (pixel_color[0] == (31, 11, 12)):
            for i in range(1, 4):
                if (pixel_color[i][0] == 44):
                    key_send(hwnd_wow, pixel_color[i][1])
    except:
        hwnd_wow = win32gui.FindWindow(None, 'World of Warcraft')

    sleep(0.05)
