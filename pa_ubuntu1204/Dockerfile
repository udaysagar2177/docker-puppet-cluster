FROM ubuntu:12.04

RUN apt-get update
RUN apt-get install -y vim 
RUN apt-get install -y curl

RUN apt-get install -y puppet

RUN mkdir /opt/setup
ADD puppet_slave.conf /etc/puppet/puppet.conf

# Install Software like apache, memcached etc
RUN apt-get install -y apache2

ADD install_software.sh /opt/setup/scripts/
ADD run.sh /opt/setup/

CMD /opt/setup/run.sh

#CMD puppet agent --verbose --debug --no-daemonize
