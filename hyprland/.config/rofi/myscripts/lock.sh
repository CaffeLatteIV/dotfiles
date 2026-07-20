#!/bin/bash

# Theme Elements
theme="$HOME/.config/rofi/catppuccin-lock.rasi"
host=$(whoami)
uptime=$(uptime -p | sed -e 's/up //g')

# Prompt Text
prompt="Hi, $host"

# Icons (Nerd Font)
shutdown='  Shutdown'
reboot='󰑓  Reboot'
lock='  Lock'
suspend='  Suspend'
logout='󰗽  Logout'
yes=' Yes'
no=' No'

# Rofi Command
rofi_cmd() {
    rofi -dmenu \
        -p "$prompt" \
        -mesg "Uptime: $uptime" \
        -theme "${theme}"
}

# Confirmation Command
confirm_cmd() {
    rofi -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you sure?' \
        -theme "${theme}" \
        -theme-str 'window {width: 350px; height: 210px;}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}'
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Execution Logic
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--logout' ]]; then
            hyprctl dispatch exit
        elif [[ $1 == '--suspend' ]]; then
            # Optional: Pause media players before suspend
            # playerctl pause-all
            systemctl suspend
        fi
    else
        exit 0
    fi
}

# Options List (Ordered: Shutdown -> Reboot -> Logout -> Suspend -> Lock)
options="$shutdown\n$reboot\n$logout\n$suspend\n$lock"

# Run Rofi
chosen="$(echo -e "$options" | rofi_cmd)"

# Handle Selection
case $chosen in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $logout)
        run_cmd --logout
        ;;
    $suspend)
        run_cmd --suspend
        ;;
    $lock)
        hyprlock
        ;;
esac
