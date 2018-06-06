FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM debian:buster-slim

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

RUN apt-get update && apt-get install postfix postfix-ldap rsyslog libsasl2-modules -y

RUN ln -s /run/systemd/journal/dev-log /dev/log

RUN mkdir /var/tmp/postfix
COPY ./files/postfix/ /var/tmp/postfix/
RUN chmod -R 644 /etc/postfix/

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
