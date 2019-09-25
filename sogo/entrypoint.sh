#!/usr/bin/env bash

set -e

sudo /usr/bin/update-ca.sh

chown sogo:sogo -R /var/lib/sogo/

exec su sogo -c "dockerize -template /etc/sogo/sogo.template.conf:/etc/sogo/sogo.conf
    -wait tcp://dovecot:143 -wait tcp://postfix:587 -wait tcp://postgres:5432 -timeout 30s
    /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /dev/stdout"
