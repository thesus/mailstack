#!/usr/bin/env bash

set -e

# Well generating diffie-hellman parameters
# TODO: Move data into volume.
openssl dhparam -out /etc/dovecot/dh.pem 2048

id -u vmail &>/dev/null || useradd -U -M -d /var/vmail vmail

/usr/local/bin/dockerize -template /var/tmp/dovecot/conf.d/:/etc/dovecot/conf.d \
    -template /var/tmp/dovecot/dovecot-ldap.conf.ext:/etc/dovecot/dovecot-ldap.conf.ext

# 'Compile' Sieve-Script for (global) Spam learning
sievec /usr/lib/dovecot/sieve/learn-spam.sieve
sievec /usr/lib/dovecot/sieve/learn-ham.sieve
sievec /usr/lib/dovecot/sieve/spam-global.sieve
chmod +x /usr/lib/dovecot/sieve/sa-learn-ham.sh /usr/lib/dovecot/sieve/sa-learn-spam.sh

chown -R vmail /var/vmail
chgrp -R vmail /var/vmail
chmod -R 770 /var/vmail

exec /usr/local/bin/dockerize dovecot -F
