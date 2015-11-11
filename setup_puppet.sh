#!/bin/bash
set -xe

# pass no-cache to build docker images with out using cache
if [ $2 = "no_cache" ]; then
   no_cache="--no-cache"
else
   no_cache=""
fi

function get_random_runinterval()
{
    random_runinterval=$(awk -vmin=60 -vmax=110 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
}

#os_array=(puppetdb pa_ubuntu1204)
os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6 pa_centos7 pa_amzlinux201409 pa_amzlinux201503 pa_amzlinux201509)

# build docker images only if build argument is passed
if [ $1 = "build" ]; then
  cd /opt/puppetcluster/puppetmaster
  cp ../supervisord.conf .
  docker build $no_cache -t puppet .
  rm -f supervisord.conf
  cd ..
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
fi

# START PUPPETMASTER
docker run -d -h "puppet" --add-host "puppet.ec2.internal:127.0.0.1" --name puppet -v /opt/puppetcluster/puppetmaster/manifests:/etc/puppet/manifests -v /opt/puppetcluster/puppetmaster/modules:/etc/puppet/modules puppet
echo "Sleeping to let the puppet master start"
sleep 5
# START AN AGENT ON PUPPETMASTER
docker exec puppet bash -c "puppet agent --enable && puppet agent"
# START DIFFERENT PUPPET AGENTS
for os in  ${os_array[@]}
do
    if [ -d $os ]; then
      get_random_runinterval
      docker run -d --name $os -e "random_runinterval=${random_runinterval}" -h $os --link puppet:puppet $os
      echo "waiting for this puppet agent to shake hands with puppet master"
      echo "random runinterval for this agent is ${random_runinterval}"
      sleep 2
    fi
done
