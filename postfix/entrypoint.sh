#!/usr/bin/env bash

set -e

cp -f /etc/services /var/spool/postfix/etc/services
cp -f /etc/resolv.conf /var/spool/postfix/etc

cp -a /dev/urandom /var/spool/postfix/dev/
cp -a /dev/random /var/spool/postfix/dev/

chmod 755 /etc/postfix

touch /var/log/mail.log
service rsyslog restart

/usr/local/bin/dockerize -template /var/tmp/postfix/:/etc/postfix/ -wait tcp://dovecot:3569 -wait tcp://dovecot:24 -timeout 30s -stdout /var/log/mail.log postfix start-fg
