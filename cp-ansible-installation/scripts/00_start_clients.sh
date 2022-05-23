#!/bin/bash
## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

echo "Delete and create topic"
echo "delete topic"
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092,cpcluster4:9092 --topic cmorders_avro
echo "create topic"
kafka-topics --create --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092,cpcluster4:9092 --topic cmorders_avro \
--replication-factor 3 --partitions 6 --config confluent.tier.enable=true \
--config confluent.tier.local.hotset.ms=60000 \
--config retention.ms=1800000
echo "describe topic"
kafka-topics --describe --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092,cpcluster4:9092 --topic cmorders_avro 
echo "current subjects"
curl http://192.168.178.83:8081/subjects
curl http://192.168.178.83:8081/subjects/cmorders_avro-value/versions
curl -X GET http://192.168.178.83:8081/subjects/cmorders_avro-value/versions/1 | jq

# open Replicator, Producer and Consumer Terminals
echo "Open producer and consumer Terminals with iterm...."
open -a iterm
sleep 10
osascript 01_clients.scpt $BASEDIR
# Finish
echo "iterm producer and consumer started"