#!/bin/bash
set -x

# setup the Puppet cluster
./setup_puppet_cluster.sh

# sleep to allow Puppet agent runs
sleep 10

# Exec into each container and check if file /opt/hello is created
CONTAINERS_LIST_FILE="cluster.txt"
FILE_NAME="/opt/hello"
cat $CONTAINERS_LIST_FILE | while read container
do
  if [[ $container != "puppet" ]]; then
  	echo "Checking $container"
  	file_exists=$(docker exec $container bash -c "[[ -f \"$FILE_NAME\" ]] && echo \"true\"")
  	if [[ "$file_exists" == "true" ]]; then
  		echo "Puppet run on $container is successful!"
  	else
  		echo "Puppet run on $container failed!"
  	fi
  fi
done

# shutdown the cluster
./shutdown_puppet_cluster.sh