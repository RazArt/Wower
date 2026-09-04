import win32gui
import win32api
import win32con
from time import sleep


def get_pixels_color(hWnd):
    result = []
    if (hWnd != 0):
        hWndDC = win32gui.GetWindowDC(hWnd)
        for i in range(0, 6):
            ret = win32gui.GetPixel(hWndDC, i, 0)
            r, g, b = ret & 0xff, (ret >> 8) & 0xff, (ret >> 16) & 0xff
            result.append((r, g, b))
        win32gui.ReleaseDC(hWnd, hWndDC)
        return result


def key_send(hWnd, key_code):
    key_press(hWnd, 17)
    key_press(hWnd, 18)
    key_press(hWnd, key_code)
    key_release(hWnd, key_code)
    key_release(hWnd, 18)
    key_release(hWnd, 17)


def key_press(hWnd, key_code):
    win32api.PostMessage(hWnd, win32con.WM_KEYDOWN, key_code, 0)


def key_release(hWnd, key_code):
    win32api.PostMessage(hWnd, win32con.WM_KEYUP, key_code, 0)


def click_send(hWnd):
    cursor_x, cursor_y = win32api.GetCursorPos()
    lParam = win32api.MAKELONG(cursor_x, cursor_y)
    win32gui.PostMessage(hWnd, win32con.WM_LBUTTONDOWN, win32con.MK_LBUTTON, lParam)
    win32gui.PostMessage(hWnd, win32con.WM_LBUTTONUP, win32con.MK_LBUTTON, lParam)


hWnd_wow = 0
while True:
    try:
        pixel_color = get_pixels_color(hWnd_wow)
        if (pixel_color[0] == (31, 11, 12)):
            for i in range(1, 6):
                if (pixel_color[i][0] == 44):
                    if (pixel_color[i][1] > 44):
                        key_send(hWnd_wow, pixel_color[i][1])
                    if (pixel_color[i][2] == 1):
                        click_send(hWnd_wow)
    except:
        hWnd_wow = win32gui.FindWindow(None, 'World of Warcraft')

    sleep(0.1)
