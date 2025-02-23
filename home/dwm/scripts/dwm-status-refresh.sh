#!/bin/bash
# Screenshot: http://s.natalian.org/2013-08-17/dwm_status.png
# Network speed stuff stolen from http://linuxclues.blogspot.sg/2009/11/shell-script-show-network-speed.html

# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
function get_bytes {
	# Find active network interface
	interface=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5}')
	line=$(grep $interface /proc/net/dev | cut -d ':' -f 2 | awk '{print "received_bytes="$1, "transmitted_bytes="$9}')
	eval $line
	now=$(date +%s%N)
}

# Function which calculates the speed using actual and old byte number.
# Speed is shown in KByte per second when greater or equal than 1 KByte per second.
# This function should be called each second.

function get_velocity {
	value=$1
	old_value=$2
	now=$3

	timediff=$(($now - $old_time))
	velKB=$(echo "1000000000*($value-$old_value)/1024/$timediff" | bc)
	if test "$velKB" -gt 1024; then
		echo $(echo "scale=2; $velKB/1024" | bc)MB/s
	else
		echo ${velKB}
	fi
}

# Get initial values
get_bytes
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now

print_volume() {
	volume="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
	if test "$volume" -gt 0; then
		echo -e "\uE05D${volume}"
	else
		echo -e "Mute"
	fi
}

print_mem() {
	memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
	echo -e "$memfree"
}

print_temp() {
	test -f /sys/class/thermal/thermal_zone0/temp || return 0
	echo $(head -c 2 /sys/class/thermal/thermal_zone0/temp)C
}

print_date() {
	date '+%a, %d %b 󰥔 %H:%M:%S'
}

LOC=$(readlink -f "$0")
DIR="/home/hudamnhd/dotfiles/home/dwm/scripts"
export IDENTIFIER="unicode"

#. "$DIR/dwmbar-functions/dwm_transmission.sh"
#. "$DIR/dwmbar-functions/dwm_cmus.sh"
#. "$DIR/dwmbar-functions/dwm_resources.sh"
#. "$DIR/dwmbar-functions/dwm_battery.sh"
#. "$DIR/dwmbar-functions/dwm_mail.sh"
#. "$DIR/dwmbar-functions/dwm_backlight.sh"
. "/home/hudamnhd/dotfiles/home/dwm/scripts/dwmbar-functions/dwm_alsa.sh"
#. "$DIR/dwmbar-functions/dwm_pulse.sh"
#. "$DIR/dwmbar-functions/dwm_weather.sh"
#. "$DIR/dwmbar-functions/dwm_vpn.sh"
# . "$DIR/dwmbar-functions/dwm_network.sh"
# . "$DIR/dwmbar-functions/dwm_keyboard.sh"
#. "$DIR/dwmbar-functions/dwm_ccurse.sh"
#. "$DIR/dwmbar-functions/dwm_date.sh"

get_bytes

# Calculates speeds
vel_recv=$(get_velocity $received_bytes $old_received_bytes $now)/$(get_velocity $transmitted_bytes $old_transmitted_bytes $now)kb

print_mem_used() {
	free -m | grep "Mem" | awk '{ print $3 }'
}
print_key_used() {
	printf " %s" "$(setxkbmap -query | awk '/layout/{print toupper($2)}')"
}

xsetroot -name " $(print_date) | $(dwm_alsa) |  $(print_mem_used)M | 󰓅 $vel_recv | $(print_key_used) "

# Update old values to perform new calculations
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now

# exit 0
