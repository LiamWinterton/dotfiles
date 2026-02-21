#!/bin/bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

while true; do
	# Find all images in dir and pick a random one
	RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

	# Make sure a wallpaper was actually found before proceeding
    if [ -n "$RANDOM_WALLPAPER" ]; then
		# Query hyprland for all active monitors and apply the wallpaper to each
        for monitor in $(hyprctl monitors | awk '/^Monitor/{print $2}'); do
            hyprctl hyprpaper wallpaper "$monitor,$RANDOM_WALLPAPER"
        done
    fi

    # Wait for 5 minutes (300 seconds) before repeating
    sleep 300
done
