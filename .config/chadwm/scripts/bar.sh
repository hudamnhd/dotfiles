#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

# load colors
. ~/.config/chadwm/scripts/bar_themes/green

pomodoro() {
	cpu_val=$(~/.config/chadwm/scripts/timer.sh status)
	printf "^c$black^ ^b$blue^ TIMER"
	printf "^c$blue^ ^b$black^ $cpu_val"
}

cpu() {
	cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
	printf "^c$black^ ^b$purple^ CPU"
	printf "^c$purple^ ^b$black^ $cpu_val"
}

mem() {
	printf "^c$black^ ^b$yellow^ MEM"
	printf "^c$yellow^ ^b$black^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$white^ ^b$black^ 󰤨 ^d^%s" " ^c$white^Connected" ;;
	down) printf "^c$white^ ^b$black^ 󰤭 ^d^%s" " ^c$white^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$green^ TIME"
	printf "^c$green^ ^b$black^ $(date '+%H:%M:%S - %b %d (%a)')"
}

while true; do
	sleep 1 && xsetroot -name "$(pomodoro) $(clock) $(mem) $(cpu)"
done
