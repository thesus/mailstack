#!/usr/bin/env bash

set -e

envsubst < "/etc/postfix/main.cf.template" > "/etc/postfix/main.cf"

postconf -d | grep mail_version

touch /var/log/mail.log

service rsyslog start

tail -f /var/log/mail.log & exec postfix start-fg
