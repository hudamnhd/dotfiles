#!/bin/sh

feh --no-fehbg --bg-center '/usr/share/wallpapers/DebianTheme/contents/images/1280x800.svg' & # set wallpaper
xset r rate 200 50 &  # set keyboard repeat delay/speed
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &  # start polkit for GUI auth
xrandr --output HDMI-A-0 --brightness 0.7  # set monitor brightness
setxkbmap -option "caps:escape_shifted_capslock" &  # capslock = escape when shifted

while true; do
    VOL=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(($SINK + 2)) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')  # get volume %
    RAM=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)  # get used RAM
    DATE=$(date '+%H:%M:%S | %b %d (%a)')  # get date and time
    sleep 1 && xsetroot -name " $DATE | MEM $RAM | VOL $VOL% "  # set dwm bar
done

while type dwm >/dev/null; do dwm && continue || break; done  # run dwm, restart if it exits cleanly
