#!/bin/bash
# requires: rofi, dunst, scrot, xclip

# define the directory for saved images
screenshot_directory=~/pictures/screenshots

# define the timestamp string for filenames
timestamp=$(date +"%Y%m%d-%H%M%S")

# define available options
copy=""
save=""
soon=""

# load rofi with available options
main() {
    options_string="$copy\n$save\n$soon"
    selected=$(echo -e "$options_string" | rofi -dmenu -theme "system-menu")

    case $selected in
        "$copy")
            copy
            ;;
        "$save")
            save
            ;;
        "$soon")
            soon 3
            ;;
        *)
            exit 0
            ;;
    esac
}

# function to copy an area of the screen
copy() {
    if scrot -s /tmp/screenshot.png; then
        xclip -selection clipboard -t image/png /tmp/screenshot.png
        rm /tmp/screenshot.png
        dunstify -a manage-screenshot "Screenshot taken" "Area copied to clipboard"
    else
        exit 0
    fi
}

# function to save an area of the screen
save() {
    if scrot -s /tmp/screenshot.png; then
        xclip -selection clipboard -t image/png /tmp/screenshot.png
        mv /tmp/screenshot.png "$screenshot_directory/screenshot_${timestamp}.png"
        dunstify -a manage-screenshot "Screenshot saved" "$screenshot_directory/screenshot_${timestamp}.png"
    else
        exit 0
    fi
}

# function to wait n seconds and copy the full screen
soon() {
    local wait_seconds="$1"
    dunstify -a manage-screenshot "Capturing full screen" "in $wait_seconds seconds..." -t 1000
    sleep "$wait_seconds"
    if scrot /tmp/screenshot.png; then
        xclip -selection clipboard -t image/png /tmp/screenshot.png
        rm /tmp/screenshot.png
        dunstify -a manage-screenshot "Screenshot taken" "Fullscreen copied to clipboard"
    else
        exit 0
    fi
}

main