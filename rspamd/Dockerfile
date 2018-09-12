# Lean on https://github.com/vstakhov/rspamd/blob/master/docker/Dockerfile

FROM dev.cryptec.at:5000/infrastructure/dockerize:latest as dockerize

FROM debian:stretch-slim

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https gnupg2 ca-certificates dirmngr && \
    rm -rf /var/lib/apt/lists/*

RUN set -x && \
    key='3FA347D5E599BE4595CA2576FFA232EDBF21E25E' && \
    apt-key adv --keyserver keys.gnupg.net --recv-key "$key" || \
    apt-key adv --keyserver pgp.mit.edu --recv-key "$key" || \
    apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-key "$key" || \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-key "$key"

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
