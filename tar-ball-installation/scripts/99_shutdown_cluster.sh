#!/bin/bash
# usage ./99_shutdown_clustersh cpcluster1 
# usage ./99_shutdown_clustersh cpcluster2 
# usage ./99_shutdown_clustersh cpcluster3 
# usage ./99_shutdown_clustersh cpcluster4
# all 
# usage ./99_shutdown_cluster.sh cpcluster1 cpcluster2 cpcluster3 cpcluster4

for server; do ssh -i ~/keys/rpi-key ubuntu@$server 'sudo shutdown -h now; exit'; done
