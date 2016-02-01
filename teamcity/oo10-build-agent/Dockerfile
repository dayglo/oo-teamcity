FROM java:openjdk-7-jdk

MAINTAINER george@opsrobot.co.uk

ENV MAVEN_VERSION 3.0.5

COPY apache-maven-$MAVEN_VERSION-bin.tar.gz /tmp

RUN cat /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

COPY m2/ /root/.m2

ADD buildAgent.zip /tmp
RUN unzip /tmp/buildAgent.zip -d /opt/teamcity-buildAgent && rm /tmp/buildAgent.zip
COPY buildAgent.properties /opt/teamcity-buildAgent/conf
COPY init.sh /opt/teamcity-buildAgent

RUN chmod +x /opt/teamcity-buildAgent/bin/agent.sh
RUN chmod +x /opt/teamcity-buildAgent/init.sh

CMD ["/opt/teamcity-buildAgent/init.sh"]