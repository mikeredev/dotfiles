#!/bin/bash

# define any custom colors
foreground="#9f6a05"
background="#e3d533"
selection="#ffffff"

# define choices
lock="lock\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
suspend="suspend\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'>󰤄</span>"
reboot="reboot\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
i3_reload="i3 reload\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
i3_restart="i3 restart\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
poweroff="poweroff\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"

# function to confirm user action
rofi_confirm(){
    echo -e "ok\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>\ncancel\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>" |
    rofi -dmenu -theme "icon-bar" \
        -theme-str 'listview {columns: 1; lines: 2;}' \
        -theme-str 'element {background-color: '$background';}' \
        -theme-str 'element selected {border-color: '$selection';}'
}

# main function
rofi_main() {
    options="$lock\n$suspend\n$reboot\n$i3_reload\n$i3_restart\n$poweroff"
    selected=$(echo -e "$options" | rofi -dmenu -theme "icon-bar" \
        -theme-str 'listview {columns: 1; lines: 6;}' \
        -theme-str 'element {background-color: '$background';}' \
        -theme-str 'element selected {border-color: '$selection';}')

    case "$selected" in
        "lock")
            i3lock -efti ~/pictures/wallpapers/lockscreen.png
            ;;

        "suspend")
            if [ "$(rofi_confirm)" == "ok" ]; then
                echo "i3lock -efti ~/pictures/wallpapers/lockscreen.png && systemctl suspend"
            else
                return
            fi
            ;;
        
        "reboot")
            if [ "$(rofi_confirm)" == "ok" ]; then
                systemctl reboot
            else
                return
            fi
            ;;

        "i3 reload")
            i3-msg reload
            ;;

        "i3 restart")
            i3-msg restart
            ;;
        
        "poweroff")
            if [ "$(rofi_confirm)" == "ok" ]; then
                systemctl poweroff
            else
                return
            fi
            ;;
        
        *)
            exit 0
            ;;
        esac
}

# main entry point to script
rofi_main