#!/bin/bash

# Power menu options with Nerd Font icons
options=" Shutdown\n Reboot\n Lock\n Suspend"

# Launch Rofi using your Hack Nerd Font
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power" \
        -theme ~/.config/rofi/themes/power.rasi \
        -font "Hack Nerd Font 14")  # adjust size if needed

# Execute selected action
case "$chosen" in
    " Shutdown") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    " Lock") hyprlock ;;      # or swaylock
    " Suspend") systemctl suspend ;;
esac
