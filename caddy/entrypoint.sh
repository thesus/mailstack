#!/usr/bin/env sh

set -e

export CADDYPATH=/etc/certificates

dockerize -template /etc/Caddyfile.template:/etc/Caddyfile

cat /etc/Caddyfile

exec dockerize caddy --conf /etc/Caddyfile --log stdout --agree=true
