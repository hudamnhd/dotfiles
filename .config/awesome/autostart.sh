# xrandr --output HDMI-A-0  --brightness 0.4 &
xrandr --output DisplayPort-0 --auto --right-of HDMI-A-0 ; xrandr --output HDMI-A-0  --brightness 0.45  --output DisplayPort-0 --brightness 0.5 &
xset r rate 210 40
# xset r rate 250 60 &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
unclutter-xfixes --timeout 1 --jitter 1 --ignore-buttons 4,5,6,7 --hide-on-touch --start-hidden &
xrdb ~/.Xresources &
~/.fehbg &
setxkbmap -option "caps:escape_shifted_capslock" &


# xrandr --output DisplayPort-0 --auto --right-of HDMI-A-0 ; xrandr --output HDMI-A-0  --brightness 0.45  --output DisplayPort-0 --brightness 0.5 &
# setxkbmap -layout "us"&
# fbautostart &
# urxvtd -q -f -o
# redshift &
# nitrogen --restore &
# nm-applet &
# clipmenud &
# setxkbmap -option "ctrl:nocaps" &
#/usr/libexec/xfce-polkit &
#picom -bc &
#!/bin/sh
# feh --no-fehbg --bg-scale '~/.local/share/azote/sample/pxfuel1.jpg'
# dex-autostart --autostart --environment dwm &
# xrdb merge ~/.st/xresources &
