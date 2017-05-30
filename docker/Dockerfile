FROM       centos:7
MAINTAINER sqre-admin
LABEL      description="Logstash and RabbitMQ Shovel" \
           name="lsstsqre/logstash-rabbitmq-shovel"
RUN        localedef -i en_US -f UTF-8 en_US.UTF-8

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

# Install EPEL, Java 1.8 and supervisord
RUN        yum install -y epel-release java-1.8.0-openjdk supervisord which \
            socat logrotate

RUN        rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
COPY       logstash.repo /etc/yum.repos.d/logstash.repo
RUN        yum install -y logstash
COPY       029-output-rabbitmq.conf /etc/logstash/conf.d/029-output-rabbitmq.conf
COPY       010-input-beats.conf /etc/logstash/conf.d/010-input-beats.conf

COPY       erlang.install.rpm.sh /opt/erlang.install.rpm.sh
COPY       rabbitmq.install.rpm.sh /opt/rabbitmq.install.rpm.sh
RUN        /usr/bin/bash /opt/erlang.install.rpm.sh
RUN        /usr/bin/bash /opt/rabbitmq.install.rpm.sh
RUN        yum install -y erlang rabbitmq-server
RUN        rabbitmq-plugins enable rabbitmq_shovel rabbitmq_management --offline
COPY       rabbitmq.definitions.json enabled_plugins rabbitmq.config \
            /etc/rabbitmq/
COPY       rabbitmq.definitions.json /etc/rabbitmq/rabbitmq.definitions.json

COPY       substitute_config.sh /substitute_config.sh
RUN        chmod +x /substitute_config.sh


# ENTRYPOINT ["/entrypoint.sh"]
ENTRYPOINT ["/bin/bash","--login"]
