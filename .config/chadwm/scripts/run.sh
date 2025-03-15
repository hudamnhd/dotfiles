#!/bin/sh

xrdb merge ~/.Xresources
/usr/bin/sxhkd &
xset r rate 200 50 &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
# unclutter-xfixes --timeout 1 --jitter 1 --ignore-buttons 4,5,6,7 --hide-on-touch --start-hidden &
feh --no-fehbg --bg-center '/home/hudamnhd/Images/wallpapers/basmalah.png' &
xrandr --output HDMI-A-0 --brightness 0.4
setxkbmap -option "caps:escape_shifted_capslock" &
dash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
