#!/bin/bash
set -xe

for SCRIPT in /opt/setup/scripts/*; do
  if [ -f "$SCRIPT" -a -x "$SCRIPT" ];  then
    $SCRIPT
  fi
done

#puppet agent --test --debug --waitforcert=30
puppet agent --no-daemonize

