#!/bin/bash

frames=(
" sudo su -               "
" ssh root@192.168.1.10   "
" nmap -sS 192.168.1.0/24 "
" ping -c 4 10.0.0.5      "
" ./exploit.sh            "
" chmod +x rootkit        "
" ./rootkit               "
" id                      "
" whoami                  "
" sudo -i                 "
)

index=$(( $(date +%s) % ${#frames[@]} ))

echo "${frames[$index]}"
