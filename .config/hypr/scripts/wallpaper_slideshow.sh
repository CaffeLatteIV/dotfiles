#!/bin/bash

# Configuration
directory=$HOME/.config/hypr/wallpapers
interval=300 # Change every 5 minutes (in seconds)

while true; do
  # 1. Get a random image from the directory
  # 'find' looks for files, 'shuf' shuffles them, 'head' picks the first one
  random_wall=$(find -L "$directory" -type f -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" | shuf -n 1)
  # Check if a file was found
  if [ -z "$random_wall" ]; then
    echo "No wallpapers found in $directory"
    sleep 60
    continue
  fi

  echo "Changing wallpaper to: $random_wall"

  # 3. Apply the wallpaper to all connected monitors
  hyprctl hyprpaper wallpaper ",$random_wall,"

  # 5. Wait for the next interval
  sleep $interval
done
