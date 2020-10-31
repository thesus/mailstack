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

# SOGo does not authenticate itself when sending mail. To avoid
# everything being flagged as spam, we have to build an exception.
# We will build this exception on IPs.
# These IPs are used in in local.d/multimap.conf.
# This is where the IPs have to go
SOGO_IP_MAP_FILE="/var/lib/rspamd/sogo-ips.map"
# The file is on a volume and it might exist and might not exist.
# So we will make sure that it's there...
touch "$SOGO_IP_MAP_FILE"
# ...and empty
truncate --size=0 "$SOGO_IP_MAP_FILE"

# Add SOGo hosts, one per line
SOGO_HOSTS="$(dig +short sogo)"
for SOGO_IP in $SOGO_HOSTS; do
    echo "$SOGO_IP" >> "$SOGO_IP_MAP_FILE"
done

exec dockerize -template /var/tmp/rspamd:/etc/rspamd/local.d/ /usr/bin/rspamd -f -u _rspamd -g _rspamd
