#!/bin/bash

# Format tanggal (DD-MM-YYYY)
TODAY=$(date +"%d-%m-%Y")
DAILY_DIR="$HOME/daily"
DAILY_FILE="$DAILY_DIR/$TODAY.txt"

# Cek apakah direktori ~/daily ada, jika tidak buat
if [ ! -d "$DAILY_DIR" ]; then
	mkdir -p "$DAILY_DIR"
fi

# Cek apakah file sudah ada, jika tidak buat
if [ ! -f "$DAILY_FILE" ]; then
	touch "$DAILY_FILE"
fi

# st -e nvim "$DAILY_FILE"

#!/bin/bash
# notify.sh

# environs=$(pidof dbus-daemon | tr ' ' '\n' | awk '{printf "/proc/%s/environ ", $1}')
# export DBUS_SESSION_BUS_ADDRESS=$(cat $environs 2>/dev/null | tr '\0' '\n' | grep DBUS_SESSION_BUS_ADDRESS | cut -d '=' -f2-)
# export DISPLAY=:0
#
# notify-send "It works!"
DISPLAY=:0 /usr/bin/notify-send "$(date +"Sudah 30 Menit | Time is %r")"
DISPLAY=:0 /usr/local/bin/st -e /opt/nvim-linux-x86_64/bin/nvim "$DAILY_FILE"
