from time import sleep

import Wower.screen_scan as screen_scan
import Wower.hotkeys as hotkeys


def do_general(position):
    match position:
        case 1:
            hotkeys.click_send()
        case 2:
            hotkeys.key_send(10, ctrl=True)
        case 3:
            hotkeys.key_send(9, ctrl=True)


def do_rotation_3_1_1(key):
    while hotkeys.get_key_state(key) == True:
        for position in screen_scan.get_pixel_colors():
            do_general(position)
            match position:
                case 10:
                    hotkeys.key_send(10, alt=True)
                    break
                case 11:
                    hotkeys.key_send(11, alt=True)
                    break
                case 12:
                    hotkeys.key_send(9, alt=True)
                    break
                case 13:
                    hotkeys.key_send(10)
                    break
                case 14:
                    hotkeys.key_send(8, alt=True)
                    break
                case 15:
                    hotkeys.key_send(3)
                    break
                case 16:
                    hotkeys.key_send(4)
                    break
                case 17:
                    hotkeys.key_send(5)
                    break
                case 18:
                    hotkeys.key_send(6)
                    break
                case 19:
                    hotkeys.key_send(7)
                    break
                # case 20:
                #     hotkeys.key_send(8)
                #     break
                case 21:
                    hotkeys.key_send(9)
                    sleep(0.1)
                    hotkeys.click_send()
                    break
                case 22:
                    hotkeys.key_send(10)
                    break
        sleep(0.1)


def do_rotation_3_1_2(key):
    while hotkeys.get_key_state(key) == True:
        for position in screen_scan.get_pixel_colors():
            do_general(position)
            match position:
                case 10:
                    hotkeys.key_send(10, alt=True)
                case 11:
                    hotkeys.key_send(11, alt=True)
                case 12:
                    hotkeys.key_send(9, alt=True)
                    break
                case 21:
                    hotkeys.key_send(9)
                    sleep(0.1)
                    hotkeys.click_send()
                    break
                case 23:
                    hotkeys.key_send(33)
                    sleep(0.1)
                    hotkeys.click_send()
                    break
        sleep(0.1)


def do_rotation_4_1_1(key):
    while hotkeys.get_key_state(key) == True:
        for position in screen_scan.get_pixel_colors():
            do_general(position)
            match position:
                case 10:
                    hotkeys.key_send(2)
                    break
                case 11:
                    hotkeys.key_send(4)
                    break
                case 12:
                    hotkeys.key_send(6)
                    break
                case 13:
                    hotkeys.key_send(7)
                    break
                case 14:
                    hotkeys.key_send(5)
                    break
        sleep(0.1)


def do_rotation_4_1_2(key):
    while hotkeys.get_key_state(key) == True:
        for position in screen_scan.get_pixel_colors():
            do_general(position)
            match position:
                case 10:
                    hotkeys.key_send(2)
                    break
                case 15:
                    hotkeys.key_send(33)
                    break
        sleep(0.1)


def do_trade(key):
    while hotkeys.get_key_state(key + 1) == False:
        for position in screen_scan.get_pixel_colors():
            do_general(position)
            match position:
                case 10:
                    hotkeys.key_send(2, alt=True)
                    break
                case 11:
                    hotkeys.key_send(3, alt=True)
                    break
                case 12:
                    hotkeys.key_send(4, alt=True)
                    break
                case 13:
                    hotkeys.key_send(5, alt=True)
                    break
                case 30:
                    hotkeys.key_send(6, alt=True)
                    break
        sleep(0.1)
