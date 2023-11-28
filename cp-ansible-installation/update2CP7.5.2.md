# Upgrade RPI cluster from CP 7.1.1 to CP 7.5.2
Documentation is [here](https://docs.confluent.io/ansible/current/ansible-upgrade.html)
We are running a cluster with co-location, that's why we need to start [here](https://docs.confluent.io/ansible/current/ansible-upgrade.html#upgrade-co-located-zk-based-cp-deployment)
## Requirements: 
  * Cluster must be installed and configured by cp-ansible
  * same hosts.yaml
## Pre-Checks
First we need to know if all Broker.ids are set:
```bash
#Check broker IDs on hosts:
ansible -i hosts.yml -m shell -a "grep broker.id /var/lib/kafka/data/meta.properties" kafka_broker
# Output
#cpcluster1 | CHANGED | rc=0 >>
#broker.id=1
#cpcluster3 | CHANGED | rc=0 >>
#broker.id=3
#cpcluster2 | CHANGED | rc=0 >>
#broker.id=2
```
Where is the controller running, this host need to upgrade at the end
```bash
ansible -i hosts.yml kafka_broker -m import_role -a "name=confluent.platform.kafka_broker tasks_from=dynamic_groups.yml"
# Output
cpcluster1 | SUCCESS => {
    "msg": "Broker ID: 1 and Controller ID: 1"
}
cpcluster2 | SUCCESS => {
    "msg": "Broker ID: 2 and Controller ID: 1"
}
cpcluster3 | SUCCESS => {
    "msg": "Broker ID: 3 and Controller ID: 1"
}
```
CONTROLLER is the broker.id 1. So, we will upgrade the cluster cpcluster1 at the end.
## change host file
we need to change a couple of things in the `hosts.yml` file:
```bash
confluent_archive_file_source: http://packages.confluent.io/archive/7.5/confluent-7.5.2.tar.gz
confluent_package_version: 7.5.2
kafka_broker_custom_properties:
      inter.broker.protocol.version: 3.1
```
## Start with Upgrade
### cpcluster2
Stop  and upgrade cpcluster2
```bash
ansible -i hosts.yml -m shell -a "systemctl stop confluent-*" cpcluster2
# Upgrade cpcluster2
ansible-playbook -i hosts.yml confluent.platform.all --limit cpcluster2
#output:
#PLAY RECAP ********************************************************************************************************************************************************************************************
#cpcluster2                 : ok=111  changed=22   unreachable=0    failed=0    skipped=109  rescued=0    ignored=0  
# Login and run systemctl daemon-reload
ssh -i ~/keys/rpi-key ubuntu@cpcluster2
sudo systemctl stop confluent-kafka-connect
sudo systemctl stop confluent-server
sudo systemctl stop confluent-zookeeper
sudo systemctl daemon-reload
sudo ls /opt/confluent
sudo systemctl start confluent-zookeeper
sudo systemctl status confluent-zookeeper
sudo systemctl start confluent-server
sudo systemctl status confluent-server
sudo systemctl start confluent-kafka-connect
sudo systemctl status confluent-kafka-connect
exit
#check
ansible -i hosts.yml kafka_broker -m import_role -a "name=confluent.platform.kafka_broker tasks_from=dynamic_groups.yml" --limit cpcluster2
```
### cpcluster3
Stop and upgrade cpcluster3
```bash
ansible -i hosts.yml -m shell -a "systemctl stop confluent-*" cpcluster3
# Upgrade cpcluster3
ansible-playbook -i hosts.yml confluent.platform.all --limit cpcluster3
#output:
#PLAY RECAP ********************************************************************************************************************************************************************************************
#cpcluster3                 : ok=101  changed=15   unreachable=0    failed=0    skipped=91   rescued=0    ignored=0   
# Login and run systemctl daemon-reload
ssh -i ~/keys/rpi-key ubuntu@cpcluster3
sudo systemctl stop confluent-kafka-rest
sudo systemctl stop confluent-server
sudo systemctl stop confluent-zookeeper
sudo systemctl daemon-reload
sudo ls /opt/confluent
sudo systemctl start confluent-zookeeper
sudo systemctl status confluent-zookeeper
sudo systemctl start confluent-server
sudo systemctl status confluent-server
sudo systemctl start confluent-kafka-rest
sudo systemctl status confluent-kafka-rest
exit
#check
ansible -i hosts.yml kafka_broker -m import_role -a "name=confluent.platform.kafka_broker tasks_from=dynamic_groups.yml" --limit cpcluster3
```
### cpcluster4
Stop and upgrade cpcluster4
```bash
ansible -i hosts.yml -m shell -a "systemctl stop confluent-*" cpcluster4
# Upgrade cpcluster4
ansible-playbook -i hosts.yml confluent.platform.all --limit cpcluster4
#output:
#PLAY RECAP ********************************************************************************************************************************************************************************************
#cpcluster4                 : ok=66   changed=11   unreachable=0    failed=0    skipped=65   rescued=0    ignored=0   
# Login and run systemctl daemon-reload
ssh -i ~/keys/rpi-key ubuntu@cpcluster4
sudo systemctl stop confluent-schema-registry
sudo systemctl stop confluent-control-center
sudo systemctl daemon-reload
sudo ls /opt/confluent
sudo systemctl start confluent-schema-registry
sudo systemctl status confluent-schema-registry
sudo systemctl start confluent-control-center
sudo systemctl status confluent-control-center
exit
```
### cpcluster1 the controller
Finally staop upgrade the controller HOST cpcluster1
```bash
#Stop cpcluster1
ansible -i hosts.yml -m shell -a "systemctl stop confluent-*" cpcluster1
# Upgrade cpcluster1
ansible-playbook -i hosts.yml confluent.platform.all --limit cpcluster1
#output:
#PLAY RECAP ********************************************************************************************************************************************************************************************
#cpcluster1                 : ok=101  changed=17   unreachable=0    failed=0    skipped=100  rescued=0    ignored=0 
# Login and run systemctl daemon-reload
ssh -i ~/keys/rpi-key ubuntu@cpcluster1
sudo systemctl stop confluent-ksqldb
sudo systemctl stop confluent-server
sudo systemctl stop confluent-zookeeper
sudo systemctl daemon-reload
sudo ls /opt/confluent
sudo systemctl start confluent-zookeeper
sudo systemctl status confluent-zookeeper
sudo systemctl start confluent-server
sudo systemctl status confluent-server
sudo systemctl start confluent-ksqldb
sudo systemctl status confluent-ksqldb
exit
#check
ansible -i hosts.yml kafka_broker -m import_role -a "name=confluent.platform.kafka_broker tasks_from=dynamic_groups.yml" --limit cpcluster1
```
## set version to 3.5
We need to set broker protocol and log message format now.
```bash
kafka_broker_custom_properties:
  inter.broker.protocol.version: 3.5
  log.message.format.version: 3.5
# set version
ansible-playbook -i hosts.yml confluent.platform.all --tags kafka_broker --skip-tags package
# Output
#PLAY RECAP ********************************************************************************************************************************************************************************************
#cpcluster1                 : ok=56   changed=2    unreachable=0    failed=0    skipped=94   rescued=0    ignored=0   
#cpcluster2                 : ok=55   changed=4    unreachable=0    failed=0    skipped=94   rescued=0    ignored=0   
#cpcluster3                 : ok=55   changed=2    unreachable=0    failed=0    skipped=94   rescued=0    ignored=0   
#cpcluster4                 : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
## Run checks
Run [Control Center](http://192.168.178.83:9021/)
Run [Health+](https://confluent.cloud/health-plus/clusters)
Run clients
```bash
cd ~/Demos/raspberrypi/scripts
./00_start_clients.sh
```
## Last steps
### Delete all old software from hosts
```bash
ssh -i ~/keys/rpi-key ubuntu@cpcluster1
sudo rm -rf /opt/confluent/confluent-7.1.1/
sudo ls /opt/confluent
exit
ssh -i ~/keys/rpi-key ubuntu@cpcluster2
sudo rm -rf /opt/confluent/confluent-7.1.1/
sudo ls /opt/confluent
exit
ssh -i ~/keys/rpi-key ubuntu@cpcluster3
sudo rm -rf /opt/confluent/confluent-7.1.1/
sudo ls /opt/confluent
exit
ssh -i ~/keys/rpi-key ubuntu@cpcluster4
sudo rm -rf /opt/confluent/confluent-7.1.1/
sudo ls /opt/confluent
exit
```
#### Drop all old internal topics _confluent-controlcenter-7-1-1-1*
```bash
./02_delete_old_topics.sh
```

The cluster is now running Confluent Platform 7.5.2
