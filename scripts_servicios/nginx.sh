#Instalación de Nginx
sudo apt update && sudo apt install nginx -y
#Configuración firewall
sudo ufw allow 'Nginx HTTP'

#clonar git
sudo git clone https://github.com/amazona01/AWSCLI.git

#mover configuraciones
sudo mv AWSCLI/configuraciones_servicios/wordpress /etc/nginx/sites-available/
sudo mv AWSCLI/configuraciones_servicios/default /etc/nginx/sites-available/

#symlinks 
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

#Restart Nginx 
sudo systemctl restart nginx

#Borrar
rm -rf AWSCLI