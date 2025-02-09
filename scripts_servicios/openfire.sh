#!/bin/bash

# Actualiza el sistema y asegura que los paquetes necesarios estén instalados
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
# Instalar OpenJDK 17 y MySQL
sudo DEBIAN_FRONTEND=noninteractive apt install -y openjdk-11-jre default-jre-headless mysql-client wget

# Descargar e instalar Openfire
wget https://download.igniterealtime.org/openfire/openfire_4.9.2_all.deb
sudo dpkg -i openfire_4.9.2_all.deb

sudo apt-get --fix-broken install -y

# Habilitar y arrancar el servicio de Openfire
sudo systemctl enable openfire
sudo systemctl start openfire
