# Lean on https://github.com/vstakhov/rspamd/blob/master/docker/Dockerfile

FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM debian:stretch-slim

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https gnupg2 ca-certificates dirmngr wget && \
    rm -rf /var/lib/apt/lists/*

RUN set -x && \
    wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add -

RUN echo "deb http://rspamd.com/apt-stable/ stretch main" > /etc/apt/sources.list.d/rspamd.list

RUN apt-get update && \
    apt-get install -y rspamd && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'type = "console";' > /etc/rspamd/override.d/logging.inc && \
    echo 'bind_socket = "*:11334";' > /etc/rspamd/override.d/worker-controller.inc && \
    echo 'pidfile = false;' > /etc/rspamd/override.d/options.inc

RUN mkdir /var/lib/rspamd/dkim/

COPY ./files/rspamd/ /var/tmp/rspamd/

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
