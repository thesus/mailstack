FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM debian:buster-slim

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

RUN apt-get update && apt-get install dovecot-core dovecot-imapd dovecot-lmtpd \
    dovecot-ldap dovecot-sieve dovecot-managesieved -y

COPY ./files/dovecot/ /etc/dovecot/

# Copy sieve scripts
COPY ./files/sieve/ /usr/lib/dovecot/sieve/

RUN ln -s /run/systemd/journal/dev-log /dev/log

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
