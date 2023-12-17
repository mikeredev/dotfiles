#!/bin/bash

lock=""
suspend="󰤄"
reboot=""
logout="󰍃"
hibernate="󰏤"
poweroff=""
host="`cat /etc/hostname`"

rofi_cmd(){
    rofi -dmenu -theme "powermenu" -mesg "$host > $USER $"
}

rofi_confirm(){
    echo -e "󰔓\n󰔑" |
    rofi -theme-str 'mainbox {orientation: vertical; children: [ message, listview ];}' \
        -theme-str 'window {padding: 10em 45em 40em 45em;}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
        -dmenu -mesg "are u sure?" -theme "powermenu"
}

rofi_run(){
    options="$lock\n$suspend\n$reboot\n$logout\n$hibernate\n$poweroff"
    selected=$(echo -e "$options" | rofi_cmd)

    case "$selected" in
        "$lock")
            i3lock -efti ~/Pictures/wallpapers/lockscreen.png
            ;;
        "$suspend")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "󰔓" ]; then
                i3lock -efti ~/Pictures/wallpapers/lockscreen.png && systemctl suspend
            else
                return
            fi
            ;;
        "$reboot")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "󰔓" ]; then
                systemctl reboot
            else
                return
            fi
            ;;
        "$logout")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "󰔓" ]; then
                i3-msg exit
            else
                return
            fi
            ;;
        "$hibernate")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "󰔓" ]; then
                i3lock -efti ~/Pictures/wallpapers/lockscreen.png && systemctl hibernate
            else
                return
            fi
            ;;
        "$poweroff")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "󰔓" ]; then
                systemctl poweroff
            else
                return
            fi
            ;;
        *)
            ;;
    esac
}

rofi_run
