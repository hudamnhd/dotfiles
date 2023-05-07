xrandr --output HDMI-A-0 --gamma 0.95:0.95:0.85 --brightness 0.8  --output DisplayPort-0 --gamma 0.95:0.95:0.85 --brightness 0.8
xrandr --output DisplayPort-0 --auto --right-of HDMI-A-0 &
picom -b --experimental-backends &
/usr/libexec/xfce-polkit &     
nitrogen --restore &
xset r rate 250 60 &
pavucontrol &
nm-applet &
while sleep 1
do
  RAM=`free -m | grep "Mem" | awk '{ print $3 }'`
  DATE=`date`
    xsetroot -name "[RAM $RAM MB][$DATE][VOL $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 2 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')%]"
done &
while type dwm >/dev/null; do dwm && continue || break; done