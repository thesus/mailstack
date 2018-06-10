#!/usr/bin/env bash

set -e


if [ ! -f /var/lib/rspamd/dkim/2018.key ]; then
    rspamadm dkim_keygen -b 2018 -s 2018 -k /var/lib/rspamd/dkim/2018.key > /var/lib/rspamd/dkim/2018.txt
    chown -R _rspamd:_rspamd /var/lib/rspamd/dkim
    chmod 440 /var/lib/rspamd/dkim/*

    echo -e "\e[31mGenerated a DKIM signature. Put the following DNS Recod in your zone file.\e[0m"
    cat /var/lib/rspamd/dkim/2018.txt
else
    echo "Found DKIM signature, skipping creation."
fi

exec dockerize -template /var/tmp/rspamd:/etc/rspamd/local.d/ /usr/bin/rspamd -f -u _rspamd -g _rspamd
