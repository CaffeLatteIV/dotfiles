#!/bin/bash

directory="$HOME/Pictures/wallpapers"
interval=300

echo "Starting wallpaper daemon"

while true; do
  # Le parentesi sfuggite \( \) raggruppano le estensioni per una ricerca più sicura
  random_wall=$(find -L "$directory" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf -n 1)

  if [ -z "$random_wall" ]; then
    # >&2 invia l'output allo stderr, systemd lo marcherà automaticamente come errore
    echo "ERROR: No wallpaper found in $directory" >&2
    sleep 60
    continue
  fi

  echo "Applying: $random_wall"
  hyprctl hyprpaper wallpaper ",$random_wall"

  sleep $interval
done
