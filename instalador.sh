#!/bin/bash
clear
echo "🔧 Instalando o Painel MARCONES_MS..."

# Atualizando sistema e instalando dependências
apt-get update -y > /dev/null
apt-get install -y curl net-tools vnstat speedtest-cli unzip > /dev/null 2>&1

# Baixando o script do GitHub
cd /usr/local/bin || exit
wget -O marcones_ms https://raw.githubusercontent.com/Marconesds1/script_marcones_ms/main/script.sh > /dev/null 2>&1
chmod +x marcones_ms

# Rodando o painel
clear
marcones_ms
