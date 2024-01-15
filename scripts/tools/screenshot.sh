#!/bin/bash
# requires: rofi, dunst, scrot, xclip

# define the directory for saved images
screenshot_directory=~/pictures/screenshots

# define the timestamp string for filenames
timestamp=$(date +"%Y%m%d-%H%M%S")

# define in seconds how long to wait before taking screenshot in `wait` option
wait_secs=3

# define any custom colors
foreground="#9f6a05"
background="#e3d533"

# define available options
copy="copy\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
save="save\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
wait="wait "$wait_secs""s"\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"

# load rofi with available options
main() {
    options_string="$copy\n$save\n$wait"
    choice=$(echo -e "$options_string" | rofi -dmenu -theme "icon-bar" \
    -theme-str 'listview {columns: 1; lines: 3;}' \
    -theme-str 'element {background-color: '$background';}')

    case 1 in
        $(echo "$choice" | grep -q "copy" && echo 1) )
            copy
            ;;
        $(echo "$choice" | grep -q "save" && echo 1) )
            save
            ;;
        $(echo "$choice" | grep -q "wait" && echo 1) )
            wait
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
wait() {
    dunstify -a manage-screenshot "Capturing full screen" "in $wait_secs seconds..." -t 1000
    sleep "$wait_secs"
    if scrot /tmp/screenshot.png; then
        xclip -selection clipboard -t image/png /tmp/screenshot.png
        rm /tmp/screenshot.png
        dunstify -a manage-screenshot "Screenshot taken" "Fullscreen copied to clipboard"
    else
        exit 0
    fi
}

main