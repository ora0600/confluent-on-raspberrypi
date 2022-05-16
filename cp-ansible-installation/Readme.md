# Confluent Platform Installation on Raspberry PI via cp-ansible

The main goal is running a Raspberry PI 4 Node cluster with a Confluent Platform deployment.
Installation setup is shown in following image.
![Architecture RPI with CP 7.1](img/cp-on-RPI-architecture.png)

## SSH Key setup
on my Mac I do create first a private public key pair. For this you need openSSH Client. Check for your OS how to install it.
Create the keys:
```bash
ssh-keygen -t rsa -b 4096
# No passphrase
# Give it a name in my case rpi-key
```
Now, you will two keys:
1. rpi-key: this is private key, this key have to stay safe on your desktop
2. rpi-key.pub: this is the public key. You need to copy the complete content of this file into `.ssh/auhtorized_keys` on your RPI Node.

## Raspberry preparation for each Node
Note: Before we are starting please format with SD Formatter SDCard image



Please follow the installation and configuration process for each node:
* [cpcluster1 Node deployment](ReadmeCPCLUSTER1.md)
* [cpcluster2 Node deployment](ReadmeCPCLUSTER2.md)
* [cpcluster3 Node deployment](ReadmeCPCLUSTER3.md)
* [cpcluster4 Node deployment](ReadmeCPCLUSTER4.md)

## do cp-ansible setup
My first thinking was to use [Confluent Ansible installer](https://www.confluent.io/installer) but the outcome was too generic for us.
So, I developed my own investory file. Please see [host.yml](host.yml)
### Steps to run cp-ansile
Please follow the pre-reqs of Confluent Ansible Installer: ssh, ansible, git, python (v3.x) should be installed on your desktop (I use MacOS).
Install cp-ansible packages
```bash
ansible-galaxy collection install git+https://github.com/confluentinc/cp-ansible.git
```
Run cp-ansible installation for our RPI cluster
```bash
ansible-playbook -i hosts.yml confluent.platform.all
# with Debug information run the next command, if you need this for error tracking
#ansible-playbook -vvv -i hosts.yml confluent.platform.all > failure.txt
```
The outcome shold look like this
```bash
PLAY RECAP *********************************************************************
cpcluster1                 : ok=84   changed=5    unreachable=0    failed=0    skipped=80   rescued=0    ignored=0   
cpcluster2                 : ok=83   changed=5    unreachable=0    failed=0    skipped=74   rescued=0    ignored=0   
cpcluster3                 : ok=79   changed=2    unreachable=0    failed=0    skipped=69   rescued=0    ignored=0   
cpcluster4                 : ok=53   changed=3    unreachable=0    failed=0    skipped=50   rescued=0    ignored=0   
```
Next step should be to check the cluster
systemD services are `sudo systemctl list-units --type=service`:
* cpcluster1: `sudo systemctl status confluent-zookeeper`
* cpcluster1: `sudo systemctl status confluent-server`
* cpcluster1: `sudo systemctl status confluent-ksqldb`
* cpcluster2: `sudo systemctl status confluent-zookeeper`
* cpcluster2: `sudo systemctl status confluent-server`
* cpcluster2: `sudo systemctl status confluent-kafka-connect`
* cpcluster3: `sudo systemctl status confluent-zookeeper`
* cpcluster3: `sudo systemctl status confluent-server`
* cpcluster3: `sudo systemctl status confluent-kafka-rest`
* cpcluster4: `sudo systemctl status confluent-control-center`
* cpcluster4: `sudo systemctl status confluent-schema-registry` 
* logs on each node are here `sudo ls /var/log/kafka/*` or `sudo ls /var/log/confluent/*`


A quick check, if everything is working as expected could be:
```bash
kcat -b cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 -L

nc -vz cpcluster1 9092
nc -vz cpcluster1 2181
nc -vz cpcluster2 9092
nc -vz cpcluster2 2181
nc -vz cpcluster3 9092
nc -vz cpcluster3 2181

#show topics
kafka-topics --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 -list
#create topic
kafka-topics --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --create --replication-factor 1 --partitions 1 --topic test
kafka-topics --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --create --replication-factor 3 --partitions 3 --topic testreplica

# check schema
curl http://192.168.178.83:8081

# check connect
curl http://192.168.178.81:8083

# check ksqldb
curl http://192.168.178.80:8088/info

# check REST
curl http://192.168.178.82:8082

# control center or open in Browser
curl http://192.168.178.83:9021
```
![Control Center Overview](img/c3.png)

The monitoring Dashboard for our cluster in Confluent Cloud looks like this:
![Monitoring Dashboard](img/monitoring_dashboard.png)
The use case for Health+ is really interesting for IoT use case:
* Decentral Monitoring dashboard for snd level support, without the need of access to cluster, with Alerting
* keep the footprint on cluster small (we run Control Center in management mode, so big fast KStreams part is not necessary)

If you need to change and create your own inventory file, you can follow this example[example host.yml](https://github.com/confluentinc/cp-ansible/blob/7.1.1-post/docs/hosts_example.yml) and check [documention](https://docs.confluent.io/ansible/current/ansible-install.html)

# Performance Test mit Kakfa perftest tool
I did run the following perftest for a short check how much powner by 200€ cluster has:
```bash
# create topic
kafka-topics --bootstrap-server 192.168.178.80:9092,192.168.178.81:9092, 192.168.178.82:9092 \
--create \
--topic perf-test-rep-three \
--partitions 6 \
--replication-factor 3 \
--command-config ./client.config

# describe topic
kafka-topics --bootstrap-server 192.168.178.80:9092,192.168.178.81:9092, 192.168.178.82:9092 \
--describe \
--topic perf-test-rep-three \
--command-config ./client.config

# run perf test
kafka-producer-perf-test \
--topic perf-test-rep-three \
--producer.config ./client.config \
--num-records 1000000 \
--throughput -1 \
--record-size 1000
```
The result is not too bad for such a small cluster, but less compared with manual setup (~10MB/s):
```bash
31521 records sent, 6304.2 records/sec (6.01 MB/sec), 2421.1 ms avg latency, 4183.0 ms max latency.
30752 records sent, 5813.2 records/sec (5.54 MB/sec), 3713.2 ms avg latency, 5357.0 ms max latency.
36512 records sent, 7302.4 records/sec (6.96 MB/sec), 6279.1 ms avg latency, 7233.0 ms max latency.
25440 records sent, 5065.7 records/sec (4.83 MB/sec), 3565.0 ms avg latency, 6185.0 ms max latency.
28288 records sent, 5647.4 records/sec (5.39 MB/sec), 7576.2 ms avg latency, 8572.0 ms max latency.
30016 records sent, 5320.1 records/sec (5.07 MB/sec), 4457.0 ms avg latency, 8453.0 ms max latency.
20928 records sent, 4183.9 records/sec (3.99 MB/sec), 8126.1 ms avg latency, 9609.0 ms max latency.
39808 records sent, 7659.8 records/sec (7.30 MB/sec), 5106.2 ms avg latency, 9560.0 ms max latency.
34144 records sent, 6828.8 records/sec (6.51 MB/sec), 5493.3 ms avg latency, 7441.0 ms max latency.
31936 records sent, 6387.2 records/sec (6.09 MB/sec), 4137.8 ms avg latency, 7186.0 ms max latency.
47232 records sent, 9442.6 records/sec (9.01 MB/sec), 4540.2 ms avg latency, 6485.0 ms max latency.
```
Do the same test with a tiered storage topic where the hot data stays for 1 minute on the broker `confluent.tier.local.hotset.ms=60000` and with a retention of 30 minutes `retention.ms=1800000` :
```bash
#Create topics with hotset
kafka-topics --bootstrap-server 192.168.178.80:9092,192.168.178.81:9092, 192.168.178.82:9092   \
--create --topic tieredstoragetopic \
--partitions 6 \
--replication-factor 3 \
--config confluent.tier.enable=true \
--config confluent.tier.local.hotset.ms=60000 \
--config retention.ms=1800000
# run perf test
kafka-producer-perf-test \
--topic tieredstoragetopic \
--producer.config ./client.config \
--num-records 1000000 \
--throughput -1 \
--record-size 1000
```
The result is not too bad for such a small cluster, but less than manual setup (~10MB/s):
```bash
44865 records sent, 8942.6 records/sec (8.53 MB/sec), 1877.2 ms avg latency, 3661.0 ms max latency.
17504 records sent, 3296.4 records/sec (3.14 MB/sec), 3296.8 ms avg latency, 6470.0 ms max latency.
50656 records sent, 10131.2 records/sec (9.66 MB/sec), 5471.7 ms avg latency, 7376.0 ms max latency.
16416 records sent, 3281.2 records/sec (3.13 MB/sec), 4283.3 ms avg latency, 7622.0 ms max latency.
52640 records sent, 10521.7 records/sec (10.03 MB/sec), 4884.7 ms avg latency, 7572.0 ms max latency.
18848 records sent, 3765.8 records/sec (3.59 MB/sec), 5348.9 ms avg latency, 7472.0 ms max latency.
41888 records sent, 7464.0 records/sec (7.12 MB/sec), 4718.9 ms avg latency, 7590.0 ms max latency.
35264 records sent, 7051.4 records/sec (6.72 MB/sec), 5584.6 ms avg latency, 7396.0 ms max latency.
34848 records sent, 6965.4 records/sec (6.64 MB/sec), 3907.2 ms avg latency, 7440.0 ms max latency.
38272 records sent, 7651.3 records/sec (7.30 MB/sec), 5397.3 ms avg latency, 7818.0 ms max latency.
```
The performance is more or less the same. But with tiered storage we do need much disk space on the broker.

# Start cluster
via the systemD services the cluster will be started automatically, you do not need run the following script.
Start cluster run `scripts/98_startup_cluster.sh`

# Stop Cluster
Stop Cluster `./99_shutdown_clustersh cpcluster1 cpcluster2 cpcluster3 cpcluster4`

[back](https://github.com/ora0600/confluent-on-rpi)