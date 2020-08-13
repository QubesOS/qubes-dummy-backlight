#!/bin/bash

brightness="$(cat /sys/class/backlight/dummy_backlight/brightness)"

if [[ $brightness =~ ^[0-9]+$ ]] && [ "$brightness" -le 100 ]; then
    qrexec-client-vm @default qubes.SetBrightness+"$brightness"
else
    # Kernel should enforce the integer type and the driver maximum value
    # but in case of any problem don't qrexec with wrong values
    logger -t qubes "Invalid brightness value: $brightness"
fi
