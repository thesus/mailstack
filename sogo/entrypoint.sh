#!/usr/bin/env bash

set -e

chown sogo:sogo -R /var/lib/sogo/

exec /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /dev/stdout
