#!/bin/sh

xrdb merge ~/.Xresources
/usr/bin/sxhkd &
xset r rate 200 50 &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
feh --no-fehbg --bg-center '/home/hudamnhd/Images/wallpapers/basmalah.png' &
xrandr --output HDMI-A-0 --brightness 0.4
setxkbmap -option "caps:escape_shifted_capslock" &

bash /home/hudamnhd/.config/dwm/dwbar.sh &

while type dwm >/dev/null; do dwm && continue || break; done
