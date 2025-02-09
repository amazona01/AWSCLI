#!/bin/bash
# Actualizar el sistema
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt install -y apache2 curl git unzip ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml
# Instalar las dependencias de WordPress
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update
# Instalar las dependencias de WordPress
sudo DEBIAN_FRONTEND=noninteractive apt install -y apache2 curl rsync git unzip ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp-cli

#Limpiar el directorio web de nuestro servicio
sudo rm -rf /var/www/html/*
sudo chmod -R 755 /var/www/html
sudo chown -R www-data:www-data /var/www/html

# Reiniciar Apache para aplicar cambios
sudo a2enmod rewrite
sudo systemctl restart apache2

rsync -avz -e "ssh -i /home/ubuntu/clave.pem" /var/www/html/uploads/ ec2-user@10.218.3.101:/var/www/html/uploads/











