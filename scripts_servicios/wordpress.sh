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

sudo -u www-data wp-cli core download --path=/var/www/html



#sed -i '1s/<?php/<?php\\nif(isset($_SERVER[\\'HTTP_X_FORWARDED_FOR\\'])) {/' /var/www/html/wp-config.php,
#sed -i '2s/.*/    $list = explode(\\',\\',$_SERVER[\\'HTTP_X_FORWARDED_FOR\\']);/' /var/www/html/wp-config.php,
#sed -i '3s/.*/    $_SERVER[\\'REMOTE_ADDR\\'] = $list[0];/' /var/www/html/wp-config.php,
#sed -i '4s/.*/}/' /var/www/html/wp-config.php,
#sed -i '5s/.*/define(\\'WP_HOME\\',\\'https://nginxequipo45.duckdns.org\\');/' /var/www/html/wp-config.php,
#sed -i '6s/.*/define(\\'WP_SITEURL\\',\\'https://nginxequipo45.duckdns.org\\');/' /var/www/html/wp-config.php,
#sed -i '7s/.*/$_SERVER[\\'HTTP_HOST\\'] = \\'nginxequipo45.duckdns.org\\';/' /var/www/html/wp-config.php,
#sed -i '8s/.*/$_SERVER[\\'REMOTE_ADDR\\'] = \\'nginxequipo45.duckdns.org\\';/' /var/www/html/wp-config.php,
#sed -i '9s/.*/$_SERVER[\\'SERVER_ADDR\\'] = \\'nginxequipo45.duckdns.org\\';/' /var/www/html/wp-config.php,
#sed -i '10s/.*/if ($_SERVER[\\'HTTP_X_FORWARDED_PROTO\\'] == \\'https\\') $_SERVER[\\'HTTPS\\'] = \\'on\\';/' /var/www/html/wp-config.php







