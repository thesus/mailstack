FROM debian:buster-slim

RUN apt-get update && apt-get install postfix postfix-ldap gettext rsyslog libsasl2-modules -y

COPY ./files/postfix/ /etc/postfix

RUN ln -s /run/systemd/journal/dev-log /dev/log

RUN chmod -R 644 /etc/postfix/

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
