#!/bin/bash

cp ../pa_ubuntu1404/Dockerfile  /tmp/Dockerfile1404_backup
cp ../pa_ubuntu1504/Dockerfile  /tmp/Dockerfile1504_backup
cp ../pa_ubuntu1204/Dockerfile ../pa_ubuntu1404/Dockerfile
cp ../pa_ubuntu1204/Dockerfile ../pa_ubuntu1504/Dockerfile
sed -i -e 's/ubuntu:12.04/ubuntu:14.04/' ../pa_ubuntu1404/Dockerfile
sed -i -e 's/ubuntu:12.04/ubuntu:15.04/' ../pa_ubuntu1504/Dockerfile
