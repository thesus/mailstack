FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM debian:buster-slim

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https gnupg2 rsyslog ca-certificates dirmngr sudo && \
    rm -rf /var/lib/apt/lists/*

RUN set -x && \
    key='0x810273C4' && \
    apt-key adv --keyserver keys.gnupg.net --recv-key "$key" || \
    apt-key adv --keyserver pgp.mit.edu --recv-key "$key" || \
    apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-key "$key" || \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-key "$key"

RUN echo "deb https://packages.inverse.ca/SOGo/nightly/5/debian/ buster buster" > /etc/apt/sources.list.d/SOGo.list

# To see why we need sudo for this, see sogo/entrypoint.sh
RUN echo "sogo            ALL = (ALL) NOPASSWD: /usr/bin/update-ca.sh" >> /etc/sudoers
COPY ./update-ca.sh /usr/bin/update-ca.sh

RUN mkdir /usr/share/doc/sogo/ && \
    touch /usr/share/doc/sogo/empty.sh && \
    apt-get update && \
    apt-get install -y sogo sogo-activesync libwbxml2-0 sope4.9-gdl1-postgresql && \
    rm -rf /var/lib/apt/lists/*

RUN echo '* * * * *   sogo   /usr/sbin/sogo-ealarms-notify 2>/dev/null' > /etc/cron.d/sogo && \
    echo '* * * * *   sogo   /usr/sbin/sogo-tool expire-sessions 60' >> /etc/cron.d/sogo && \
    echo '0 0 * * *   sogo   /usr/sbin/sogo-tool update-autoreply -p /etc/sogo/sieve.creds' >> /etc/cron.d/sogo && \
    touch /etc/default/locale

COPY ./files/sogo /etc/sogo
RUN chown -R sogo:sogo /etc/sogo
RUN chown -R sogo:sogo /var/lib/sogo

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chown sogo:sogo /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
