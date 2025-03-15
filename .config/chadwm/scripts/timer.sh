#!/bin/bash

TIMER_FILE="$HOME/.pomodoro_timer"
TIMER_DURATION=$((25 * 60)) # 25 menit dalam detik

case "$1" in
start)
	START_TIME=$(date +%s)
	END_TIME=$((START_TIME + TIMER_DURATION))
	echo "$START_TIME $END_TIME" >"$TIMER_FILE"
	notify-send "Pomodoro Timer Started" "25 minutes remaining."
	;;
status)
	if [[ -f "$TIMER_FILE" ]]; then
		read -r START_TIME END_TIME <"$TIMER_FILE"
		CURRENT_TIME=$(date +%s)
		if [[ $CURRENT_TIME -ge $END_TIME ]]; then
			rm "$TIMER_FILE"
			notify-send "Pomodoro Completed" "Time's up! Take a break."
			echo "Done"
		else
			REMAINING_TIME=$((END_TIME - CURRENT_TIME))
			MINUTES=$((REMAINING_TIME / 60))
			SECONDS=$((REMAINING_TIME % 60))
			# printf "%02d:%02d""$MINUTES" "$SECONDS"
			echo "$MINUTES:$SECONDS"
		fi
	else
		echo "No Timer"
	fi
	;;
*)
	echo "Usage: $0 {start|status}"
	exit 1
	;;
esac
