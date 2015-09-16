#!/bin/bash
set -x

docker stop puppet
os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6 pa_centos7 pa_amzlinux201409 pa_amzlinux201503)
for os in ${os_array[@]}
do
    docker stop $os
done

docker rm $(docker ps -q -f status=exited)
