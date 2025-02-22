#!/bin/bash

export XDG_SESSION_DESKTOP=xmonad
export XDG_SESSION_TYPE=x11
export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/1000
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export TERM=st-256color

/bin/dwall -s firewatch
