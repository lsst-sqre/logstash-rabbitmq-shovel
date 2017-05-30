FROM       centos:7
MAINTAINER LSST SQuaRE <sqre-admin@lists.lsst.org>
LABEL      description="Logstash and RabbitMQ Shovel"
LABEL      name="lsstsqre/logstash-rabbitmq-shovel"
RUN        localedef -i en_US -f UTF-8 en_US.UTF-8

# Logstash environment variables.
ENV	   LOGSTASH_VERSION "5.4.0"
ENV        LOGSTASH_TGZ "logstash-${LOGSTASH_VERSION}-linux-x86_64.tar.gz"
ENV        LOGSTASH_URL "https://artifacts.elastic.co/downloads/logstash/logstash/${LOGSTASH_TGZ}"
ENV        LOGSTASH_HOME /opt/logstash-${LOGSTASH_VERSION}-linux-x86_64

# RabbitMQ environment variables.
ENV        ERLANG_URL "https://github.com/rabbitmq/erlang-rpm/releases/download/v19.3.4/erlang-19.3.4-1.el7.centos.x86_64.rpm"
ENV        RABBITMQ_URL "https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server-3.6.10-1.el7.noarch.rpm"
ENV        RABBITMQ_HOME /opt/rabbitmq

USER       root
WORKDIR    /opt/

# Install EPEL, Java 1.8 and supervisord
RUN        yum install -y epel-release java-1.8.0-openjdk supervisord which
ENV        JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN        export JAVACMD=`which java`

RUN        rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
ADD        logstash.repo /etc/yum.repos.d/logstash.repo
RUN        export JAVA_HOME=${JAVA_HOME};yum install -y logstash
ADD        029-output-rabbitmq.conf /etc/logstash/conf.d/029-output-rabbitmq.conf
ADD        010-input-beats.conf /etc/logstash/conf.d/010-input-beats.conf

# RUN        yum install -y socat logrotate
ADD        erlang.install.rpm.sh /opt/erlang.install.rpm.sh
ADD        rabbitmq.install.rpm.sh /opt/rabbitmq.install.rpm.sh
RUN        /usr/bin/bash /opt/erlang.install.rpm.sh
RUN        /usr/bin/bash /opt/rabbitmq.install.rpm.sh
RUN        yum install -y erlang rabbitmq-server
RUN        rabbitmq-plugins enable rabbitmq_shovel rabbitmq_management --offline
ADD        rabbitmq.config /etc/rabbitmq/rabbitmq.config
ADD        enabled_plugins /etc/rabbitmq/enabled_plugins
ADD        rabbitmq.definitions.json /etc/rabbitmq/rabbitmq.definitions.json

ADD        entrypoint.sh /entrypoint.sh
RUN        chmod +x /entrypoint.sh

# ENTRYPOINT ["/entrypoint.sh"]
ENTRYPOINT ["/bin/bash","--login"]
