#!/bin/bash

MONITOR_ID="HDMI-A-3"
STATUS=$(kscreen-doctor -o | grep -A1 "$MONITOR_ID" | grep enabled)
POSITION="1920,-450"

if [[ $STATUS == *"enabled"* ]]; then
    kscreen-doctor output."$MONITOR_ID".disable

    # Easyeffects crashes when disabling. Relaunch it
    # sleep 2s && easyeffects --gapplication-service
else
    # Reset and enable the monitor with the new position
    kscreen-doctor output."$MONITOR_ID".disable && kscreen-doctor output."$MONITOR_ID".enable output."$MONITOR_ID".position."$POSITION"

    # sleep 2s && easyeffects --gapplication-service
fi
