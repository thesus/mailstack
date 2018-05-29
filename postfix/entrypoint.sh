#!/usr/bin/env bash

set -e

cp -f /etc/services /var/spool/postfix/etc/services
cp -f /etc/resolv.conf /var/spool/postfix/etc

cp -a /dev/urandom /var/spool/postfix/dev/
cp -a /dev/random /var/spool/postfix/dev/

envsubst < "/etc/postfix/ldap_virtual_recipients.template.cf" > "/etc/postfix/ldap_virtual_recipients.cf"

postconf -e "myorigin = $POSTFIX_MYORIGIN"
postconf -e "virtual_mailbox_domains = $POSTFIX_VIRTUAL_MAILBOX_DOMAINS"

touch /var/log/mail.log

service rsyslog start

tail -F /var/log/mail.log & exec postfix start-fg
