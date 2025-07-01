#!/usr/bin/env bash

# rofi-custom.sh - A script for custom Rofi actions

# Function to handle the menu option
menu() {
    rofi -show drun -show-icons -me-select-entry '' -me-accept-entry MousePrimary
}

screenshot_full() {
    sleep 1
    scrot ~/Pictures/screenshot/screenshot_$(date '+%Y%m%d%H%M%S').png
    notify-send "Screenshot Taken" "Fullscreen screenshot saved."

}

screenshot() {
    selected_option=$(echo -e "Screenshot Fullscreen\nScreenshot Selection" | rofi -dmenu -p "Screenshot")

    if [ "$selected_option" == "Screenshot Fullscreen" ]; then
        screenshot_full
    fi

    if [ "$selected_option" == "Screenshot Selection" ]; then
        scrot -s ~/Pictures/screenshot/screenshot_$(date '+%Y%m%d%H%M%S').png
        notify-send "Screenshot Taken" "Selection screenshot saved."
    fi
}

screenrecord() {
    start_record() {
        encoding_option=$(echo -e "Ultrafast\nMedium\nSlow" | rofi -dmenu -p "Choose Encoding Preset")

        case "$encoding_option" in
        "Ultrafast")
            preset="ultrafast"
            ;;
        "Medium")
            preset="medium"
            ;;
        "Slow")
            preset="slow"
            ;;
        *)
            echo "Invalid option selected."
            exit 1
            ;;
        esac

        filename=~/Videos/screenrecord_$(date '+%Y%m%d%H%M%S').mp4
        ffmpeg -f x11grab -s $(xdpyinfo | grep dimensions | awk '{print $2}') -r 25 -i :0.0 -preset $preset $filename &
        pid=$!
        echo $pid >~/.screenrecord_pid
        notify-send "Screen Recording Started" "Recording to $filename using $preset preset"
    }

    stop_record() {
        pid=$(cat ~/.screenrecord_pid)
        kill $pid
        notify-send "Screen Recording Stopped"
        rm ~/.screenrecord_pid
    }

    selected_option=$(echo -e "Start Recording\nStop Recording" | rofi -dmenu -no-show-icons -p "Screen Record")

    if [ "$selected_option" == "Start Recording" ]; then
        start_record
    elif [ "$selected_option" == "Stop Recording" ]; then
        stop_record
    fi
}

power_menu() {
    # Declare actions associative array
    declare -A actions
    actions[Logout]="loginctl terminate-session ${XDG_SESSION_ID-}"
    actions[Suspend]="systemctl suspend"
    actions[Hibernate]="systemctl hibernate"
    actions[Reboot]="systemctl reboot"
    actions[Shutdown]="systemctl poweroff"

    # Prepare options for rofi
    local options="Logout\nSuspend\nHibernate\nReboot\nShutdown"

    # Show menu
    local choice
    choice=$(echo -e "$options" | rofi -dmenu -p "Power Menu")

    # Execute command if valid choice
    if [[ -n "$choice" ]]; then
        local cmd=${actions[$choice]}
        if [[ -n "$cmd" ]]; then
            eval "$cmd"
        else
            notify-send "Power Menu" "Invalid choice: $choice"
        fi
    fi
}

# Function to handle another option (can be expanded with more functions)
another_action() {
    echo "Another action executed!"
}

# rofi-custom.sh - A script for custom Rofi actions
# Parse the arguments and decide what action to take
case "$1" in
menu) menu ;;
power-menu) power_menu ;;
window) window ;;
screenshot) screenshot ;;
screenrecord) screenrecord ;;
*)
    echo "Usage: $0 {menu | powermenu | screenrecord | screenshot}"
    exit 1
    ;;
esac

# Function for completion
_rofi_custom_completions() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}" # Get the current word the user is typing

    # Define the list of options
    local options="menu powermenu screenrecord screenshot"

    # If the current word is the first one (command), suggest options
    COMPREPLY=($(compgen -W "$options" -- "$cur"))
}

# Enable the completion function for the script
complete -F _rofi_custom_completions rofi-custom
