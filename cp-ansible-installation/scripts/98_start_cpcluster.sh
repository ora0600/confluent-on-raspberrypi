#!/bin/bash
# usage ./98_start_cpcluster.sh

echo "reload systemctl properties on all nodes"
ssh -i ~/keys/rpi-key ubuntu@cpcluster1 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/rpi-key ubuntu@cpcluster2 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/rpi-key ubuntu@cpcluster3 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/rpi-key ubuntu@cpcluster4 'sudo systemctl daemon-reload; exit'
echo "finished: reload systemctl properties on all nodes"

ssh -i ~/keys/rpi-key ubuntu@cpcluster1 'sudo systemctl start confluent-zookeeper;sudo systemctl start confluent-server; exit'
echo "cpcluster1 ZK and CP-Server started"
ssh -i ~/keys/rpi-key ubuntu@cpcluster2 'sudo systemctl start confluent-zookeeper;sudo systemctl start confluent-server; exit'
echo "cpcluster2 ZK and CP-Server started"
ssh -i ~/keys/rpi-key ubuntu@cpcluster3 'sudo systemctl start confluent-zookeeper;sudo systemctl start confluent-server; exit'
echo "cpcluster3 ZK and CP-Server started"
ssh -i ~/keys/rpi-key ubuntu@cpcluster4 'sudo systemctl start confluent-schema-registry; exit'
echo "cpcluster4 SR started"
ssh -i ~/keys/rpi-key ubuntu@cpcluster3 'sudo systemctl start confluent-kafka-rest; exit'
echo "cpcluster3 REST-Proxy started"
ssh -i ~/keys/rpi-key ubuntu@cpcluster2 'sudo systemctl start confluent-kafka-connect; exit'
echo "cpcluster2 Connect started"
ssh -i ~/keys/rpi-key ubuntu@cpcluster1 'sudo systemctl start confluent-ksqldb; exit'
echo "cpcluster1 ksqlDB started"
ssh -i ~/keys/rpi-key ubuntu@cpcluster4 'sudo systemctl start confluent-control-center; exit'
echo "cpcluster4 C3 started"

echo "CP cluster started"