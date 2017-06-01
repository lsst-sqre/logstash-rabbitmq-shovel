#!/bin/sh
set -e

/substitute_config.sh
rc=$?
if [ ${rc} -ne 0 ]; then
    echo 1>&2 "Environment substitution failed.  Exiting in 60 seconds."
    sleep 60
    exit ${rc}
fi
exec /usr/bin/supervisord -c /etc/supervisord.conf -n
