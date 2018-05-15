FROM debian:buster

RUN apt-get update && apt-get install postfix postfix-ldap gettext rsyslog -y

COPY ./main.cf /etc/postfix/main.cf.template

RUN ln -s /run/systemd/journal/dev-log /dev/log

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
