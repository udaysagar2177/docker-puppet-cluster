#!/bin/bash
set -e

os_array=(pa_ubuntu1204 pa_ubuntu1404 pa_ubuntu1504 pa_centos5 pa_centos6 pa_centos7 pa_amzlinux201409 pa_amzlinux201503 pa_amzlinux201509)
for os in  ${os_array[@]}
do
    if [ -d $os ]; then
       status=$(docker exec -it $os bash -c /opt/setup/check_puppet_status.rb)
       if [[ "$status" =~ "OK" ]]; then
          echo "${os} : OK"
       else
          echo $status
       fi
    fi
done
