#!/usr/bin/env bash

#	The function of this script is only to detect if your Bluetooth interface is present
#	and active and display the information in POLYBAR.
#
#	gh0stzk - https://github.com/gh0stzk/dotfiles
#	07.08.2024 11:55:34

if [ ! -d /sys/class/bluetooth ]; then
	echo # No Bluetooth interface
	exit 0
fi

# Load current theme
read -r current_rice <"$HOME"/.config/bspwm/.rice

# Colors ( power on was "blue")
FILE="$HOME/.config/bspwm/rices/${current_rice}/config.ini"
POWER_ON=$(awk '/^mbg =/ {print $3; exit}' "$FILE") # blue-gray
POWER_OFF=$(awk '/^mbg =/ {print $3; exit}' "$FILE") # blue-gray

# Check if Bluetooth interface exists and its status
check_bluetooth() {
	if systemctl is-active --quiet bluetooth.service; then
		if bluetoothctl show | grep -q "Powered: yes"; then
			echo "%{F$POWER_ON}ON%{F-}" # Bluetooth is on echo "%{F$POWER_ON}󰂯%{F-}"
		else
			echo "%{F$POWER_OFF}OFF%{F-}" # Bluetooth is off echo "%{F$POWER_OFF}󰂲%{F-}"
		fi
	else
		echo
	fi
}

check_bluetooth
