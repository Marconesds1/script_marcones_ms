#!/bin/bash
clear
echo "🔧 Instalando o Painel MARCONES_MS..."
apt-get update -y > /dev/null
apt-get install -y curl net-tools vnstat speedtest-cli unzip > /dev/null 2>&1
cd /usr/local/bin || exit
wget -O marcones_ms https://raw.githubusercontent.com/MARCONES-MS/scripts/main/script.sh > /dev/null 2>&1
chmod +x marcones_ms
clear
marcones_ms
