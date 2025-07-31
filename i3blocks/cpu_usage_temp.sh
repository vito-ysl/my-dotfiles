#!/bin/bash

<<<<<<< HEAD
# Primeira leitura do /proc/stat
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
prev_idle=$idle
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

sleep 0.5

# Segunda leitura do /proc/stat
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
idle2=$idle
total=$((user + nice + system + idle + iowait + irq + softirq + steal))

# Diferenças
totald=$((total - prev_total))
idled=$((idle2 - prev_idle))

cpu_usage=$((100 * (totald - idled) / totald))

# Temperatura CPU
temp=$(awk '{printf "%d°C", $1/1000}' /sys/class/hwmon/hwmon2/temp1_input)

# Uso memória (em %)
mem_usage=$(free -m | awk 'NR==2{printf "%.0f%%", $3*100/$2 }')

echo " ${cpu_usage}% | 🌡 $temp |  $mem_usage"
=======
# Função para obter o uso da CPU
get_cpu_usage() {
    if command -v mpstat >/dev/null 2>&1; then
        cpu_usage=$(mpstat 1 1 | awk 'NR==4 {print int(100-$NF)}')
    elif command -v top >/dev/null 2>&1; then
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
    else
        cpu_usage=$(cat /proc/loadavg | awk '{print int($1*100/4)}')
    fi
    echo "$cpu_usage"
}

# Função para obter a temperatura da CPU
get_cpu_temp() {
    # Tenta diferentes caminhos para temperatura
    if [ -f "/sys/class/thermal/thermal_zone0/temp" ]; then
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        temp_c=$(echo "scale=1; $temp/1000" | bc)
    elif [ -f "/sys/class/hwmon/hwmon0/temp1_input" ]; then
        temp=$(cat /sys/class/hwmon/hwmon0/temp1_input)
        temp_c=$(echo "scale=1; $temp/1000" | bc)
    elif [ -f "/sys/class/hwmon/hwmon1/temp1_input" ]; then
        temp=$(cat /sys/class/hwmon/hwmon1/temp1_input)
        temp_c=$(echo "scale=1; $temp/1000" | bc)
    else
        temp_c="N/A"
    fi
    echo "$temp_c"
}

# Obtém os valores
cpu_usage=$(get_cpu_usage)
cpu_temp=$(get_cpu_temp)

# Define ícones baseados na temperatura
if [ "$cpu_temp" != "N/A" ]; then
    if (( $(echo "$cpu_temp >= 80" | bc -l) )); then
        temp_icon="󰈸 "
    elif (( $(echo "$cpu_temp >= 60" | bc -l) )); then
        temp_icon=" "
    else
        temp_icon=" "
    fi
else
    temp_icon=" ❓ "
fi

cpu_icon="CPU "

# Formata a saída
if [ "$cpu_temp" != "N/A" ]; then
    echo "| $cpu_icon ${cpu_usage}% | $temp_icon${cpu_temp}°C |"
else
    echo "| $cpu_icon ${cpu_usage}% | $temp_icon${cpu_temp} |"
fi
>>>>>>> 07cf3df (i3)
