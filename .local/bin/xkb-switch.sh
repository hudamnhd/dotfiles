#!/bin/bash

# Mendapatkan layout keyboard saat ini
layout=$(setxkbmap -query | grep layout | awk '{print $2}')

# Beralih layout dan kirim notifikasi
if [ "$layout" = "us" ]; then
  setxkbmap ar
  notify-send "Keyboard Layout Switched" "Sekarang menggunakan Arabic"
else
  setxkbmap us
  notify-send "Keyboard Layout Switched" "Sekarang menggunakan English (US)"
fi
