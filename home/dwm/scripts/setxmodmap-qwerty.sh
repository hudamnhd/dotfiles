#!/bin/bash

# xset r rate 250 60 &
xset r rate 210 40
# setxkbmap -option "caps:escape_shifted_capslock" &

setxkbmap -option caps:none  # Nonaktifkan fungsi Caps Lock
xmodmap -e "keycode 66 = backslash bar"  # Ubah Caps Lock (keycode 66) menjadi '\'
