#!/bin/sh
set -e

set_config() {
    KEY=$1
    VALUE=$2
    if [ -z "${VALUE}" ]; then
	echo "${KEY} must be set" 1>&2
	exit 1
    fi
    sed -i "s/{{${KEY}}}/${VALUE}/g" ${RABBITMQ_CONFIG}/rabbitmq.config
}

if [ -z "${RABBITMQ_PAN_PASSWORD}" ]; then
    echo "RABBITMQ_PAN_PASSWORD must be set." 1>&2
    exit 1
fi

if [ -z "${RABBITMQ_TARGET_HOST}" ]; then
    echo "RABBITMQ_TARGET_HOST must be set." 1>&2
    exit 1
fi

if [ -z "${RABBITMQ_TARGET_VHOST}" ]; then
    echo "RABBITMQ_TARGET_VHOST must be set." 1>&2
    exit 1
fi

/usr/bin/supervisord -c /etc/supervisord.conf
