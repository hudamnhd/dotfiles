#!/bin/sh

print_key_used() {
	printf " %s" "$(setxkbmap -query | awk '/layout/{print toupper($2)}')"
}

echo "$(print_key_used)"
