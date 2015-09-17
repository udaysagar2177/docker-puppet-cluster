# PuppetCluster
Running puppet on docker containers

To setup the puppet cluster, copy this repo into /opt/ folder and run ./setup_puppet.sh

To destroy the puppet cluster, run ./destroy_puppet.sh. You may see some errors, it is because we are not checking if a container is running before stopping or removing it.

To ssh into the docker container, use docker exec -it **containerName** bash
