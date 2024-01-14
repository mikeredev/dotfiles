#!/bin/bash

# define any custom colors
foreground="#9f6a05"
background="#e3d533"
selected="#ffffff"

# define choices
lock="lock\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
sleep="sleep\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
reboot="reboot\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
i3_reload="i3 reload\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
i3_restart="i3 restart\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
poweroff="poweroff\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"

# function to confirm user action
rofi_confirm(){
    local selection="$1"
    echo -e "$selection?\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>\n$selection?\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>" |
    rofi -dmenu -theme "icon-bar" \
        -theme-str 'window {width: 100px;}' \
        -theme-str 'listview {columns: 1; lines: 2;}' \
        -theme-str 'element {background-color: '$background';}' \
        -theme-str 'element selected {border-color: '$selected';}'
}

# main function
rofi_main() {
    options_string="$lock\n$sleep\n$reboot\n$i3_reload\n$i3_restart\n$poweroff"
    choice=$(echo -e "$options_string" | rofi -dmenu -theme "icon-bar" \
        -theme-str 'window {width: 100px;}' \
        -theme-str 'listview {columns: 1; lines: 6;}' \
        -theme-str 'element {background-color: '$background';}' \
        -theme-str 'element selected {border-color: '$selected';}')

    case 1 in
        $(echo "$choice" | grep -q "lock" && echo 1) )
            i3lock -efti ~/pictures/wallpapers/lockscreen.png
            ;;

        $(echo "$choice" | grep -q "sleep" && echo 1) )
            confirm=$(rofi_confirm sleep)
            if echo $confirm | grep -e $choice; then
                i3lock -efti ~/pictures/wallpapers/lockscreen.png && systemctl suspend
            else
                return
            fi
            ;;

        $(echo "$choice" | grep -q "reload" && echo 1) )
            i3-msg reload > /dev/null 2>&1
            dunstify -a "i3wm" -u low "i3" "configuration reloaded"
            ;;

        $(echo "$choice" | grep -q "restart" && echo 1) )
            dunstify -a "i3wm" -u low "i3" "restarted"
            i3-msg restart
            ;;

        $(echo "$choice" | grep -q "reboot" && echo 1) )
            confirm=$(rofi_confirm reboot)
            if echo $confirm | grep -e $choice; then
                systemctl reboot
            else
                return
            fi
            ;;

        $(echo "$choice" | grep -q "poweroff" && echo 1) )
            confirm=$(rofi_confirm poweroff)
            if echo $confirm | grep -e $choice; then
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