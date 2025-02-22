#!/bin/sh

print_mem_used() {
	free -m | grep "Mem" | awk '{ print $3 }'
}

echo " $(print_mem_used)M"
