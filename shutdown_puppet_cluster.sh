#!/bin/bash

CONTAINERS_LIST_FILE="cluster.txt"

stop_and_remove_container() {
  # Stop and remove container
  if [[ $(docker ps -a | grep "$1") ]]; then
   docker rm -f $1
  else
   echo "container not found for $1"
  fi
}

cat "$CONTAINERS_LIST_FILE" | while read line
do
  stop_and_remove_container $line
done