#!/bin/bash
echo "List topics before Delete"
kafka-topics --list --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 
# delete all old C3 topics
echo "Delete old topics"
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-AlertHistoryStore-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-AlertHistoryStore-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-Group-ONE_MINUTE-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-Group-ONE_MINUTE-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-Group-THREE_HOURS-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-Group-THREE_HOURS-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-KSTREAM-OUTEROTHER-0000000106-store-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-KSTREAM-OUTEROTHER-0000000106-store-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-KSTREAM-OUTERTHIS-0000000105-store-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-KSTREAM-OUTERTHIS-0000000105-store-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MetricsAggregateStore-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MetricsAggregateStore-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringMessageAggregatorWindows-ONE_MINUTE-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringMessageAggregatorWindows-ONE_MINUTE-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringMessageAggregatorWindows-THREE_HOURS-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringMessageAggregatorWindows-THREE_HOURS-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringStream-ONE_MINUTE-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringStream-ONE_MINUTE-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringStream-THREE_HOURS-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringStream-THREE_HOURS-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringTriggerStore-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringTriggerStore-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringVerifierStore-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-MonitoringVerifierStore-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-TriggerActionsStore-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-TriggerActionsStore-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-TriggerEventsStore-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-TriggerEventsStore-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-actual-group-consumption-rekey
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-aggregate-topic-partition-store-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-aggregate-topic-partition-store-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-aggregatedTopicPartitionTableWindows-ONE_MINUTE-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-aggregatedTopicPartitionTableWindows-ONE_MINUTE-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-aggregatedTopicPartitionTableWindows-THREE_HOURS-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-aggregatedTopicPartitionTableWindows-THREE_HOURS-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-cluster-rekey
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-expected-group-consumption-rekey
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-group-aggregate-store-ONE_MINUTE-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-group-aggregate-store-ONE_MINUTE-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-group-aggregate-store-THREE_HOURS-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-group-aggregate-store-THREE_HOURS-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-group-stream-extension-rekey
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-metrics-trigger-measurement-rekey
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-monitoring-aggregate-rekey-store-changelog
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-monitoring-aggregate-rekey-store-repartition
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-monitoring-message-rekey-store
kafka-topics --delete --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092 --topic _confluent-controlcenter-7-1-1-1-monitoring-trigger-event-rekey
echo "List topics after Delete"
kafka-topics --list --bootstrap-server cpcluster1:9092,cpcluster2:9092,cpcluster3:9092
