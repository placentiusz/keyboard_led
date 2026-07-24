#!/bin/sh

# VendorID i ProductID Twojej klawiatury
VID="1a2c"
PID="212a"

led_on() {
    for dev in /sys/class/input/input*; do
        [ -r "$dev/id/vendor" ] || continue
        [ -r "$dev/id/product" ] || continue

        vendor=$(cat "$dev/id/vendor" 2>/dev/null) || continue
        product=$(cat "$dev/id/product" 2>/dev/null) || continue

        if [ "$vendor" = "$VID" ] && [ "$product" = "$PID" ]; then
            input_name=$(basename "$dev")
            led_path="/sys/class/leds/${input_name}::scrolllock/brightness"

            if [ -w "$led_path" ]; then
                echo 1 > "$led_path"
                return 0
            fi
        fi
    done

    echo "Nie znaleziono ścieżki LED dla VID=$VID PID=$PID" >&2
    return 1
}

led_on
evtest /dev/input/event3 | while read line; do
    case "$line" in
        *KEY_CAPSLOCK*|*KEY_NUMLOCK*|*KEY_SCROLLLOCK*)
            led_on
            ;;
    esac
done