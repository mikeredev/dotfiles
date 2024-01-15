#!/bin/bash

# define any custom colors
foreground="#9f6a05"
background="#e3d533"
selected="#ffffff"

# define available options
cycle="cycle\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
split="split\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
stacking="stacking\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"
tabbed="tabbed\0icon\x1f<span font='Font Awesome 6 Free Regular' color='$foreground'></span>"

# main function
rofi_main() {
    options_string="$cycle\n$split\n$stacking\n$tabbed"
    choice=$(echo -e "$options_string" | rofi -dmenu -theme "icon-bar" \
        -theme-str 'listview {columns: 1; lines: 4;}' \
        -theme-str 'element {background-color: '$background';}' \
        -theme-str 'element selected {border-color: '$selected';}' \
        -markup-rows)

    case 1 in
        $(echo "$choice" | grep -q "cycle" && echo 1) )
            i3-msg layout toggle
            rofi_main
            ;;
        $(echo "$choice" | grep -q "split" && echo 1) )
            i3-msg layout toggle split
            ;;
        $(echo "$choice" | grep -q "stacking" && echo 1) )
            i3-msg layout stacking
            ;;
        $(echo "$choice" | grep -q "tabbed" && echo 1) )
            i3-msg layout tabbed
            ;;
        *)
            exit 0
            ;;
    esac
}

# main entry point to script
rofi_main