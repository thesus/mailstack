FROM debian:buster-slim

RUN apt-get update && apt-get install dovecot-core dovecot-imapd dovecot-lmtpd \
    dovecot-ldap dovecot-sieve dovecot-managesieved gettext -y

COPY ./files/dovecot/ /etc/dovecot/

RUN ln -s /run/systemd/journal/dev-log /dev/log

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
