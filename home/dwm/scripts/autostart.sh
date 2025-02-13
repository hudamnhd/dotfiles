#!/bin/bash

/bin/bash ~/.dwm/scripts/dwm-status.sh &
/bin/bash ~/.dwm/scripts/dualmon.sh &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
unclutter-xfixes --timeout 1 --jitter 1 --ignore-buttons 4,5,6,7 --hide-on-touch --start-hidden &
xrdb ~/.Xresources &
feh --no-fehbg --bg-fill '/home/hudamnhd/Images/wallpapers/basmalah.png' &
/bin/bash ~/.dwm/scripts/setxmodmap-qwerty.sh &

~/.dwm/scripts/autostart_wait.sh &
while type dwm >/dev/null; do dwm && continue || break; done