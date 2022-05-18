# CPCLUSTER1 with cp-ansible

This node will host: Zookeeper, kafka Broker, ksqlDB cluster and is configured with tiered storage and Health+.

Hostname: cpcluster1, Raspberry PI 4 8GB, 128 GB SDCard
We use Raspberry PI Imager to load the following image on SD Card Ubuntu Server 21.10, ARM 64Bit, see [sample](https://www.thorsten-hans.com/install-ubuntu-server-20-10-on-a-raspberry-pi/)
* SDCard Image write on SDCard
* plug-in SD Card into your Mac
* open Raspberry PI Imager on your MacOS, if not installed, install it
* choose OS: Ubuntu Server 20.04.3 64Bit
* Set SDCard 
* press write
* Change into SDCard and check if new data in written
* remove SDCard from Slot and plug-in in again
* Now we configre SSH headless, see [sample](https://www.tomshardware.com/reviews/raspberry-pi-headless-setup-how-to,6028.html) with a terminal on your MAC
```bash
cd /Volumes/system-boot/
df- k
touch /Volumes/system-boot/ssh #file nach /boot erstellt(Leer)
vi /Volumes/system-boot/network-config
version: 2
#wifis:
#  wlan0:
#    dhcp4: true
#    optional: true
#    access-points:
#      "YOURWLANID":
#        password: "yourPassword"
ethernets:
  eth0:
    addresses:
      - 192.168.178.80/24
    gateway4: 192.168.178.1
    nameservers:
      addresses: [192.168.178.1]
    optional: true
# Plug-in SDCard into PI4 stecken, plug-in Ethernet cable, and switch on power
ssh ubuntu@192.168.178.80
# ssh ubuntu@cpcluster1
User: ubuntu Password: ubuntu
change password: YOURPASSWORD
# set hostname 
hostname
# ubuntu
sudo hostname -b cpcluster1
hostname
# cpcluster1
# check if old hostname exits
sudo vi /etc/hostname
   change ubuntu in cpcluster1
sudo vi /etc/hosts
192.168.178.80 cpcluster1
192.168.178.81 cpcluster2
192.168.178.82 cpcluster3
192.168.178.83 cpcluster4
sudo reboot
# login
ssh ubuntu@cpcluster1
hostname
sudo apt-get update
sudo apt-get upgrade
sudo reboot
``` 
cpcluster1 is ready.

# install main components like Java on cpcluster1
login to raspberrypi pi 
```bash
ssh ubuntu@cpcluster1
# How much storage do we have available in cpcluster1
df- k
# Memory check
free
# now, install main components used by Confluent Platform
sudo apt-get install openjdk-11-jdk curl git python3 python3-pip -y
java -version
python3 --version
```

We have main components installed. Rest will be done by cp-ansible.

Finally copy the public key first into clipboard and then into cpcluster1 file `.ssh/authorized_keys` then you can login with ssh key
```bash
# login via ssh key
ssh -i ~/keys/rpi-key ubuntu@cpcluster1
```

[back](Readme.md)