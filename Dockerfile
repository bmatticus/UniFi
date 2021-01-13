#FROM phusion/baseimage:latest
FROM ubuntu:16.04
MAINTAINER bmatticus@gmail.com
# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
#ENV VERSION $VERSION
ARG VERSION

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /home nobody && \
 chown -R nobody:users /home


#Update APT-GET list
#RUN \
#  apt-get update -q && \
#  apt-get upgrade -y && \
#  apt-get dist-upgrade -y
RUN apt-get update -q

# Install Common Dependencies
RUN apt-get -y install curl software-properties-common wget

# Install OpenJDK 8
RUN apt-get -y install openjdk-8-jre 

RUN apt-get -y install apt-transport-https
ADD mongodb.conf /etc/mongodb.conf
RUN touch /etc/init.d/mongod
# MongoDB
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
#ADD mongodb.list /etc/apt/sources.list.d/mongodb.list
#RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
#RUN apt-get update && apt-get install -y mongodb-org
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
#RUN apt-get update && apt-get -y install mongodb-org
RUN apt-get update && apt-get -y install mongodb

# UniFi
RUN apt-get -y install jsvc binutils logrotate
RUN curl -L -o unifi_sysvinit_all.deb https://dl.ubnt.com/unifi/$VERSION/unifi_sysvinit_all.deb
RUN dpkg --install unifi_sysvinit_all.deb

# Wipe out auto-generated data
RUN rm -rf /var/lib/unifi/*

EXPOSE 8080 8081 8443 8843 8880

VOLUME ["/var/lib/unifi"]

WORKDIR /var/lib/unifi

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD ["/run.sh"]
