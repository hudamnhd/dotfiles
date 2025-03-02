#!/bin/bash

sxhkd &
/home/hudamnhd/.dwm/scripts/dwm-status.sh &
/home/hudamnhd/.dwm/scripts/dwm-status.sh &
/home/hudamnhd/.dwm/scripts/dualmon.sh &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
# unclutter-xfixes --timeout 1 --jitter 1 --ignore-buttons 4,5,6,7 --hide-on-touch --start-hidden &
feh --no-fehbg --bg-fill '/home/hudamnhd/Images/wallpapers/basmalah.png' &
xrdb ~/.Xresources
dunst &
/home/hudamnhd/.dwm/scripts/setxmodmap-qwerty.sh
# ~/.dwm/scripts/autostart_wait.sh
