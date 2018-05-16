#!/usr/bin/env bash

set -e

id -u vmail &>/dev/null || useradd -U -M -d /var/vmail vmail

envsubst < "/etc/dovecot/dovecot-ldap.conf.template.ext" > "/etc/dovecot/dovecot-ldap.conf.ext"

chown -R vmail /var/vmail
chgrp -R vmail /var/vmail
chmod -R 770 /var/vmail


exec dovecot -F
