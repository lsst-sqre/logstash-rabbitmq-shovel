FROM       centos:7
MAINTAINER sqre-admin
LABEL      description="Logstash and RabbitMQ Shovel"
           name="lsstsqre/logstash-rabbitmq-shovel"

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

RUN        yum install epel

RUN        yum install java-1.8.0-openjdk
ENV        JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN        rpm -i ${LOGSTASH_URL}
ADD        029-output-rabbitmq.conf /etc/logstash/conf.d/029-output-rabbitmq.conf
ADD        010-input-beats.conf /etc/logstash/conf.d/010-input-beats.conf

RUN        yum install socat logrotate
RUN        rpm -i ${ERLANG_URL}
RUN        rpm -i ${RABBITMQ_URL}
ADD        rabbitmq.config /etc/rabbitmq/rabbitmq.config

ADD        entrypoint.sh /entrypoint.sh
RUN        chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]