#!/bin/sh

/usr/bin/sxhkd &
feh --no-fehbg --bg-center '/usr/share/wallpapers/DebianTheme/contents/images/1920x1080.svg' & # set wallpaper
xset r rate 200 50 &  # set keyboard repeat delay/speed
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &  # start polkit for GUI auth
xrandr --output HDMI-A-0 --brightness 0.7  # set monitor brightness
# setxkbmap -option "caps:escape_shifted_capslock" &  # capslock = escape when shifted

bash /home/hudamnhd/.config/dwm/dwm-statusbar.sh &

while type dwm >/dev/null; do dwm && continue || break; done  # run dwm, restart if it exits cleanly
