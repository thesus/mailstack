FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM alpine:latest

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

RUN apk add --no-cache openldap-clients

COPY ./base.template.ldif /base.template.ldif
COPY ./services.template.ldif /services.template.ldif

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
