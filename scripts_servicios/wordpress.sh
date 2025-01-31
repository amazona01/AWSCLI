#!/bin/bash

# Actualizar el sistema
<<<<<<< HEAD
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update
# Instalar las dependencias de WordPress
sudo DEBIAN_FRONTEND=noninteractive apt install -y apache2 curl git unzip ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml
=======
sudo apt update -y

# Instalar las dependencias de WordPress
sudo apt install -y apache2 ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xm>
>>>>>>> parent of 6e437fa (creacion del laboratorio)

# Crear directorio para WordPress
sudo mkdir -p /srv/www
sudo chown www-data:www-data /srv/www

# Descargar e instalar WordPress
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

# Crear archivo de configuración de Apache para WordPress
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<EOL
<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOL

# Habilitar el sitio de WordPress en Apache y habilitar mod_rewrite
sudo a2ensite wordpress
sudo a2enmod rewrite

# Opcional: Deshabilitar el sitio por defecto (000-default.conf)
sudo a2dissite 000-default

# Recargar Apache para aplicar cambios
sudo service apache2 reload

# Configuración de MySQL para WordPress
sudo mysql -u root -e "CREATE DATABASE wordpress;"
sudo mysql -u root -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'admin123';"
sudo mysql -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON wordpress.* TO 'wordpress'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# Configurar el archivo wp-config.php
sudo cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php

# Editar wp-config.php para configurar la base de datos
sudo sed -i "s/database_name_here/wordpress/" /srv/www/wordpress/wp-config.php
sudo sed -i "s/username_here/wordpress/" /srv/www/wordpress/wp-config.php
sudo sed -i "s/password_here/admin123/" /srv/www/wordpress/wp-config.php
sudo sed -i "s/localhost/localhost/" /srv/www/wordpress/wp-config.php

# Asegurarse de que los permisos sean correctos
sudo chown -R www-data:www-data /srv/www/wordpress
sudo chmod -R 755 /srv/www/wordpress

# Reiniciar Apache para aplicar cambios
sudo systemctl restart apache2

<<<<<<< HEAD
=======
# Verificar que MySQL y Apache estén activos
sudo systemctl status mysql
sudo systemctl status apache2

>>>>>>> parent of 6e437fa (creacion del laboratorio)
echo "La instalación de WordPress se ha completado. Accede a tu sitio en http://<tu_dominio_o_IP> para completar la configuración."


