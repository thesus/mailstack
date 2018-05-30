#!/usr/bin/env bash

set -e

id -u vmail &>/dev/null || useradd -U -M -d /var/vmail vmail

envsubst < "/etc/dovecot/dovecot-ldap.conf.template.ext" > "/etc/dovecot/dovecot-ldap.conf.ext"

chown -R vmail /var/vmail
chgrp -R vmail /var/vmail
chmod -R 770 /var/vmail

sievec /usr/lib/dovecot/sieve/learn-spam.sieve
sievec /usr/lib/dovecot/sieve/learn-ham.sieve
sievec /usr/lib/dovecot/sieve/spam-global.sieve
chmod +x /usr/lib/dovecot/sieve/sa-learn-ham.sh /usr/lib/dovecot/sieve/sa-learn-spam.sh

exec dovecot -F
