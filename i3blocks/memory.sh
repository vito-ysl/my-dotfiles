#!/bin/bash

# Função para obter o uso da memória
get_memory_usage() {
    # Obtém informações da memória
    total=$(free | grep Mem | awk '{print $2}')
    used=$(free | grep Mem | awk '{print $3}')
    
    # Calcula a porcentagem de uso
    usage_percent=$(echo "scale=1; $used * 100 / $total" | bc)
    echo "${usage_percent%.*}"
}

memory_usage=$(get_memory_usage)
memory_icon=""

echo "| $memory_icon ${memory_usage}% |"
