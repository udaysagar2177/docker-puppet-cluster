# Puppet Cluster on Docker Containers
[![Build Status](https://travis-ci.org/udaysagar2177/docker-puppet-cluster.svg?branch=master)](https://travis-ci.org/udaysagar2177/docker-puppet-cluster)

## About
Complete automated setup of Puppet cluster using Docker

## Prerequisites
  - Docker must be installed on your system

## Overview
You can now setup a Puppetmaster and 8 Puppet agents by executing just one script. Puppetmaster is installed on Ubuntu 14.04 Docker image while 8 Puppet agents are installed on the following 7 Docker images:
  * Ubuntu 12.04
  * Ubuntu 14.04
  * Ubuntu 15.04
  * CentOS 5
  * CentOS 6
  * Amazon Linux 2014.09
  * Amazon Linux 2015.03
  * Amazon Linux 2015.09

## Usage
##### setup_puppet_cluster.sh
Use this script to setup and start the cluster. You can tweak this script to customize the type of operating system on which your Puppet agents must be running.  
Two command line options are available to this script. They are
  * -b | --build&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;builds the docker images of Puppet master and Puppet agents
  * -n | --no-cache&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;does not use cache to build the images, this is valid only when -b is given

This script will write the names of the launched Docker containers into a local file `cluster.txt`. This file will be used by other scripts to interact with the containers and so, it uses a naming convention. The Puppet master must be named as 'puppet'. The Puppet agents must be named as puppet_agent_\<serial_number\>. By default, setup_puppet_cluster.sh follows this convention.

##### shutdown_puppet_cluster.sh
Execute this script to shutdown the cluster. It will stop and remove all the containers listed in `cluster.txt`

##### check_cluster_status.sh
This script will get the last Puppet run status from the Puppet agents. It uses `docker exec` to execute a ruby script `check_puppet_status.rb` located inside each container and gets the last Puppet run status. This script will assume that Puppet agents are named as puppet_agent_\<serial_number\>.
