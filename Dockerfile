FROM ubuntu:16.04

ARG ZOOKEEPER_VERSION=3.4.10
ARG HADOOP_VERSION=3.1.1
ARG ACCUMULO_VERSION=1.9.2

RUN echo -e "\n* soft nofile 65536\n* hard nofile 65536" >> /etc/security/limits.conf

RUN apt-get install -y tar
RUN apt-get update 
RUN apt-get install -y --no-install-recommends apt-utils
# RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get install -y default-jdk
# RUN apt-get install -y which
# RUN apt-get install -y procps-ng hostname

# hadoop
ADD hadoop-${HADOOP_VERSION}.tar.gz /usr/local/
RUN ln -s /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop

# Zookeeper
ADD zookeeper-${ZOOKEEPER_VERSION}.tar.gz /usr/local/
RUN ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION} /usr/local/zookeeper

# Accumulo
ADD accumulo-${ACCUMULO_VERSION}-bin.tar.gz /usr/local/
RUN ln -s /usr/local/accumulo-${ACCUMULO_VERSION} /usr/local/accumulo

# Diagnostic tools :/
RUN apt-get install -y net-tools
RUN apt-get install -y telnet

ENV ACCUMULO_HOME /usr/local/accumulo
ENV PATH $PATH:$ACCUMULO_HOME/bin
ADD accumulo/* $ACCUMULO_HOME/conf/

ADD start-accumulo /start-accumulo
ADD start-process /start-process

CMD /start-accumulo

EXPOSE 9000 50095 42424 9995 9997

