import win32gui
import win32api
import win32con
import keyboard
from time import sleep

runing = False
handle = 0
pixels = []
pixels_count = 6 + 1


def check_window():
    global handle

    handle = win32gui.GetForegroundWindow()
    if (win32gui.GetWindowText(handle) != 'World of Warcraft'): return False

    return True


def get_pixels_color():
    result = []

    hWndDC = win32gui.GetWindowDC(handle)
    for i in range(0, pixels_count):
        ret = win32gui.GetPixel(hWndDC, i, 0)
        r, g, b = ret & 0xff, (ret >> 8) & 0xff, (ret >> 16) & 0xff
        result.append((r, g, b))
    win32gui.ReleaseDC(handle, hWndDC)

    return result


def modifier_resend():
    key_send(16)
    key_send(17)
    key_send(18)


def key_send_with_modifier(key_code, modifier):
    if (modifier == 1): key_press(18)
    if (modifier == 2): key_press(18)
    if (modifier == 3): key_press(18)
    if (modifier == 7): key_press(18)
    if (modifier == 2): key_press(17)
    if (modifier == 4): key_press(17)
    if (modifier == 5): key_press(17)
    if (modifier == 7): key_press(17)
    if (modifier == 3): key_press(16)
    if (modifier == 5): key_press(16)
    if (modifier == 6): key_press(16)
    if (modifier == 7): key_press(16)

    key_send(key_code)

    if (modifier == 3): key_release(16)
    if (modifier == 5): key_release(16)
    if (modifier == 6): key_release(16)
    if (modifier == 7): key_release(16)
    if (modifier == 2): key_release(17)
    if (modifier == 4): key_release(17)
    if (modifier == 5): key_release(17)
    if (modifier == 7): key_release(17)
    if (modifier == 1): key_release(18)
    if (modifier == 2): key_release(18)
    if (modifier == 3): key_release(18)
    if (modifier == 7): key_release(18)


def key_send(key_code):
    key_press(key_code)
    key_release(key_code)


def key_press(key_code):
    win32api.PostMessage(handle, win32con.WM_KEYDOWN, key_code, 0)


def key_release(key_code):
    win32api.PostMessage(handle, win32con.WM_KEYUP, key_code, 0)


def click_send():
    cursor_x, cursor_y = win32api.GetCursorPos()
    lParam = win32api.MAKELONG(cursor_x, cursor_y)
    win32gui.PostMessage(handle, win32con.WM_LBUTTONDOWN, win32con.MK_LBUTTON, lParam)
    win32gui.PostMessage(handle, win32con.WM_LBUTTONUP, win32con.MK_LBUTTON, lParam)


def check_keys():
    if (keyboard.is_pressed(18)): return True
    if (keyboard.is_pressed(19)): return True
    if ((not keyboard.is_pressed(18)) and (not keyboard.is_pressed(19))): return False


def send_start():
    global runing
    runing = True
    key_send(45)


def send_stop():
    global runing
    runing = False
    key_send(46)
    if (pixels[1][0] == 56): key_send(35)


while True:
    try:
        if (not check_window()): continue
        if (keyboard.is_pressed(42)): continue
        if (keyboard.is_pressed(56)): continue
        if (keyboard.is_pressed(29)): continue

        modifier_resend()
        pixels = get_pixels_color()

        if ((not runing) and (check_keys())): send_start()
        if ((runing) and (not check_keys())): send_stop()

        if (not check_keys()): continue
        if (pixels[0] != (31, 11, 12)): continue

        if ((pixels[1][0] == 56) and (pixels[1][1] == 1)): key_send(36)
        if (pixels[2][0] == 56): click_send()
        for i in range(1, pixels_count):
            if (pixels[i][0] == 44): key_send_with_modifier(pixels[i][1], pixels[i][2])
    finally:
        sleep(0.1)
