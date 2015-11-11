FROM ubuntu:14.04

RUN apt-get install -y wget
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    dpkg -i puppetlabs-release-trusty.deb && \
    apt-get update && \
    apt-get install -yq puppetmaster

RUN apt-get install -y git vim curl

RUN apt-get install -y puppet

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# Install puppet collections from puppetlabs
RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb && \
    dpkg -i puppetlabs-release-pc1-trusty.deb && \
    apt-get update

ADD autosign.conf /etc/puppet/autosign.conf
EXPOSE 8140

RUN sed -i s/^templatedir/#templatedir/ /etc/puppet/puppet.conf

#CMD puppet master --verbose --no-daemonize

CMD ["/usr/bin/supervisord"]
