#!/bin/bash
set -xe

hostOS=$(cat /etc/*-release | grep PRETTY_NAME | grep -o '".*"' | sed 's/"//g' | sed -e 's/([^()]*)//g' | sed -e 's/[[:space:]]*$//')
if [ -f /etc/redhat-release ]; then
    hostOS=$(head -n 1 /etc/redhat-release)
fi

# Install Software on Ubuntu 12.04, 14.04, 15.04
if [[ "$hostOS" =~ "Ubuntu" ]]; then
    #apt-get install -y apache2

fi

# Install Software on Centos 5
if [[ "$hostOS" =~ "release 5" ]]; then
    #yum install -y httpd

fi

# Install Software on Centos 6
if [[ "$hostOS" =~ "release 6" ]]; then
    #yum install -y httpd
fi

# Install Software on Centos 7
if [[ "$hostOS" =~ "release 7" ]]; then
    #yum install -y httpd
fi

# Install Software on Amazon Linux 2014.09, 2015.03
if [[ "$hostOS" =~ "Amazon Linux" ]]; then
    #yum install -y httpd

fi

