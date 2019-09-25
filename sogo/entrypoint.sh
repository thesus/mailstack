#!/usr/bin/env bash

set -e

# Copy custom CA certificates to right place and update them
cp -r /custom-ca-certificates /usr/local/share/ca-certificates
update-ca-certificates

chown sogo:sogo -R /var/lib/sogo/

exec dockerize -template /etc/sogo/sogo.template.conf:/etc/sogo/sogo.conf \
    -wait tcp://dovecot:143 -wait tcp://postfix:587 -wait tcp://postgres:5432 -timeout 30s \
    /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /dev/stdout
