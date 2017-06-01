FROM       centos:7
MAINTAINER sqre-admin
LABEL      description="Logstash and RabbitMQ Shovel" \
           name="lsstsqre/logstash-rabbitmq-shovel"
RUN        localedef -i en_US -f UTF-8 en_US.UTF-8
EXPOSE     5044
USER       root
WORKDIR    /tmp

RUN        yum install -y epel-release java-1.8.0-openjdk which \
            socat logrotate
RUN        yum upgrade -y	    
RUN        yum install -y supervisor
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
            rabbitmq.shovel.definitions.json /etc/rabbitmq/
COPY       supervisord.conf /etc/
COPY       rabbitmq.ini logstash.ini /etc/supervisord.d/
COPY       entrypoint.sh substitute_config.sh /
RUN        chmod +x /entrypoint.sh /substitute_config.sh

ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["/bin/bash", "--login"]
