FROM       centos:7
MAINTAINER sqre-admin
LABEL      description="Logstash and RabbitMQ Shovel" \
           name="lsstsqre/logstash-rabbitmq-shovel"

# Logstash environment variables.
ENV	   LOGSTASH_VERSION "5.4.0"
ENV        LOGSTASH_SITE "https://artifacts.elastic.co/downloads/logstash/"
ENV        LOGSTASH_RPM "logstash-${LOGSTASH_VERSION}.rpm"
ENV        LOGSTASH_URL "${LOGSTASH_SITE}${LOGSTASH_RPM}"

# RabbitMQ environment variables.
ENV        ERLANG_URL "https://github.com/rabbitmq/erlang-rpm/releases/download/v19.3.4/erlang-19.3.4-1.el7.centos.x86_64.rpm"
ENV        RABBITMQ_URL "https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server-3.6.10-1.el7.noarch.rpm"

EXPOSE     5044

USER       root
WORKDIR    /opt/

RUN        yum install -y epel-release
RUN        yum install -y socat logrotate which java-1.8.0-openjdk
RUN        yum install -y ${LOGSTASH_URL}
COPY       029-output-rabbitmq.conf /etc/logstash/conf.d/029-output-rabbitmq.conf
COPY       010-input-beats.conf /etc/logstash/conf.d/010-input-beats.conf

RUN        yum install -y ${ERLANG_URL}
RUN        yum install -y ${RABBITMQ_URL}
COPY       rabbitmq.config /etc/rabbitmq/rabbitmq.config

COPY       substitute_config.sh /substitute_config.sh
RUN        chmod +x /substitute_config.sh

#ENTRYPOINT ["/entrypoint.sh"]
ENTRYPOINT ["/bin/bash","--login"]
