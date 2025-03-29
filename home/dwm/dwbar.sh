while true; do
    VOL=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(($SINK + 2)) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
    RAM=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
    DATE=$(date '+%H:%M:%S | %b %d (%a)')
    sleep 1 && xsetroot -name " $DATE | MEM $RAM | VOL $VOL% "
done
