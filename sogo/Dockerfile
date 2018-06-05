FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM debian:stretch-slim

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install apt-transport-https gnupg2 rsyslog gettext -y

RUN apt-key adv --keyserver keys.gnupg.net --recv-key 0x810273C4

RUN echo "deb https://packages.inverse.ca/SOGo/nightly/4/debian/ stretch stretch" > /etc/apt/sources.list.d/SOGo.list

RUN mkdir /usr/share/doc/sogo/ \
    && touch /usr/share/doc/sogo/empty.sh \
    && apt-get update \
    && apt-get install -y sogo sogo-activesync libwbxml2-0 sope4.9-gdl1-postgresql

RUN echo '* * * * *   sogo   /usr/sbin/sogo-ealarms-notify 2>/dev/null' > /etc/cron.d/sogo \
    && echo '* * * * *   sogo   /usr/sbin/sogo-tool expire-sessions 60' >> /etc/cron.d/sogo \
    && echo '0 0 * * *   sogo   /usr/sbin/sogo-tool update-autoreply -p /etc/sogo/sieve.creds' >> /etc/cron.d/sogo \
    && touch /etc/default/locale

COPY ./files/sogo /etc/sogo
RUN chown -R sogo:sogo /etc/sogo
RUN chown -R sogo:sogo /var/lib/sogo

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chown sogo:sogo /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
