#!/bin/bash

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
