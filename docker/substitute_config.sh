#!/bin/sh
set -e

set_config() {
    KEY=$1
    VALUE=$2
    if [ -z "${VALUE}" ]; then
	echo "${KEY} must be set" 1>&2
	exit 1
    fi
    sed -i "s/{{${KEY}}}/${VALUE}/g" /etc/rabbitmq/rabbitmq.config
}

if [ -z "${RABBITMQ_PAN_PASSWORD}" ] || [ -z "${RABBITMQ_TARGET_HOST}" ] || \
       [ -z "${RABBITMQ_TARGET_QUEUE}" ]; then
    echo 1>&2 "All of RABBITMQ_PAN_PASSWORD, RABBITMQ_TARGET_HOST, and RABBITMQ_TARGET_QUEUE"
    echo 1>&2 " must be set!"
    # Don't respawn too fast
    sleep 60
    exit 2
fi

set_config RABBITMQ_PAN_PASSWORD ${RABBITMQ_PAN_PASSWORD}
set_config RABBITMQ_TARGET_HOST ${RABBITMQ_TARGET_HOST}
set_config RABBITMQ_TARGET_QUEUE ${RABBITMQ_TARGET_QUEUE}
