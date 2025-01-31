<<<<<<< HEAD
#!/bin/bash
#preparar dns dinamico
# crear directorio
mkdir -p "$/home/ubuntu/duckdns/"
cd "/home/ubuntu/duckdns/"

# Crear script para actualizar la ip dinamicamente
echo "echo url=\"https://www.duckdns.org/update?domains=nginxequipo45&token=0b4bb411-ab26-4464-8a16-0d373fa6bf9c&ip=\" | curl -k -o /home/ubuntu/duckdns/duck.log -K -" > "/home/ubuntu/duckdns/duck.sh"
chmod 700 "/home/ubuntu/duckdns/duck.sh"

echo "echo url=\"https://www.duckdns.org/update?domains=openfire-equipo45&token=0b4bb411-ab26-4464-8a16-0d373fa6bf9c&ip=\" | curl -k -o /home/ubuntu/duckdns/duck.log -K -" > "/home/ubuntu/duckdns/duck2.sh"
chmod 700 "/home/ubuntu/duckdns/duck2.sh"

# Añadir al crontab
(crontab -l 2>/dev/null; echo "*/1 * * * * /home/ubuntu/duckdns/duck.sh >/dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * /home/ubuntu/duckdns/duck2.sh >/dev/null 2>&1") | crontab -

=======
>>>>>>> parent of 6e437fa (creacion del laboratorio)
#Instalación de Nginx
sudo apt update && sudo apt install nginx -y
#Configuración firewall
sudo ufw allow 'Nginx HTTP'

#clonar git
sudo git clone https://github.com/amazona01/AWSCLI.git

#mover configuraciones
sudo mv AWSCLI/configuraciones_servicios/nginx/wordpress /etc/nginx/sites-available/
sudo mv AWSCLI/configuraciones_servicios/nginx/default /etc/nginx/sites-available/

#symlinks 
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

#Restart Nginx 
sudo systemctl restart nginx

#Borrar
rm -rf AWSCLI