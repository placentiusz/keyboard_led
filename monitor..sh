#!/bin/sh


evtest /dev/input/event3 | while read line; do
    case "$line" in
        *KEY_CAPSLOCK*|*KEY_NUMLOCK*|*KEY_SCROLLLOCK*)
            echo "Lock key pressed"
            ;;
    esac
done
