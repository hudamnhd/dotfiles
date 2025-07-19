#!/bin/sh
FILE="$1"
st -e sh -c "nvim -u NONE -U NONE -N -i NONE \"$FILE\""
