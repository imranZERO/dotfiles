#!/bin/bash

MONITOR_ID="DP-2"
STATUS=$(kscreen-doctor -o | grep -A1 "$MONITOR_ID" | grep enabled)

if [[ $STATUS == *"enabled"* ]]; then
	kscreen-doctor output."$MONITOR_ID".disable

	# Easyeffects crashes when disabling. Relaunch it
	sleep 2s
	easyeffects --gapplication-service
else
	kscreen-doctor output."$MONITOR_ID".enable

	# Open display configuration so that position can be adjusted
	kcmshell6 kcm_kscreen

	# Easyeffects crashes when enabling. Relaunch it
	sleep 2s
	easyeffects --gapplication-service
fi
