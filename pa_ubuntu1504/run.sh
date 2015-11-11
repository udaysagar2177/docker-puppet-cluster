#!/bin/bash
set -xe

for SCRIPT in /opt/setup/scripts/*; do
  if [ -f "$SCRIPT" -a -x "$SCRIPT" ];  then
    $SCRIPT
  fi
done

sed -i -e "s/runinterval=60/runinterval=${random_runinterval}/g" /etc/puppet/puppet.conf

#puppet agent --test --debug --waitforcert=30
puppet agent --enable
puppet agent --no-daemonize

