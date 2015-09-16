FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y vim curl wget
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
sudo dpkg -i puppetlabs-release-trusty.deb && \
sudo apt-get update -yq && sudo apt-get upgrade -yq && \
sudo apt-get install -yq puppetmaster

ADD autosign.conf /etc/puppet/autosign.conf
EXPOSE 8140

RUN sed -i s/^templatedir/#templatedir/ /etc/puppet/puppet.conf
CMD puppet master --verbose --no-daemonize
