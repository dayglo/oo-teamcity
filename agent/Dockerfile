FROM maven
MAINTAINER george@opsrobot.co.uk

ADD buildAgent.zip /tmp
RUN unzip /tmp/buildAgent.zip -d /opt/teamcity-buildAgent && rm /tmp/buildAgent.zip
COPY buildAgent.properties /opt/teamcity-buildAgent/conf
COPY init.sh /opt/teamcity-buildAgent

RUN chmod +x /opt/teamcity-buildAgent/bin/agent.sh
RUN chmod +x /opt/teamcity-buildAgent/init.sh

CMD ["/opt/teamcity-buildAgent/init.sh"]