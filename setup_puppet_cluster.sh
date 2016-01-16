#!/bin/bash
set -xe

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
  fi
else
   no_cache=""
fi

os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6 pa_centos7 pa_amzlinux201409 pa_amzlinux201503 pa_amzlinux201509)

# build docker images only if build argument is passed
if [ "$BUILD" = "true" ]; then
  (
    cd ./puppetmaster
    docker build $no_cache -t puppet .
  )
  (
    cd ./puppetagents
    for os in  ${os_array[@]}
    do
        if [ -d $os ]; then
          cd $os
          cp ../install_software.sh .
          cp ../run.sh .
          cp ../puppet_slave.conf .
          cp ../check_puppet_status.rb .
          docker build $no_cache -t $os .
          rm install_software.sh run.sh puppet_slave.conf check_puppet_status.rb
          cd ..
        fi
    done
  )
fi

# Check and stop running puppet cluster
./shutdown_puppet_cluster.sh

# Start Puppet agents
docker run \
    -d \
    -h "puppet" \
    --name puppet \
    -v $(pwd)/puppetmaster/manifests:/etc/puppet/manifests \
    -v $(pwd)/puppetmaster/modules:/etc/puppet/modules \
    puppet
echo "Sleeping to let the puppetmaster start and initialize"
sleep 10

# Start Puppet agents
( 
  cd ./puppetagents
  for os in  ${os_array[@]}
  do
      if [ -d $os ]; then
        random_runinterval=$(awk -vmin=60 -vmax=110 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
        docker run \
            -d \
            --name $os \
            -e "random_runinterval=${random_runinterval}" \
            -h $os \
            --link puppet:puppet \
            $os
        echo "waiting for this puppet agent to shake hands with puppet master"
        echo "random runinterval for this agent is ${random_runinterval}"
        sleep 2
      fi
  done
)