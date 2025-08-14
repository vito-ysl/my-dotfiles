#!/bin/bash

iDIR="$HOME/.config/dunst/icons/vol"

# Get Volume
get_volume() {
    if amixer get Master | grep -q '\[off\]'; then
        echo " "
    else
        volume=$(amixer get Master | grep -o -m 1 '[0-9]*%' | tr -d '%')
        echo "  $volume%"
    fi
}

# get icon
get_icon() {
    current=$(amixer get Master | grep -o -m 1 '[0-9]*%' | tr -d '%')
    if amixer get Master | grep -q '\[off\]'; then
        echo "$iDIR/muted-speaker.svg"
    else
        icon_level=$(( (current + 4) / 5 * 5 ))  # arredonda para o múltiplo de 5 mais próximo
        if [ "$icon_level" -gt 100 ]; then icon_level=100; fi
        echo "$iDIR/vol-$icon_level.svg"
    fi
}

# Notify
notify_user() {
    if [[ "$(get_volume)" == " " ]]; then
        notify-send -a -r -h string:x-dunst-stack-tag:volume_notif -i "$(get_icon)" "Volume: Muted"
    else
        notify-send -a -r -h string:x-dunst-stack-tag:volume_notif -i "$(get_icon)" "Volume: $(get_volume)"
    fi
}

# Increase Volume
inc_volume() {
    amixer set Master 5%+ > /dev/null
    notify_user
}

# Decrease Volume
dec_volume() {
    amixer set Master 5%- > /dev/null
    notify_user
}

# Toggle Mute
toggle_mute() {
    amixer set Master toggle > /dev/null
    if amixer get Master | grep -q '\[off\]'; then
        notify-send -a -h -i "$iDIR/muted-speaker.svg" "Volume Switched OFF"
    else
        notify-send -a -h -i "$iDIR/unmuted-speaker.svg" "Volume Switched ON"
    fi
}

# Toggle Mic
toggle_mic() {
    if amixer get Capture | grep -q '\[on\]'; then
        amixer set Capture nocap > /dev/null
        notify-send -e -u low -i "$iDIR/muted-mic.svg" "Microphone Switched OFF"
    else
        amixer set Capture cap > /dev/null
        notify-send -e -u low -i "$iDIR/unmuted-mic.svg" "Microphone Switched ON"
    fi
}

# Get Mic Icon
get_mic_icon() {
    if amixer get Capture | grep -q '\[on\]'; then
        echo "$iDIR/unmuted-mic.svg"
    else
        echo "$iDIR/muted-mic.svg"
    fi
}

# Get Microphone Volume (simulado com Capture)
get_mic_volume() {
    if amixer get Capture | grep -q '\[on\]'; then
        volume=$(amixer get Capture | grep -o -m 1 '[0-9]*%' | tr -d '%')
        echo "$volume%"
    else
        echo "Muted"
    fi
}

# Notify for Microphone
notify_mic_user() {
    volume=$(get_mic_volume)
    icon=$(get_mic_icon)
    notify-send -a -r 91190 -t 800 -i "$icon" "Mic=vel: $volume"
}

# Increase MIC Volume
inc_mic_volume() {
    amixer set Capture 5%+ > /dev/null
    amixer set Capture cap > /dev/null
    notify_mic_user
}

# Decrease MIC Volume
dec_mic_volume() {
    amixer set Capture 5%- > /dev/null
    amixer set Capture cap > /dev/null
    notify_mic_user
}

# Execute accordingly
case "$1" in
    --get) get_volume ;;
    --inc) inc_volume ;;
    --dec) dec_volume ;;
    --toggle) toggle_mute ;;
    --toggle-mic) toggle_mic ;;
    --get-icon) get_icon ;;
    --get-mic-icon) get_mic_icon ;;
    --mic-inc) inc_mic_volume ;;
    --mic-dec) dec_mic_volume ;;
    *) get_volume ;;
esac
