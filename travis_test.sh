#!/bin/bash
set -x

function test(){
	SETUP_PUPPET_CLUSTER_OPTIONS=$1
	# setup the Puppet cluster
	./setup_puppet_cluster.sh $SETUP_PUPPET_CLUSTER_OPTIONS

	# sleep to allow Puppet agent runs
	sleep 60

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

	# Test if check_cluster_status.sh is working properly
	(cd scripts && ./check_cluster_status.sh)

	# shutdown the cluster
	./shutdown_puppet_cluster.sh
}

# setup Puppet cluster by building the images with out using cache
test "-b -n"

# setup Puppet cluster with only 3 Puppet agents running on pa_ubuntu1404
ORIGINAL_LINE="os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6)"
NEW_LINE="os_array=(pa_ubuntu1404 pa_ubuntu1404 pa_ubuntu1404)"
sed -i -e "s/$ORIGINAL_LINE/$NEW_LINE/" setup_puppet_cluster.sh
test