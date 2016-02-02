#!/bin/bash
set -xe

BUILD="false"
NO_CACHE="false"

while [[  "$#" -gt "0" ]]
do
  key="$1"
  case $key in
    -b|--build)
      BUILD="true"
      ;;
    -n|--no-cache)
      NO_CACHE="true"
      ;;
      *)
      echo "Unknown Option"
      ;;
  esac
  shift
done

# Check NO_CACHE and build images with out using cache
if [ "$NO_CACHE" = "true" ]; then
  if [ "$BUILD" = "true" ]; then
    no_cache="--no-cache"
  else
    echo "-n|--no-cache is valid only if -b|--build is given"
    exit 2;
  fi
else
   no_cache=""
fi

# pa_ubuntu1204 pa_ubuntu1404... are the names of the folders inside puppetagents folder
os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6 pa_wheezy pa_jessie)
#os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6 pa_amzlinux201409 pa_amzlinux201503 pa_amzlinux201509)

# Build the given docker image
build_docker_image(){
  os=$1
  (
    cd ./puppetagents
    if [ -d $os ]; then
      cd $os
      cp ../install_software.sh .
      cp ../run.sh .
      cp ../puppet_slave.conf .
      cp ../check_puppet_status.rb .
      docker build $no_cache -t $os .
      rm install_software.sh run.sh puppet_slave.conf check_puppet_status.rb
    fi
  )
}

check_for_all_docker_images() {
  docker_image_list=("${os_array[@]}" "puppet")
  for image_name in ${docker_image_list[@]}
  do
    if [[ -z $(docker images | grep -w "$image_name" | grep -Ev "grep") ]]; then
      BUILD="true"
      unset docker_image_list
      return
    fi
  done
  unset docker_image_list
}

if [[ $BUILD == "false" ]]; then
  check_for_all_docker_images
fi

# build docker images only if build argument is passed
if [ "$BUILD" = "true" ]; then
  (
    cd ./puppetmaster
    docker build $no_cache -t puppet .
  )
  for os in  ${os_array[@]}
  do
    build_docker_image $os
  done
fi

# Check and stop running puppet cluster
if [[ -f "cluster.txt" ]]; then
  ./shutdown_puppet_cluster.sh
fi

# File to save launched container names
CONTAINERS_LIST_FILE="cluster.txt"

# Start Puppetmaster
docker run \
    -d \
    -h "puppet" \
    --name puppet \
    -v $(pwd)/puppetmaster/manifests:/etc/puppet/manifests \
    -v $(pwd)/puppetmaster/modules:/etc/puppet/modules \
    puppet
echo "puppet" > $CONTAINERS_LIST_FILE
echo "Sleeping to let the puppetmaster start and initialize"
sleep 3

AGENT_SERIAL_NUMBER=0
# Start Puppet agents
for os in  ${os_array[@]}
do
    if [ -d ./puppetagents/$os ]; then
      random_runinterval=$(awk -vmin=60 -vmax=110 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
      AGENT_SERIAL_NUMBER=$(( $AGENT_SERIAL_NUMBER + 1 ))
      docker run \
          -d \
          --name puppet_agent_$AGENT_SERIAL_NUMBER \
          -e "random_runinterval=${random_runinterval}" \
          -h $os_$AGENT_SERIAL_NUMBER \
          --link puppet:puppet \
          $os
      echo "puppet_agent_${AGENT_SERIAL_NUMBER}" >> $CONTAINERS_LIST_FILE
      echo "waiting for puppet agent ${AGENT_SERIAL_NUMBER} to shake hands with puppet master"
      echo "random runinterval for this agent is ${random_runinterval}"
      sleep 1
    fi
done
