#!/bin/bash

timeToWait=300
interval=10

timeToWait=$1
interval=$2

while [[ $timeToWait > 0 ]]; do
  if [[ $(curl -XGET --basic --user admin:cloud --insecure https://localhost:8443/oo/rest/v1/version 2>/dev/null) =~ "build job name" ]]; then
      echo "OO Server Started OK"
      exit 0
  fi
  timeToWait=`expr $timeToWait - $interval`
  sleep $interval
done
echo "Timed out waiting for OO to start"
exit 1

