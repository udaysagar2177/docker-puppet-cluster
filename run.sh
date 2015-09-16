#!/bin/bash
set -xe

for SCRIPT in /opt/setup/scripts/*; do
  if [ -f "$SCRIPT" -a -x "$SCRIPT" ];  then
    $SCRIPT
  fi
done

random=$(shuf -i 70-150 -n 1)
sed -i -e "s/runinterval=60/runinterval=${random}/g" /etc/puppet/puppet.conf

#puppet agent --test --debug --waitforcert=30
puppet agent --enable
puppet agent --no-daemonize

