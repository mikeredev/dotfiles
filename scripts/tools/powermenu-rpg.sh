#!/bin/bash

lock=""
suspend="󰤄"
reboot=""
logout="󰍃"
hibernate="󰏤"
poweroff=""
host="`cat /etc/hostname`"

rofi_cmd(){
    rofi -dmenu -theme "powermenu-rpg" -p "Press ESC to cancel" -mesg "Do you want to save your progress?"
}

rofi_confirm(){
    echo -e "\n" |
    rofi -theme-str 'mainbox {orientation: horizontal; children: [ mainnav, sidenav ];}' \
        -theme-str 'window {padding: 0px 0px 10px 0px;}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
        -dmenu -mesg "Are you sure?" -theme "powermenu-rpg"
}

main(){
    options="$lock\n$suspend\n$reboot\n$logout\n$hibernate\n$poweroff"
    selected=$(echo -e "$options" | rofi_cmd)

    case "$selected" in
        "$lock")
            i3lock -efti ~/Pictures/wallpapers/lockscreen.png
            ;;
        "$suspend")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "" ]; then
                i3lock -efti ~/Pictures/wallpapers/lockscreen.png && systemctl suspend
            else
                return
            fi
            ;;
        "$reboot")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "" ]; then
                systemctl reboot
            else
                return
            fi
            ;;
        "$logout")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "" ]; then
                i3-msg exit
            else
                return
            fi
            ;;
        "$hibernate")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "" ]; then
                i3lock -efti ~/Pictures/wallpapers/lockscreen.png && systemctl hibernate
            else
                return
            fi
            ;;
        "$poweroff")
            confirm=$(rofi_confirm)
            if [ "$confirm" == "" ]; then
                systemctl poweroff
            else
                return
            fi
            ;;
        *)
            ;;
    esac
}

main