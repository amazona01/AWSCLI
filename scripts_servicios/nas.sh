#!/bin/bash
# Cambiar a root
sudo su
# instalar mdadm
apt-get update
apt-get install -y mdadm
# crear RAID1
mdadm --create --verbose /dev/md0 --level=1 --name=backups --raid-devices=2 /dev/xvdf /dev/xvdg <<EOF
y
EOF
# Esperar al RAID1
sleep 10
# Formatearle con ext4
mkfs.ext4 /dev/md0
# montar el RAID1
mkdir -p /mnt/raid1
mount /dev/md0 /mnt/raid1
# Conseguir el UUID del RAID1
UUID=$(blkid -s UUID -o value /dev/md0)
# añadir el punto de montaje a /etc/fstab para persistencia en reinicios
echo "UUID=$UUID  /mnt/raid1  ext4  defaults,nofail  0  0" >> /etc/fstab
# Guardar la configuracion 
mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf
# actualizar initramfs para incluir la configuracion de RAID 
update-initramfs -u
