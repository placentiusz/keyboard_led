#!/bin/sh

# Vendor ID and Product ID of your keyboard
VID="1a2c"
PID="212a"
DEBUG=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        --debug)
            DEBUG=1
            ;;
        *)
            echo "Usage: $0 [--debug]" >&2
            exit 1
            ;;
    esac
    shift
done

log_debug() {
    if [ "$DEBUG" = "1" ]; then
        echo "$*"
    fi
}

get_event_from_input() {
    input_path="$1"

    event=$(ls "$input_path" 2>/dev/null | grep -E '^event[0-9]+$')

    if [ -z "$event" ]; then
        echo "no-event"
        return 1
    fi

    echo "/dev/input/$event"
}

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
                log_debug "LED enabled for VID=$VID PID=$PID on device $dev"
                event_dev=$(get_event_from_input "$dev")
                log_debug "Using event device: $event_dev"
                return 0
            fi
        fi
    done

    log_debug "LED path not found for VID=$VID PID=$PID"
    return 1
}

led_on || exit 1

evtest "$event_dev" | while read line; do
    case "$line" in
        *KEY_CAPSLOCK*|*KEY_NUMLOCK*|*KEY_SCROLLLOCK*)
            led_on
            ;;
    esac
done