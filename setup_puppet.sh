#!/bin/bash
set -xe

# pass no-cache to build docker images with out using cache
if [ $1 = "no_cache" ]; then
   no_cache="--no-cache"
else
   no_cache=""
fi

cd /opt/puppetcluster/puppetmaster
docker build $no_cache -t puppet .
cd ..
os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6 pa_centos7 pa_amzlinux201409 pa_amzlinux201503)
for os in  ${os_array[@]}
do
    if [ -d $os ]; then
      cd $os
      cp ../install_software.sh .
      cp ../run.sh .
      cp ../puppet_slave.conf .
      docker build $no_cache -t $os .
      rm install_software.sh run.sh puppet_slave.conf
      cd ..
    fi
done

# START CONTAINERS
docker run -d -h "puppet" --name puppet -v /opt/puppetcluster/puppetmaster/manifests:/etc/puppet/manifests -v /opt/puppetcluster/puppetmaster/modules:/etc/puppet/modules puppet
echo "Sleeping to let the puppet master start"
sleep 10
for os in  ${os_array[@]}
do
    if [ -d $os ]; then
      docker run -d --name $os -h $os --link puppet:puppet $os
      echo "waiting for this puppet agent to shake hands with puppet master"
      sleep 2
    fi
done
