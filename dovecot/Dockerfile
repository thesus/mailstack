FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM debian:buster-slim

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

RUN apt-get update && apt-get install dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd \
    dovecot-ldap dovecot-sieve dovecot-managesieved cron curl -y

RUN mkdir /var/tmp/dovecot

# Create "default" Diffie Hellman parameters
RUN openssl dhparam -out /var/tmp/dovecot/dh.pem 2048

# Setup crontab for DH-Parameters
RUN echo '0 0 1 * *   root   openssl dhparam -out /usr/lib/dovecot/dhparams/dh.pem 4096' > /etc/cron.d/dovecot

# Copy dovecot configuration files
COPY ./files/dovecot/ /var/tmp/dovecot/

# Copy sieve scripts
COPY ./files/sieve/ /usr/lib/dovecot/sieve/

# Setup logging
RUN ln -s /run/systemd/journal/dev-log /dev/log

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
