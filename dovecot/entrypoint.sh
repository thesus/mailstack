#!/usr/bin/env bash

set -e

if [ ! -f /usr/lib/dovecot/dhparams/dh.pem ]; then
    echo "File with Diffie Hellman Parameters not found, copying generic one..."
    cp /var/tmp/dovecot/dh.pem /usr/lib/dovecot/dhparams/dh.pem
    cat /usr/lib/dovecot/dhparams/dh.pem
    touch /usr/lib/dovecot/dhparams/generic
fi

if [ -f /usr/lib/dovecot/dhparams/generic ]; then
    echo "Generating own parameter file in the background..."
    /usr/bin/openssl dhparam -out /usr/lib/dovecot/dhparams/dh_full.pem 4096 &> /dev/null && \
    cp /usr/lib/dovecot/dhparams/dh_full.pem /usr/lib/dovecot/dhparams/dh.pem && \
    doveadm reload &&\
    rm /usr/lib/dovecot/dhparams/generic &disown
else
    echo "Diffie Hellman Parameters found. Nothing will be generated."
fi

echo "Starting cron process"
cron

if [ ! -f /var/spool/cron/crontabs/root ]; then
    echo "Installing Crontab for DH Parameters"
    crontab /etc/cron.d/dovecot
fi

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
