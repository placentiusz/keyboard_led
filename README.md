# Keyboard LED

A small Ubuntu/Debian helper that turns on the keyboard Scroll Lock LED and keeps it enabled while the script runs.

## Files

- `led_on.sh` — shell script that finds the keyboard input device and writes to its LED brightness control.
- `keyboard_led.service` — systemd unit for running the helper as a service.
- `debian/` — Debian packaging metadata used to build a `.deb` package.

## Build package

```bash
sudo apt install dpkg-dev debhelper
cd /home/jacek/Documents/Projects/keyboard_led
dpkg-buildpackage -us -uc -b
```

## Install service

```bash
sudo cp keyboard_led.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now keyboard_led.service
```
