#!/bin/bash

# VendorID i ProductID Twojej klawiatury
VID="1a2c"
PID="212a"
led_path=""

led_on() {
    # Znajdź wszystkie urządzenia input powiązane z tym HID
    for dev in /sys/class/input/input*; do
        if grep -q "$VID" "$dev/id/vendor" 2>/dev/null && \
           grep -q "$PID" "$dev/id/product" 2>/dev/null; then

            # Znajdź LED ScrollLock powiązany z tym inputX
            input_name=$(basename "$dev")
            led_path="/sys/class/leds/${input_name}::scrolllock"

            if [ -w "$led_path/brightness" ]; then
                echo 1 > "$led_path/brightness"
            fi
        fi
    done
}

led_on
inotifywait -m -e modify "$led_path" | while read; do
    led_on
done