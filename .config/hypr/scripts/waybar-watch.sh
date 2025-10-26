#!/bin/bash

# Ensure only one watcher runs
if pgrep -f "waybar-watch.sh" | grep -v $$ > /dev/null; then
    echo "Watcher already running."
    exit 0
fi

# Start Waybar if it's not already running
pgrep waybar > /dev/null || waybar &

# Watch for changes and send reload signal
while inotifywait -r -e close_write,modify,create,delete ~/.config/waybar/; do
    echo "Reloading Waybar..."
    pkill -SIGUSR2 waybar
done

