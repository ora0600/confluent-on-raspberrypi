#!/bin/bash
# usage ./99_stop_cpcluster.sh

echo "reload systemctl properties on all nodes"
ssh -i ~/keys/rpi-key ubuntu@cpcluster1 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/rpi-key ubuntu@cpcluster2 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/rpi-key ubuntu@cpcluster3 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/rpi-key ubuntu@cpcluster4 'sudo systemctl daemon-reload; exit'
echo "finished: reload systemctl properties on all nodes"

ssh -i ~/keys/rpi-key ubuntu@cpcluster1 'sudo systemctl stop confluent-ksqldb; sudo systemctl stop confluent-server;sudo systemctl stop confluent-zookeeper; exit'
echo "Node cpcluster1 components stopped"
ssh -i ~/keys/rpi-key ubuntu@cpcluster2 'sudo systemctl stop confluent-kafka-connect; sudo systemctl stop confluent-server;sudo systemctl stop confluent-zookeeper; exit'
echo "Node cpcluster2 components stopped"
ssh -i ~/keys/rpi-key ubuntu@cpcluster3 'sudo systemctl stop confluent-kafka-rest; sudo systemctl stop confluent-server;sudo systemctl stop confluent-zookeeper; exit'
echo "Node cpcluster3 components stopped"
ssh -i ~/keys/rpi-key ubuntu@cpcluster4 'sudo systemctl stop confluent-schema-registry; sudo systemctl stop confluent-control-center; exit'
echo "Node cpcluster4 components stopped"
echo "CP cluster stopped"