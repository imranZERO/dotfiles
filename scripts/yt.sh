#!/bin/bash

# Function to send a notification
notify() {
    notify-send "Play YouTube Link" "$1" --icon=mpv
}

# For X11: Check if xclip is installed
if command -v xclip &> /dev/null; then
    link=$(xclip -selection clipboard -o)
# For Wayland: Check if wl-paste is installed
elif command -v wl-paste &> /dev/null; then
    link=$(wl-paste)
else
    notify "Clipboard utility (xclip or wl-paste) not found. Please install one."
    exit 1
fi

# Validate if the clipboard contains a URL
if [[ $link =~ ^https?://(www\.)?(youtube\.com|youtu\.be) ]]; then
    notify "Playing: $link"
    mpv "$link"
else
    notify "No valid YouTube link found in the clipboard."
    exit 1
fi
