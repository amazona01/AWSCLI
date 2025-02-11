#!/bin/bash    

# Configuration variables
REMOTE_DB_SERVER="10.218.2.200"
REMOTE_DB_PATH="/var/lib/mysql/openfire"
LOCAL_PATH="/home/ubuntu/backups/"
BACKUP_DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="mysql_backup_$BACKUP_DATE.tar.gz"
REMOTE_SNAPSHOT_FILE="/tmp/mysql_snapshot.snar"
TEMP_SNAPSHOT_FILE="/tmp/temp_snapshot.snar"

# SSH options to disable strict host key checking and specify private key
SSH_OPTIONS="-o StrictHostKeyChecking=no -i /home/ubuntu/clave.pem"

# Create the local backup directory if it doesn't exist
if [ ! -d "$LOCAL_PATH" ]; then
  mkdir -p "$LOCAL_PATH"
fi

# Check if the snapshot file exists on the remote server
if ssh $SSH_OPTIONS ubuntu@$REMOTE_DB_SERVER "[ ! -f $REMOTE_SNAPSHOT_FILE ]"; then
  echo "Performing full backup..."
  # Full backup (no snapshot file exists)
  ssh $SSH_OPTIONS ubuntu@$REMOTE_DB_SERVER "sudo tar --listed-incremental=$TEMP_SNAPSHOT_FILE -czf - -C / $REMOTE_DB_PATH" > "$LOCAL_PATH/$BACKUP_FILE"
  
  # Move the temporary snapshot file to the final location
  ssh $SSH_OPTIONS ubuntu@$REMOTE_DB_SERVER "sudo mv $TEMP_SNAPSHOT_FILE $REMOTE_SNAPSHOT_FILE"
else
  echo "Performing incremental backup..."
  # Incremental backup (snapshot file exists)
  ssh $SSH_OPTIONS ubuntu@$REMOTE_DB_SERVER "sudo tar --listed-incremental=$REMOTE_SNAPSHOT_FILE -czf - -C / $REMOTE_DB_PATH" > "$LOCAL_PATH/$BACKUP_FILE"
fi

# limpiar las viejas
find "$LOCAL_PATH" -name "mysql_backup_*.tar.gz" -mtime +7 -exec rm {} \;

echo "Backup process completed successfully."
