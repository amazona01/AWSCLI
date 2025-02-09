#!/bin/bash
set -x  # Activar modo de depuración

# Variables desde Terraform 
role="${role}"
primary_ip="10.218.2.200"
secondary_ip="10.218.2.201"
db_user="openfire"
db_password="_Admin123"
db_name="openfire"
repl_user="openfire"
repl_password="_Admin123"
ssh_key_path="/home/ubuntu/clave.pem"

# 1. Configurar clave SSH
chmod 600 $ssh_key_path

# 2. Instalar MySQL
sudo apt-get update > /dev/null 2>&1
sudo apt-get install -y mysql-server mysql-client > /dev/null 2>&1

# 3. Configurar replicación
if [ "$role" = "primary" ]; then
    server_id=1
else
    server_id=2
fi

sudo tee /etc/mysql/mysql.conf.d/replication.cnf > /dev/null <<EOF
[mysqld]
bind-address = 0.0.0.0
server-id = $server_id
log_bin = /var/log/mysql/mysql-bin.log
binlog_format = ROW
relay-log = /var/log/mysql/mysql-relay-bin
EOF

# 4. Reiniciar servicio
sudo systemctl restart mysql

# 5. Configuración básica de seguridad
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$db_password';
DELETE FROM mysql.user WHERE User='';
CREATE DATABASE IF NOT EXISTS $db_name;
FLUSH PRIVILEGES;
EOF

# 6. Configuración específica por rol
if [ "$role" = "primary" ]; then
    sudo mysql -u root -p$db_password <<EOF
    CREATE USER '$db_user'@'%' IDENTIFIED WITH mysql_native_password BY '$db_password';
    GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'%';
    CREATE USER '$repl_user'@'%' IDENTIFIED WITH mysql_native_password BY '$repl_password';
    GRANT REPLICATION SLAVE ON *.* TO '$repl_user'@'%';
    FLUSH PRIVILEGES;
EOF

    sudo mysql -u root -p$db_password -e "SHOW MASTER STATUS" | awk 'NR==2 {print $1, $2}' > /tmp/master_status.txt

elif [ "$role" = "secondary" ]; then
    until nc -z $primary_ip 3306; do sleep 10; done

    scp -o StrictHostKeyChecking=no -i $ssh_key_path ubuntu@$primary_ip:/tmp/master_status.txt /tmp/

    MASTER_STATUS=$(cat /tmp/master_status.txt)
    binlog_file=$(echo "$MASTER_STATUS" | awk '{print $1}')
    binlog_pos=$(echo "$MASTER_STATUS" | awk '{print $2}')

    sudo mysql -u root -p$db_password <<EOF
    CHANGE MASTER TO
    MASTER_HOST='$primary_ip',
    MASTER_USER='$repl_user',
    MASTER_PASSWORD='$repl_password',
    MASTER_LOG_FILE='$binlog_file',
    MASTER_LOG_POS=$binlog_pos;
    START SLAVE;
EOF
fi

# 7. Habilitar servicio
sudo systemctl enable mysql > /dev/null 2>&1
