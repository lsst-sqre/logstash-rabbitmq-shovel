#!/bin/sh
set -e

set_config() {
    KEY=$1
    VALUE=$2
    FILE=$3
    if [ -z "${VALUE}" ]; then
	echo "${KEY} must be set" 1>&2
	exit 1
    fi
    sed -i "s/{{${KEY}}}/${VALUE}/g" ${FILE}
}

if [ -z "${RABBITMQ_PAN_PASSWORD}" ] || [ -z "${RABBITMQ_TARGET_HOST}" ] || \
       [ -z "${RABBITMQ_TARGET_QUEUE}" ]; then
    echo 1>&2 "All of RABBITMQ_PAN_PASSWORD, RABBITMQ_TARGET_HOST, and RABBITMQ_TARGET_QUEUE"
    echo 1>&2 " must be set!"
    # Don't respawn too fast
    exit 2
fi

RMQ="/etc/rabbitmq/rabbitmq.config"
SUP="/etc/supervisord.conf"
set_config RABBITMQ_PAN_PASSWORD ${RABBITMQ_PAN_PASSWORD} ${RMQ}
set_config RABBITMQ_TARGET_HOST ${RABBITMQ_TARGET_HOST} ${RMQ}
set_config RABBITMQ_TARGET_QUEUE ${RABBITMQ_TARGET_QUEUE} ${RMQ}
SUPERVISORD_PASSWORD=$(dd if=/dev/urandom bs=1 count=16 2>/dev/null | \
			   base64 -i - | sed -e 's|/|_|g')
set_config SUPERVISORD_PASSWORD ${SUPERVISORD_PASSWORD} ${SUP}
