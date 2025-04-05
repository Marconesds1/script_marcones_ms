#!/bin/bash
cd /opt || exit
git clone https://github.com/Marconesds1/script_marcones_ms.git MARCONES_MS
cd MARCONES_MS || exit
chmod +x script.sh
ln -s /opt/MARCONES_MS/script.sh /usr/local/bin/marcones
echo "Instalação concluída. Use o comando: marcones"
