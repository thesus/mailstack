#!/usr/bin/env bash

set -e

# While it is counter-intuitive, no way has been found, yet, to make SOGo run,
# when this container is not started as sogo user. The following approaches have been tryed:
# - Run container as root, start sogod with su as user sogo
# - Run container as root, start sogod with sudo as user sogo
# - Run container as root, start sogod with runuser as user sogo
# - Experiments with setuid, setgid and Posix ACL's seemed to not work because these settings were not included in Docker images.
# All approaches resulted in the same thing: sogod exiting with status code 1, not giving away
# any hint what's wrong. Debugging with gdb showed that the application did not reach its "main" function.
# Pressed to find a working solution, sogo was allowed to password-less sudo this script:
sudo /usr/bin/update-ca.sh

chown sogo:sogo -R /var/lib/sogo/

exec dockerize -template /etc/sogo/sogo.template.conf:/etc/sogo/sogo.conf \
    -wait tcp://dovecot:143 -wait tcp://postfix:587 -wait tcp://postgres:5432 -timeout 30s \
    /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /dev/stdout
