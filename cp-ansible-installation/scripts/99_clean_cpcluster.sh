#!/bin/bash
# usage ./99_clean_cpcluster.sh

echo "clean cpcluster"
ssh -i ~/keys/rpi-key ubuntu@cpcluster1 'rm -rf /opt/confluent; rm -rf /opt/prometheus; rm -rf /var/log/kafka; rm -rf /var/log/confluent; rm -rf /var/lib/kafka/; rm -rf /var/lib/kafka-streams/; rm -rf /var/lib/zookeeper/; rm -rf /var/lib/confluent/; exit'
echo "Node cpcluster1 cleaned"
ssh -i ~/keys/rpi-key ubuntu@cpcluster2 'rm -rf /opt/confluent; rm -rf /opt/prometheus; rm -rf /var/log/kafka; rm -rf /var/log/confluent; rm -rf /var/lib/kafka/; rm -rf /var/lib/kafka-streams/; rm -rf /var/lib/zookeeper/; rm -rf /var/lib/confluent/; exit'
echo "Node cpcluster2 cleaned"
ssh -i ~/keys/rpi-key ubuntu@cpcluster3 'rm -rf /opt/confluent; rm -rf /opt/prometheus; rm -rf /var/log/kafka; rm -rf /var/log/confluent; rm -rf /var/lib/kafka/; rm -rf /var/lib/kafka-streams/; rm -rf /var/lib/zookeeper/; rm -rf /var/lib/confluent/; exit'
echo "Node cpcluster3 cleaned"
ssh -i ~/keys/rpi-key ubuntu@cpcluster4 'rm -rf /opt/confluent; rm -rf /opt/prometheus; rm -rf /var/log/kafka; rm -rf /var/log/confluent; rm -rf /var/lib/kafka/; rm -rf /var/lib/kafka-streams/; rm -rf /var/lib/zookeeper/; rm -rf /var/lib/confluent/; exit'
echo "Node cpcluster4 cleaned"
echo "CP cluster cleaned, start new ansible deployment for a fresh deployment"