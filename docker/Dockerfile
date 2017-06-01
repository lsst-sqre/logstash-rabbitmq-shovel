FROM       centos:7
MAINTAINER LSST SQuaRE <sqre-admin@lists.lsst.org>
LABEL      description="Logstash and RabbitMQ Shovel"
LABEL      name="lsstsqre/logstash-rabbitmq-shovel"
RUN        localedef -i en_US -f UTF-8 en_US.UTF-8
USER       root
WORKDIR    /opt/

# Install EPEL, Java 1.8 and supervisor
RUN        yum install -y epel-release java-1.8.0-openjdk which
RUN        yum upgrade -y
RUN        yum install -y supervisor
ENV        JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN        export JAVACMD=`which java`

# Install logstash
RUN        rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
COPY       logstash.repo /etc/yum.repos.d/logstash.repo
RUN        export JAVA_HOME=${JAVA_HOME};yum install -y logstash
COPY       010-input-beats.conf 029-output-rabbitmq.conf \
            /etc/logstash/conf.d/010-input-beats.conf

# Install erlang and RabbitMQ
COPY       erlang.install.rpm.sh /opt/erlang.install.rpm.sh
COPY       rabbitmq.install.rpm.sh /opt/rabbitmq.install.rpm.sh
RUN        /usr/bin/bash /opt/erlang.install.rpm.sh
RUN        /usr/bin/bash /opt/rabbitmq.install.rpm.sh
RUN        yum install -y erlang rabbitmq-server
RUN        rabbitmq-plugins enable rabbitmq_shovel rabbitmq_management --offline
ENV        RABBITMQ_CONFIG "/etc/rabbitmq"
COPY       rabbitmq.config enabled_plugins rabbitmq.definitions.json \
           rabbitmq.shovel.definitions.json $RABBITMQ_CONFIG/rabbitmq.definitions.json

# Copy supervisor configurations.
ENV        SUPERVISOR_CONFIG "/etc/supervisord.d"
COPY       rabbitmq.ini $SUPERVISOR_CONFIG/rabbitmq.ini
COPY       logstash.ini $SUPERVISOR_CONFIG/logstash.ini

# Copy substitution script.
COPY       substitute_config.sh /substitute_config.sh
RUN        chmod +x /substitute_config.sh

COPY       entrypoint.sh /entrypoint.sh
RUN        chmod +x /entrypoint.sh

EXPOSE     5044

# ENTRYPOINT ["/entrypoint.sh"]
ENTRYPOINT ["/bin/bash","--login"]
