#Particion de disco
sudo fdisk /dev/sdc

#Primera particion
n
p
ENTER
ENTER
+1G
#Segunda particion
n
p
ENTER
ENTER
+1G
#Tercera particion
n
p
ENTER
ENTER
+1G
#Particion Extendida(Particion n°4)
n
e
ENTER
+3G
#Quinta Particion
n
ENTER
+1.5G
#Sexta Particion
n
ENTER
+1.5G
#Guardar Particiones
w

#Cambiar el sistema de archivo de la primera particion a swap
sudo fdisk /dev/sdc
t
1
82
w

#Vemos la memoria ram
free -h

#Destinarla como swap
sudo mkswap /dev/sdc1

#Habilitar la memoria swap
sudo swapon /dev/sdc1

#Verificamos si se agrego
free -h

#Cambiar el sistema de archivo a lvm de las particiones sdc2,3,5,6
sudo fdisk /dev/sdc
t
2
8e

t
3
8e

t
5
8e

t
6
8e

w

#Crear el pv
sudo pvcreate /dev/sdc2 /dev/sdc3 /dev/sdc5 /dev/sdc6


#Crear el vg Admin y Developers
sudo vgcreate vgAdmin /dev/sdc2 /dev/sdc3
sudo vgcreate vgDevelopers /dev/sdc5 /dev/sdc6


#Crear los Lv Admin,Developers,Testers,Devops
sudo lvcreate -l 100%FREE vgAdmin -n lvAdmin
sudo lvcreate -L +1G vgDevelopers -n lvDevelopers
sudo lvcreate -L +1G vgDevelopers -n lvTesters
sudo lvcreate -l 100%FREE vgDevelopers -n lvDevops


#Formatear
sudo mkfs.ext4 /dev/mapper/vgAdmin-lvAdmin
sudo mkfs.ext4 /dev/mapper/vgDevelopers-lvDevelopers
sudo mkfs.ext4 /dev/mapper/vgDevelopers-lvDevops
sudo mkfs.ext4 /dev/mapper/vgDevelopers-lvTesters

#Crear archivos para los lv y montarlos
sudo mkdir /mnt/lvDevelopers
sudo mkdir /mnt/lvTesters
sudo mkdir /mnt/lvDevops
sudo mkdir /mnt/lvAdmin

sudo mount /dev/mapper/vgAdmin-lvAdmin /mnt/lvAdmin
sudo mount /dev/mapper/vgDevelopers-lvDevelopers /mnt/lvDevelopers/
sudo mount /dev/mapper/vgDevelopers-lvTesters /mnt/lvTesters
sudo mount /dev/mapper/vgDevelopers-lvDevops /mnt/lvDevops

#Verificar
lsblk -f
