FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM abiosoft/caddy:no-stats

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

COPY ./Caddyfile.template /etc/Caddyfile.template

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
