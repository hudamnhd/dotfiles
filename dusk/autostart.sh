# xrandr --output DisplayPort-0  --brightness 0.5 &
xrandr --output HDMI-A-0  --brightness 0.45 &
setxkbmap -layout "us"&
xset r rate 250 60 &
nitrogen --restore &
nm-applet &
clipmenud &
setxkbmap -option "ctrl:nocaps" &
/usr/libexec/xfce-polkit &
#picom -bc &
xrdb merge /home/hudamnhd/st/xresources &

#xsetroot -solid darkgrey                    
# set root window background
# xmodmap -e 'keycode 66 = Shift_L' &
# setxkbmap -option "caps:escape_shifted_capslock" &
# make CapsLock behave like Ctrl:
# setxkbmap -option ctrl:super &
#xfce4-clipman &
while sleep 1
do
RAM=`free -m | grep "Mem" | awk '{ print $3 }'`
VOL=`pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 2 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'`
DATE=`date '+%b %d (%a) - %H:%M'`
  duskc run_command setstatus 1 "RAM $RAM MB - $DATE - VOL $VOL%"
done &
