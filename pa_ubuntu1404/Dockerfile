FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y vim 
RUN apt-get install -y curl
RUN apt-get -y install wget dpkg net-tools

# Install Software like apache, memcached etc

# APACHE
RUN apt-get install -y apache2

# ELASTICSEARCH
# RUN wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.1.deb
# RUN dpkg -i elasticsearch-1.7.1.deb

# MEMCACHED
# RUN apt-get install -y libevent-dev sasl2-bin && \
#    apt-get install -y -V memcached libmemcached-tools php5 php5-memcache php5-memcached && \
#    apt-get clean

# POSTGRESQL
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
# RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
# RUN apt-get update && \
#    apt-get -y -q install -V postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 && \
#    apt-get clean

# KAFKA
# RUN apt-get install -y zookeeper wget supervisor dnsutils && \
#    rm -rf /var/lib/apt/lists/* && \
#    apt-get clean
# RUN wget http://www.carfab.com/apachesoftware/kafka/0.8.2.1/kafka_2.11-0.8.2.1.tgz -O /tmp/kafka_2.11-0.8.2.1.tgz && \
#    tar xfz /tmp/kafka_2.11-0.8.2.1.tgz -C /opt && \
#    rm /tmp/kafka_2.11-0.8.2.1.tgz

# Puppet Setup
RUN apt-get install -y puppet
RUN mkdir /opt/setup
ADD puppet_slave.conf /etc/puppet/puppet.conf
 

ADD install_software.sh /opt/setup/scripts/
ADD run.sh /opt/setup/

CMD /opt/setup/run.sh
