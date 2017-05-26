#!/bin/sh
set -e

set_config() {
    KEY=$1
    VALUE=$2
    if [ -z "${VALUE}" ]; then
	echo "${KEY} must be set" 1>&2
	exit 1
    fi
    sed -i "s/{{${KEY}}}/${VALUE}/g" ${FILEBEAT_HOME}/filebeat.yml
}

if [ -z "${LOGSTASH_HOME}" ]; then
    echo "LOGSTASH_HOME must be set." 1>&2
    exit 1
fi

if [ -z "${RABBITMQ_HOME}" ]; then
    echo "RABBITMQ_HOME must be set." 1>&2
    exit 1
fi
