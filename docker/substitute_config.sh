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

set_config RABBITMQ_PAN_PASSWORD ${RABBITMQ_PAN_PASSWORD}
