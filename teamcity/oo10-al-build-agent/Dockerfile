FROM python:2.7.11

MAINTAINER george@opsrobot.co.uk

# Matt's hpoo client
RUN pip install requests &&\
    pip install git+https://bitbucket.org/automationlogic/oo_client.git

#Teamcity agent and init script
ADD buildAgent.zip /tmp
RUN apt-get update &&\
    apt-get install unzip &&\
    apt-get autoclean &&\
    rm -rf /var/lib/apt/lists/* &&\
    unzip /tmp/buildAgent.zip -d /opt/teamcity-buildAgent &&\
    rm /tmp/buildAgent.zip 

COPY buildAgent.properties /opt/teamcity-buildAgent/conf
COPY init.sh /opt/teamcity-buildAgent

RUN chmod +x /opt/teamcity-buildAgent/bin/agent.sh &&\
    chmod +x /opt/teamcity-buildAgent/init.sh


# Java
# Nicked from the java docker image source on docker hub.
ENV LANG C.UTF-8
RUN { \
		echo '#!/bin/bash'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV JAVA_VERSION 7u95
ENV JAVA_DEBIAN_VERSION 7u95-2.6.4-1~deb8u1
RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
		openjdk-7-jdk="$JAVA_DEBIAN_VERSION" \
	&& rm -rf /var/lib/apt/lists/* \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]


# Our init script
CMD ["/opt/teamcity-buildAgent/init.sh"]