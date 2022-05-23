#!/bin/bash
# set title
export PROMPT_COMMAND='echo -ne "\033]0;Produce to RPI cluster\007"'
echo -e "\033];Produce to RPI cluster\007"

# Terminal 4
# Produce data to source from local laptop and check how fast both consumer windows are reading (almost real-time)
echo '{"name":"Apple Magic Mouse","count":1}'
echo '{"name":"Mac Book Pro","count":1}'
echo "produce into source:"
for i in `seq 1 1000`; do echo "{\"name\":\"Apple Magic Mouse\",\"count\":${i}}" | kafka-avro-console-producer --broker-list cpcluster1:9092,cpcluster2:9092,cpcluster3:9092,cpcluster4:9092 --topic cmorders_avro --property value.schema='{"type":"record","name":"schema","fields":[{"name":"name","type":"string"},{"name":"count", "type": "int"}]}' --producer.config client.config --property schema.registry.url=http://cpcluster4:8081; date +%s;  done

#kafka-avro-console-producer --broker-list cpcluster1:9092,cpcluster2:9092,cpcluster3:9092,cpcluster4:9092 --topic cmorders_avro \
# --property value.schema='{"type":"record","name":"schema","fields":[{"name":"name","type":"string"},{"name":"count", "type": "int"}]}' \
# --property schema.registry.url=http://cpcluster4:8081 


