#!/bin/bash

# Daftar menu
menu_items=("mocp" "mocp --previous" "mocp --toggle-pause" "mocp --next")

# Fungsi untuk menampilkan menu menggunakan Rofi
show_menu() {
    selected_item=$(printf "%s\n" "${menu_items[@]}" | rofi -dmenu -p "Mocp:")
    case $selected_item in
        "mocp")mocp
            urxvtc -tr -name player -e mocp
            ;;
        "mocp --previous")
           mocp --previous 
            ;;
        "mocp --toggle-pause")
           mocp --toggle-pause 
            ;;
        "mocp --next")
           mocp --next 
            ;;
        *)
            echo "Perintah tidak valid"
            ;;
    esac
}

# Panggil fungsi untuk menampilkan menu
show_menu

