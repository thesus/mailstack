#!/usr/bin/env bash

set -e

# Copy custom CA certificates to right place and update them
cp -r /custom-ca-certificates/* /usr/local/share/ca-certificates
update-ca-certificates

cp -f /etc/services /var/spool/postfix/etc/services
cp -f /etc/resolv.conf /var/spool/postfix/etc

cp -a /dev/urandom /var/spool/postfix/dev/
cp -a /dev/random /var/spool/postfix/dev/

chmod 755 /etc/postfix

service rsyslog start

postmap /etc/postfix/aliases

exec /usr/local/bin/dockerize -template /var/tmp/postfix/:/etc/postfix/ -wait tcp://dovecot:3569 -wait tcp://dovecot:24 -timeout 30s postfix start-fg
