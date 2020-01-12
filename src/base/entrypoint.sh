#!/usr/bin/env bash

declare -A spark_services

spark_services[livy]="livy-server start"

# $1: message
function __log__() {
  echo "[$(date '+%d/%m/%Y %H:%M:%S')] -> $1"
}

if [[ "${HADOOP_DAEMONS}" != "NULL" ]]; then
  # Load Hadoop configurations and start daemons
  ./hadoop_entrypoint.sh $1

  # Load Spark configurations
  ./spark_config_loader.sh

  if [[ "${SPARK_SERVICES}" != "NULL" ]]; then
    __log__ "Starting Spark services..."

    for spark_service in ${SPARK_SERVICES[@]}; do
      __log__ "Starting Spark service \"$spark_service\""
      ${spark_services[$spark_service]}
    done
  fi

  if [[ "$1" == "spark" ]]; then
    tail -f /dev/null
  fi
fi