FROM ubuntu
MAINTAINER jason@automationlogic.com

ENV DEBIAN_FRONTEND noninteractive
ENV MODE=standalone

RUN apt-get update && apt-get install bzip2 && apt-get install net-tools && apt-get install -y curl
COPY start /
RUN chmod 755 /start
#COPY linux /tmp
COPY ooinstaller /tmp

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install ``python-software-properties``, ``software-properties-common`` and PostgreSQL 9.3
#  There are some warnings (in red) that show up during the build. You can hide
#  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
#USER postgres
USER root
# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/9.4/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN su postgres -c   "/etc/init.d/postgresql start" &&\
    su postgres -c   "psql --command \"ALTER USER postgres WITH PASSWORD 'password';\"" &&\
    su postgres -c   "psql --command \"update pg_database set datistemplate='false' where datname='template1';\"" &&\
    su postgres -c   "psql --command \"drop database template1;\""  &&\
    su postgres -c   "psql --command \"create database template1 encoding='UTF8' template template0;\"" &&\
    su postgres -c   "psql --command \"update pg_database set datistemplate='true' where datname='template1';\"" &&\ 
    su postgres -c   "psql --command \"create table test1 (name VARCHAR(10));\""

# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

#USER root
# Install OO
RUN su postgres -c "/etc/init.d/postgresql start" &&\
    chmod +x /tmp/installer-linux64.bin  &&\
    sleep 1  &&\
    /tmp/installer-linux64.bin -s /tmp/new.sample-silent.properties  &&\
    rm /tmp/installer-linux64.bin  &&\
    rm /tmp/new.sample-silent.properties  &&\
    sleep 1 &&\
    cat /usr/local/hp/oo/installer.log  &&\
    curl --insecure -H "Content-Type: application/json" -d '{"username":"admin","password":"cloud","roles":[{"name":"ADMINISTRATOR"},{"name":"SYSTEM_ADMIN"}]}' https://localhost:8443/oo/rest/v1/users  &&\
    curl --insecure -H "Content-Type: application/json" -d '{"username":"csauser","password":"cloud","roles":[{"name":"ADMINISTRATOR"},{"name":"SYSTEM_ADMIN"}]}' https://localhost:8443/oo/rest/v1/users  &&\
    curl -k -H "content-type: application/json" -X PUT -d '{"enable":true}' https://localhost:8443/oo/rest/v1/authns  &&\
    /usr/local/hp/oo/java/bin/keytool -exportcert -alias tomcat -file /tmp/oo.crt -keystore /usr/local/hp/oo/central/var/security/key.store -storepass changeit  &&\
    chmod 755 /tmp/checkOOStarted.sh  &&\
    mv /tmp/checkOOStarted.sh /usr/local/hp/oo/.  &&\
    sleep 1  &&\
    /usr/local/hp/oo/checkOOStarted.sh 120  15 &&\
    touch /firstboot.flag

# Set the default command to run when starting the container
USER root
CMD /start

EXPOSE 5432 
EXPOSE 8080
EXPOSE 8443
