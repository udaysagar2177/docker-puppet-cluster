FROM ubuntu:15.04
MAINTAINER Uday Sagar Shiramshetty <udaysagar.2177@gmail.com>

RUN apt-get update
RUN apt-get install -y vim 
RUN apt-get install -y curl
RUN apt-get -y install wget dpkg net-tools

# Install Software like apache, memcached etc
RUN apt-get install -y apache2

# Puppet Setup
RUN apt-get install -y puppet
ADD puppet_slave.conf /etc/puppet/puppet.conf
 
RUN mkdir /opt/setup
ADD check_puppet_status.rb /opt/setup/
ADD install_software.sh /opt/setup/scripts/
ADD run.sh /opt/setup/

CMD /opt/setup/run.sh
