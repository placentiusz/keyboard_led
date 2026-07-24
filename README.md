# Keyboard LED

A small Ubuntu/Debian helper designed to enable the RGB backlight on simple, budget-friendly keyboards that do not expose a standard software toggle.

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

If you install the built Debian package, the service is placed in /lib/systemd/system/ and enabled automatically during package installation.

You can check it with:

```bash
sudo systemctl status keyboard_led.service
```

If you want to install it manually from the source tree, use:

```bash
sudo cp keyboard_led.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now keyboard_led.service
```

## Find your keyboard vendor and product ID

You can identify your USB keyboard with `lsusb`:

```bash
lsusb
```

Example output may look like this:

```text
Bus 002 Device 003: ID 1a2c:212a SEMICO USB Keyboard
```

The values you need are:
- Vendor ID: `1a2c`
- Product ID: `212a`

You can then update the `VID` and `PID` values at the top of `led_on.sh` to match your keyboard.

