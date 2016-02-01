#!/bin/bash
/opt/teamcity-buildAgent/bin/agent.sh start

echo Waiting for /opt/teamcity-buildAgent/logs/teamcity-agent.log to exist
while [ ! -f /opt/teamcity-buildAgent/logs/teamcity-agent.log ] ;
do
	echo "."
    sleep 1
done

tail -f /opt/teamcity-buildAgent/logs/teamcity-agent.log