#!/usr/bin/env bash

source "$(dirname "$0")/bemenu_theme.sh"

# Define options
options="Cancel\nLock Screen\nSleep\nLogout\nShutdown\nReboot"

# Display the menu using bemenu
choice=$(echo -e "$options" | bemenu -p "Power Menu:" "${bemenu_config[@]}")

# Execute the chosen option
case $choice in
	"Cancel")
		exit 0
		;;
	"Lock Screen")
		loginctl lock-session
		;;
	"Sleep")
		systemctl suspend
		;;
	"Logout")
		if echo -e "Yes\nNo" | bemenu -i -p "Are you sure you want to logout?" "${bemenu_config[@]}" | grep -q "Yes"; then
			loginctl terminate-session
		fi
		;;
	"Shutdown")
		if echo -e "Yes\nNo" | bemenu -i -p "Are you sure you want to shutdown?" "${bemenu_config[@]}" | grep -q "Yes"; then
			systemctl poweroff
		fi
		;;
	"Reboot")
		if echo -e "Yes\nNo" | bemenu -i -p "Are you sure you want to reboot?" "${bemenu_config[@]}" | grep -q "Yes"; then
			systemctl reboot
		fi
		;;
	*)
		exit 1
		;;
esac
