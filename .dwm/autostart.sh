xrandr --output DP-1 --auto --right-of HDMI-1 ; xrandr --output HDMI-1 --gamma 0.95:0.95:0.85 --brightness 0.8  --output DP-1 --gamma 0.95:0.95:0.85 --brightness 0.8 &
setxkbmap -layout "us"&              
xset r rate 250 60 &
nitrogen --restore &
nm-applet &
lxpolkit &
picom -b &
xfce4-clipman &
while sleep 1
do
  
  RAM=`free -m | grep "Mem" | awk '{ print $3 }'`
  DATE=`date '+%b %d (%a) %I:%M%p'`
    xsetroot -name "|RAM $RAM |$DATE |VOL $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 2 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')%"
done &
while type dwm >/dev/null; do dwm && continue || break; done