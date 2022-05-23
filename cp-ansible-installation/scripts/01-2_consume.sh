#!/bin/bash
# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Consume from RPI-Cluster\007"'
echo -e "\033];Consume from RPI-Cluster\007"

# Terminal 3
# Consume from Destination Cluster (AWS in Franfurt)
echo "Consume from RPI-Cluster: "
kafka-avro-console-consumer --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092,cpcluster4:9092 --topic cmorders_avro --from-beginning --property schema.registry.url=http://cpcluster4:8081 