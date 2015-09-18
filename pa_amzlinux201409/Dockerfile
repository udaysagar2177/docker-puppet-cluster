FROM quay.io/signalfuse/amazon-linux-2014.09

RUN yum -y update
RUN yum install -y vim curl wget net-tools

# Install Software like apache, memcached etc
RUN yum install -y httpd

# Install puppet
RUN rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-5.noarch.rpm
RUN yum install -y puppet3


ADD puppet_slave.conf /etc/puppet/puppet.conf

RUN mkdir /opt/setup
ADD check_puppet_status.rb /opt/setup/
ADD install_software.sh /opt/setup/scripts/
ADD run.sh /opt/setup/

CMD /opt/setup/run.sh
