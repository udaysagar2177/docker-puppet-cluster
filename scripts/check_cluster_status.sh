#!/bin/bash

CONTAINERS_LIST_FILE="../cluster.txt"

get_status_from_container(){
	os=$1
	status=$(docker exec $os bash -c /opt/setup/check_puppet_status.rb)
	if [[ "$status" =~ "OK" ]]; then
	  echo "${os} : OK"
	else
	  echo $status
	fi
}

cat "$CONTAINERS_LIST_FILE" | while read container
do
  get_status_from_container $container
done