apt update && apt install -y mysql-server

sudo mysql -u root -e "CREATE DATABASE openfire;"
sudo mysql -u root -e "source /var/lib/openfire/openfire.sql"
sudo mysql -u root -e "CREATE USER 'openfire'@'10.0.2.100' IDENTIFIED BY '_Admin123';"
sudo mysql -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON openfire.* TO 'openfire'@'10.0.2.100';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"





#!/bin/bash
set -x  # Activar modo de depuración
 
# Variables desde Terraform 
role="${role}"
primary_ip="${primary_ip}"
secondary_ip="${secondary_ip}"
db_user="${db_user}"
db_password="${db_password}"
db_name="${db_name}"
repl_user="${repl_user}"
repl_password="${repl_password}"
ssh_key_name="${ssh_key_name}"
private_key="${private_key}"
 
# 1. Configurar clave SSH
mkdir -p /home/ubuntu/.ssh
echo "${private_key}" > /home/ubuntu/.ssh/${ssh_key_name}
chmod 600 /home/ubuntu/.ssh/${ssh_key_name}
 
# 2. Instalar MySQL
sudo apt-get update > /dev/null
sudo apt-get install -y mysql-server mysql-client > /dev/null
 
# 3. Configurar replicación
sudo tee /etc/mysql/mysql.conf.d/replication.cnf > /dev/null
[mysqld]
bind-address = 0.0.0.0
server-id = ${role == "primary" ? 1 : 2}
log_bin = /var/log/mysql/mysql-bin.log
binlog_format = ROW
relay-log = /var/log/mysql/mysql-relay-bin
EOF
 
# 4. Reiniciar servicio
sudo systemctl restart mysql

    # Esperar conexión con primario
    until nc -z 10.218.2.200 3306; do sleep 10; done 
    # Copiar archivo de estado
    scp -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/${ssh_key_name} ubuntu@10.218.2.200:/tmp/master_status.txt /tmp/
 
    # Leer el archivo de estado y configurar replicación
    MASTER_STATUS=$(cat /tmp/master_status.txt)
    binlog_file=$(echo "$MASTER_STATUS" | awk '{print $1}')
    binlog_pos=$(echo "$MASTER_STATUS" | awk '{print $2}')
 
    sudo mysql -u root -p_Admin123 -e
    CHANGE MASTER TO
    MASTER_HOST='${primary_ip}',
    MASTER_USER='${repl_user}',
    MASTER_PASSWORD='${repl_password}',
    MASTER_LOG_FILE='$binlog_file',
    MASTER_LOG_POS=$binlog_pos;
    START SLAVE;
 
sudo systemctl enable mysql > /dev/null