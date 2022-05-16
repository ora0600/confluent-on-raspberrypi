#!/bin/bash
# usage ./98_startup_clustersh 
# start via systemD service
# Start Kafka and Zookeeper
#ubuntu@cpserver1 'sudo systemctl start cpserver; exit'; done
#ubuntu@cpserver2 'sudo systemctl start cpserver; exit'; done
#ubuntu@cpserver3 'sudo systemctl start cpserver; exit'; done
# Schema Registry
#ssh ubuntu@cpserver4 'sudo systemctl start schemaregistry; sleep 10; exit'; done
# REST Proxy
#ssh ubuntu@cpserver3 'sudo systemctl start restproxy; sleep 10; exit'; done
# connect
#ssh ubuntu@cpserver1 'sudo systemctl start connect; sleep 10; exit'; done
# ksqlDB
#ssh ubuntu@cpserver2 'sudo systemctl start ksqldb; sleep 10; exit'; done
# Control Center
#ssh ubuntu@cpserver4 'sudo systemctl start controlcenter; sleep 10; exit'; done

# Start via commands
echo zookeeper cpcluster1
ssh ubuntu@cpcluster1 '/home/ubuntu/software/confluent/bin/zookeeper-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/zookeeper.properties'
echo zookeeper cpcluster2
ssh ubuntu@cpcluster2 '/home/ubuntu/software/confluent/bin/zookeeper-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/zookeeper.properties'
echo zookeeper cpcluster3
ssh ubuntu@cpcluster3 '/home/ubuntu/software/confluent/bin/zookeeper-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/zookeeper.properties'
echo 'wait 30 seconds'
sleep 30
echo kafka cpcluster1
#ssh ubuntu@cpcluster1 '/home/ubuntu/software/confluent/bin/kafka-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/server.properties > /dev/null 2>&1 &'
ssh ubuntu@cpcluster1 '/home/ubuntu/software/confluent/bin/kafka-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/server.properties'
echo kafka cpcluster2
ssh ubuntu@cpcluster2 '/home/ubuntu/software/confluent/bin/kafka-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/server.properties'
echo kafka cpcluster3
ssh ubuntu@cpcluster3 '/home/ubuntu/software/confluent/bin/kafka-server-start -daemon /home/ubuntu/software/confluent/etc/kafka/server.properties'
echo 'wait 30 seconds'
sleep 30
echo schemaregistry cpcluster4
ssh ubuntu@cpcluster4 '/home/ubuntu/software/confluent/bin/schema-registry-start -daemon /home/ubuntu/software/confluent/etc/schema-registry/schema-registry.properties'
echo 'wait 30 seconds'
sleep 30
echo restproxy cpcluster3
ssh ubuntu@cpcluster3 '/home/ubuntu/software/confluent/bin/kafka-rest-start -daemon /home/ubuntu/software/confluent/etc/kafka-rest/kafka-rest.properties > /dev/null 2>&1 &'
echo 'wait 30 seconds'
sleep 30
echo connect cpcluster2
ssh ubuntu@cpcluster2 '/home/ubuntu/software/confluent/bin/connect-distributed -daemon /home/ubuntu/software/confluent/etc/kafka/connect-distributed.properties'
echo 'wait 30 seconds'
sleep 30
echo ksqldb cpcluster1
ssh ubuntu@cpcluster1 '/home/ubuntu/software/confluent/bin/ksql-server-start -daemon /home/ubuntu/software/confluent/etc/ksqldb/ksql-server.properties > /dev/null 2>&1 &'
echo 'wait 30 seconds'
sleep 30
echo controlcenter cpcluster4
ssh ubuntu@cpcluster4 '/home/ubuntu/software/confluent/bin/control-center-start -daemon /home/ubuntu/software/confluent/etc/confluent-control-center/control-center.properties > /dev/null 2>&1 &'