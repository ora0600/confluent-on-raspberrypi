# CPCLUSTER2

This node will host: Zookeeper, kafka Broker, connect cluster and is configured with tiered storage and Health+.

Hostname: cpcluster2, Raspberry PI 4 4GB, 128 GB SDCard
We use Raspberry PI Imager to load the following image on SD Card Ubuntu Server 21.10, ARM 64Bit,see [sample](https://www.thorsten-hans.com/install-ubuntu-server-20-10-on-a-raspberry-pi)
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
cd /Volumes/system-boot
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
      - 192.168.178.81/24
    gateway4: 192.168.178.1
    nameservers:
      addresses: [192.168.178.1]
    optional: true
# Plug-in SDCard into PI4 stecken, plug-in Ethernet cable, and switch on power
ssh ubuntu@192.168.178.81
# ssh ubuntu@cpcluster2
User: ubuntu Password: ubuntu
change password: YOURPASSWORD
# set hostname 
hostname
# ubuntu
sudo hostname -b cpcluster2
hostname
# cpcluster2
# check if old hostname exits
sudo vi /etc/hostname
   change ubuntu in cpcluster2
sudo vi /etc/hosts
192.168.178.80 cpcluster1
192.168.178.81 cpcluster2
192.168.178.82 cpcluster3
192.168.178.83 cpcluster4
sudo reboot
# login
ssh ubuntu@cpcluster2
hostname
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```
cpcluster2 is now ready.


# Deploy Confluent Stuff on cpcluster2
INSTALL Confluent Stuff on cpcluster2.
login to raspberrypi:
```bash
ssh ubuntu@cpcluster2
# first check ram and disk space
df- k
# Memory check 4GB
free
# now, install components that need to be there for Confluent Platform
sudo apt-get install openjdk-11-jdk -y
java -version
sudo apt install curl -y
sudo apt-get install -y python3 python3-pip
python3 --version
# Install confluent
sudo apt-get install jq -y
mkdir -p /home/ubuntu/software
cd /home/ubuntu/software
wget https://packages.confluent.io/archive/7.1/confluent-7.1.0.tar.gz
tar xvf confluent-7.1.0.tar.gz
rm confluent-7.1.0.tar.gz
mv confluent-7.1.0 confluent/
```
Set some environment variables to make working with Confluent Platform esaier:
```bash
# home/ubuntu/.bashrc
vi ~/.bashrc
# add 
export PATH=$PATH:/usr/local/bin:/home/ubuntu/software/confluent/bin
export CONFLUENT_HOME=/home/ubuntu/software/confluent
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64
```
Execute (source) the bash profile:
```bash
# source
. ~/.bashrc
echo $CONFLUENT_HOME
```

Now, configure the Confluent components and systemD services:
* Zookeeper
* Broker with telemetry and tiered storage
* connect cluster
* systemD services for zookeeper, broker and connect
```bash 
## configure 
vi $CONFLUENT_HOME/etc/kafka/zookeeper.properties
dataDir=/home/ubuntu/software/data/zookeeper
clientPort=2181
maxClientCnxns=0
admin.enableServer=false
server.1=192.168.178.80:2888:3888
server.2=192.168.178.81:2888:3888
server.3=192.168.178.82:2888:3888
tickTime=2000
initLimit=5
syncLimit=2
autopurge.snapRetainCount=3
autopurge.purgeInterval=24

# Kafka Broker
vi $CONFLUENT_HOME/etc/kafka/server.properties
broker.id=2
listeners=PLAINTEXT://192.168.178.81:9092
advertised.listeners=PLAINTEXT://192.168.178.81:9092
metric.reporters=io.confluent.metrics.reporter.ConfluentMetricsReporter
confluent.metrics.reporter.bootstrap.servers=192.168.178.80:9092,192.168.178.81:9092,192.168.178.82:9092
confluent.balancer.enable=true
num.partitions=1
num.network.threads=2
num.io.threads=4
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/home/ubuntu/software/data/kafka-logs
num.partitions=1
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=1
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
log.cleaner.enable=true
log.cleanup.policy=delete
#zookeeper.connect=192.168.178.81:2181
zookeeper.connect=192.168.178.80:2181,192.168.178.81:2181,192.168.178.82:2181
zookeeper.connection.timeout.ms=18000
group.initial.rebalance.delay.ms=0
confluent.license.topic.replication.factor=1
confluent.metadata.topic.replication.factor=1
confluent.security.event.logger.exporter.kafka.topic.replicas=1
confluent.balancer.enable=true
confluent.balancer.topic.replication.factor=1
# Health+
confluent.telemetry.enabled=true
confluent.telemetry.api.key=CCLOUDAPIKEY
confluent.telemetry.api.secret=CCLOUDAPISECRET
# tiered storage setup
confluent.tier.feature=true
confluent.tier.enable=true
confluent.tier.backend=S3
confluent.tier.s3.bucket=cmde-rpi-tieredstorage
confluent.tier.s3.region=eu-central-1
confluent.tier.metadata.replication.factor=1
# raspberry pi has four cores
confluent.tier.fetcher.num.threads=4
confluent.tier.archiver.num.threads=2
# time after topic deletion, delition in S3
confluent.tier.topic.delete.check.interval.ms=3600000
# smaler segments helps deletion and performance, set to 10MB
log.segment.bytes=10485760
# how long segemts retained on broker, for 1,5h
confluent.tier.local.hotset.ms=5400000
# use an aws credential file which have only access to that specific bucket in s3 (read, write, list) you need to create a policy and a progamatic user, in my case user cmde-aws-s3-bucket-tiered-storage, the credentails should be able to do s3:DeleteObject, s3:GetObject, s3:PutObject, s3:GetBucketLocation
confluent.tier.s3.cred.file.path=/home/ubuntu/software/confluent/etc/kafka/aws_credentials
# save properties files

# prepare directories for zookeeper and broker
mkdir -p /home/ubuntu/software/data/zookeeper
mkdir -p /home/ubuntu/software/data/kafka-logs

cd $CONFLUENT_HOME/bin/
vi kafka-server-start
# add at the end
export JMX_PORT=${JMX_PORT:-9999}
export KAFKA_HEAP_OPTS="-Xmx256M -Xms128M"

# Create Service and start Zookeeper
echo "2" > /home/ubuntu/software/data/zookeeper/myid
sudo vi /etc/systemd/system/zookeeper.service
[Unit]
Description=Confluent Zookeeper
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=ubuntu
ExecStart=/home/ubuntu/software/confluent/bin/zookeeper-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/zookeeper.properties
ExecStop=/home/ubuntu/software/confluent/bin/zookeeper-server-stop
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
# save
sudo cat /etc/systemd/system/zookeeper.service

# configure and start Kafka broker (Confluent Platform)
sudo vi /etc/systemd/system/cpserver.service
[Unit]
Description=Confluent Kafka Broker
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=ubuntu
ExecStart=/home/ubuntu/software/confluent/bin/kafka-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/server.properties
ExecStop=/home/ubuntu/software/confluent/bin/kafka-server-stop
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
# save
sudo cat /etc/systemd/system/cpserver.service

# Connect cluster
# install connector first into /home/ubuntu/software/confluent/share/java
confluent-hub install confluentinc/kafka-connect-datagen:0.5.3
confluent-hub install confluentinc/kafka-connect-oracle-cdc:2.0.2

# connect properties
vi ~/software/confluent/etc/kafka/connect-distributed.properties
bootstrap.servers=192.168.178.80:9092,192.168.178.81:9092,192.168.178.82:9092
group.id=connect-cpcluster
key.converter=io.confluent.connect.avro.AvroConverter
key.converter.schema.registry.url=http://192.168.178.83:8081
value.converter=io.confluent.connect.avro.AvroConverter
value.converter.schema.registry.url=http://192.168.178.83:8081
key.converter.schemas.enable=true
value.converter.schemas.enable=true
offset.storage.topic=connect-offsets
offset.storage.replication.factor=1
config.storage.topic=connect-configs
config.storage.replication.factor=1
status.storage.topic=connect-status
status.storage.replication.factor=1
offset.flush.interval.ms=10000
listeners=http://0.0.0.0:8083
#rebalance.timeout.ms=600000
#session.timeout.ms=30000
#worker.sync.timeout.ms=15000
#request.timeout.ms=120000
rest.advertised.host.name=192.168.178.81
rest.advertised.port=8083
#rest.advertised.listener=HTTP://192.168.178.80:8083
plugin.path=/home/ubuntu/software/confluent/share/java
# Interceptor setup
consumer.interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor
producer.interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor

#vi ~/software/confluent/bin/connect-distributed
#export JMX_PORT=${JMX_PORT:-9999}
#export KAFKA_HEAP_OPTS="-Xmx256M -Xms128M"

# connect service
sudo vi /etc/systemd/system/connect.service
[Unit]
Description=Confluent Kafka Connect
After=cpservice.service

[Service]
Type=forking
User=ubuntu
Group=ubuntu
#Environment="KAFKA_JMX_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=10040 -Dcom.sun.management.jmxremote.local.only=true -Dcom.sun.management.jmxremote.authenticate=false"
#Environment="LOG_DIR=/var/log/kafka"
# Uncomment the following line to enable authentication for the kafka connect
# Environment="KAFKA_OPTS=-Djava.security.auth.login.config=/etc/kafka/kafka_connect_jaas.conf"
ExecStart=/home/ubuntu/software/confluent/bin/connect-distributed -daemon /home/ubuntu/software/confluent/etc/kafka/connect-distributed.properties

[Install]
WantedBy=multi-user.target
# save
sudo cat /etc/systemd/system/connect.service

# Start zookeeper and broker and connect 
#sudo systemctl start zookeeper
#sudo systemctl status zookeeper
#sudo systemctl start cpserver
#sudo systemctl status cpserver
#sudo systemctl start connect
#sudo systemctl status connect
# falls error, date ändern und neu laden sudo systemctl daemon-reload

# make server rebootable
sudo systemctl enable zookeeper
sudo systemctl enable cpserver
sudo systemctl enable connect
# disable
sudo systemctl disable zookeeper
sudo systemctl disable cpserver
sudo systemctl disable connect
```
systemD services are prepared, but we will use a main startup script `scripts/98_startup_cluster.sh`

[back](Readme.md)