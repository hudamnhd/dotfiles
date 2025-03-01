print_date() {
	date '+%a, %d %b 󰥔 %H:%M'
}

dwm_alsa() {
	VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
	printf "%s" "$SEP1"
	if [ "$VOL" -eq 0 ]; then
		printf " "
	elif [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
		printf " %s%%" "$VOL"
	elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
		printf " %s%%" "$VOL"
	else
		printf " %s%%" "$VOL"
	fi
	printf "%s\n" "$SEP2"
}

print_mem_used() {
	free -m | grep "Mem" | awk '{ print $3 }'
}

print_key_used() {
	printf " %s" "$(setxkbmap -query | awk '/layout/{print toupper($2)}')"
}

xsetroot -name " $(print_date) | $(dwm_alsa) |  $(print_mem_used)M | $(print_key_used) "

# exit 0
