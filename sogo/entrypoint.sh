#!/usr/bin/env bash

set -e

envsubst < "/etc/sogo/sogo.template.conf" > "/etc/sogo/sogo.conf"

chown sogo:sogo -R /var/lib/sogo/

exec /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /dev/stdout
