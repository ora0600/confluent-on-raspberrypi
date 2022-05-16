# CPCLUSTER4

This node will host: Confluent Control Center (C3) in management mode with Health+ and Schema Registry

Hostname: cpcluster4, Raspberry PI 4 4GB, 128 GB SDCard
We use Raspberry PI Imager to load the following image on SD Card Ubuntu Server 21.10, ARM 64Bit, see [sample] (https://www.thorsten-hans.com/install-ubuntu-server-20-10-on-a-raspberry-pi/)
* SDCard Image write on SDCard
* plug-in SD Card into your Mac
* open Raspberry PI Imager on your MacOS, if not installed, install it
* choose OS: Ubuntu Serber 20.04.3 64Bit
* Set SDCard 
* press write
* Change into SDCard and check if new data in writtem
* remove SDCard from Slot and plug-in in again
* Now we configre SSH headless, see [sample](https://www.tomshardware.com/reviews/raspberry-pi-headless-setup-how-to,6028.html) with a terminal on your MAC
```bash
cd  /Volumes/system-boot
df- k
touch /Volumes/system-boot/ssh #file creation to  /boot is empty
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
      - 192.168.178.83/24
    gateway4: 192.168.178.1
    nameservers:
      addresses: [192.168.178.1]
    optional: true
# Plug-in SDCard into PI4 stecken, plug-in Ethernet cable, and switch on power
ssh ubuntu@192.168.178.83
# ssh ubuntu@cpcluster4
User: ubuntu Password: ubuntu
change password: YOURPASSWORD
# set hostname 
hostname
# ubuntu
sudo hostname -b cpcluster4
hostname
# cpcluster4
# check if old hostname exits
sudo vi /etc/hostname
   change ubuntu in cpcluster4
sudo vi /etc/hosts
192.168.178.80 cpcluster1
192.168.178.81 cpcluster2
192.168.178.82 cpcluster3
192.168.178.83 cpcluster4
sudo reboot
# login
ssh ubuntu@cpcluster4
hostname
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```

cpcluster4 is now ready.

# Deploy Confluent Stuff on cpcluster4
INSTALL Confluent Stuff cpcluster4 and login to raspberrypi
```bash
ssh ubuntu@cpcluster4
# first check disk space
df- k
# Memory check 4GB
free
# install components
sudo apt-get install openjdk-11-jdk curl python3 python3-pip jq -y
java -version
python3 --version
# Install confluent
mkdir -p /home/ubuntu/software
cd /home/ubuntu/software
wget https://packages.confluent.io/archive/7.1/confluent-7.1.0.tar.gz
tar xvf confluent-7.1.0.tar.gz
rm confluent-7.1.0.tar.gz
mv confluent-7.1.0 confluent/
```
set environment variables:
```bash
# home/ubuntu/.bashrc
vi ~/.bashrc
# add 
export PATH=$PATH:/usr/local/bin:/home/ubuntu/software/confluent/bin
export CONFLUENT_HOME=/home/ubuntu/software/confluent
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64
# source
. ~/.bashrc
echo $CONFLUENT_HOME
```
Now, configure the Confluent components and systemD services:
* Confluent Control Center (C3)
* Schema Registry
* systemD services for C3 and Schema Registry
```bash
# Schema Registry
vi /home/ubuntu/software/confluent/etc/schema-registry/schema-registry.properties
listeners=http://0.0.0.0:8081
host.name=192.168.178.83
kafkastore.bootstrap.servers=PLAINTEXT://192.168.178.80:9092,PLAINTEXT://192.168.178.81:9092,PLAINTEXT://192.168.178.82:9092
kafkastore.topic=_schemas
kafkastore.topic.replication.factor=1
debug=false

# Control Center
vi /home/ubuntu/software/confluent/etc/confluent-control-center/control-center.properties
bootstrap.servers=192.168.178.80:9092,192.168.178.81:9092,192.168.178.82:9092
zookeeper.connect=192.168.178.80:2181,192.168.178.81:2181,192.168.178.82:2181
confluent.controlcenter.id=1
confluent.controlcenter.data.dir=/home/ubuntu/software/data/control-center
# without license key property, you will have 30 days for evaluation
confluent.license=CONFLUENTLICENSEKEY
confluent.controlcenter.connect.connect-cpcluster.cluster=http://192.168.178.81:8083
confluent.controlcenter.ksql.ksqldb-cpcluster.url=http://192.168.178.80:8088
confluent.controlcenter.ksql.ksqldb-cpcluster.advertised.url=http://192.168.178.80:8088
confluent.controlcenter.schema.registry.url=http://192.168.178.83:8081
confluent.controlcenter.streams.cprest.url=http://192.168.178.82:8082
confluent.controlcenter.internal.topics.replication=1
confluent.controlcenter.internal.topics.partitions=3
confluent.controlcenter.command.topic.replication=1
confluent.controlcenter.ui.autoupdate.enable=true
confluent.controlcenter.usage.data.collection.enable=true
confluent.monitoring.interceptor.topic.partitions=2
confluent.monitoring.interceptor.topic.replication=1
confluent.metrics.topic.partitions=2
confluent.metrics.topic.replication=1
confluent.controlcenter.streams.num.stream.threads=2
confluent.telemetry.enabled=true
confluent.telemetry.api.key=CCLOUDAPIKEY
confluent.telemetry.api.secret=CCLOUDAPISECRET
confluent.controlcenter.mode.enable=management
confluent.controlcenter.name=cpcluster

# Control center data dir 
mkdir -p /home/ubuntu/software/data/control-center

# services for schema regitsry and control center
# Schema Registry
sudo vi /etc/systemd/system/schemaregistry.service
[Unit]
Description=Confluent Schema Registry
After=network.target remote-fs.target kafka.service

[Service]
Type=forking
User=ubuntu
Group=ubuntu
#Environment="KAFKA_JMX_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=10050 -Dcom.sun.management.jmxremote.local.only=true -Dcom.sun.management.jmxremote.authenticate=false"
#Environment="LOG_DIR=/var/log/kafka"
ExecStart=/home/ubuntu/software/confluent/bin/schema-registry-start -daemon /home/ubuntu/software/confluent/etc/schema-registry/schema-registry.properties
ExecStop=/home/ubuntu/software/confluent/bin/schema-registry-stop

[Install]
WantedBy=multi-user.target
# save
sudo cat /etc/systemd/system/schemaregistry.service

# Control Center service
sudo vi /etc/systemd/system/controlcenter.service
[Unit]
Description=Confluent Control Center
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
ExecStart=/home/ubuntu/software/confluent/bin/control-center-start -daemon /home/ubuntu/software/confluent/etc/confluent-control-center/control-center.properties
ExecStop=/home/ubuntu/software/confluent/bin/control-center-stop

[Install]
WantedBy=multi-user.target

# Start Schema Registry and Control Center
#sudo systemctl start schemaregistry
#sudo systemctl status schemaregistry
#sudo systemctl start controlcenter
#sudo systemctl status controlcenter

# make server rebootable
sudo systemctl enable schemaregistry
sudo systemctl enable controlcenter
# disable
sudo systemctl disable schemaregistry
sudo systemctl disable controlcenter
```
systemD services are prepared, but we will use a main startup script `scripts/98_startup_cluster.sh`

[back](Readme.md)