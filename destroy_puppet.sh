#!/bin/bash
set -e

if [[ $(docker ps -a | grep "puppet") ]]; then
   docker rm -f  puppet
else
   echo "container not found for puppet"
fi
os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6 pa_centos7 pa_amzlinux201409 pa_amzlinux201503 pa_amzlinux201509)
for os in ${os_array[@]}
do
   if [[ $(docker ps -a | grep "${os}") ]]; then
       docker rm -f $os
   else
       echo "container not found for ${os}"
   fi
done
