#!/bin/bash

bat=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

<<<<<<< HEAD
if [[ "$status" == "Charging" ]]; then
    icon=""
elif [[ "$bat" -ge 90 ]]; then
    icon=""
elif [[ "$bat" -ge 70 ]]; then
    icon=""
elif [[ "$bat" -ge 40 ]]; then
    icon=""
elif [[ "$bat" -ge 10 ]]; then
    icon=""
else
    icon=""
fi

echo "$icon $bat%"
=======
if [[ "$status" != "Discharging" ]]; then
    icon="󰚥"
else
    if [[ "$bat" -ge 90 ]]; then
        icon="󰂂"
    elif [[ "$bat" -ge 70 ]]; then
        icon="󰂀"
    elif [[ "$bat" -ge 40 ]]; then
        icon="󰁽"
    elif [[ "$bat" -ge 10 ]]; then
        icon="󰁺"
    else
        icon="󰁹"
    fi
fi

echo "| $icon $bat% |"
>>>>>>> 07cf3df (i3)
