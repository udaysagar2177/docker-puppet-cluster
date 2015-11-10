FROM ubuntu:14.04

RUN apt-get update

# Install common software
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get -y install wget dpkg net-tools

# Install puppet labs
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    dpkg -i puppetlabs-release-trusty.deb && \
    apt-get update

# Puppet Setup
RUN apt-get install -y puppet
ADD puppet_slave.conf /etc/puppet/puppet.conf

RUN mkdir /opt/setup
ADD check_puppet_status.rb /opt/setup/
ADD install_software.sh /opt/setup/scripts/
ADD run.sh /opt/setup/

EXPOSE 8081
CMD /opt/setup/run.sh
