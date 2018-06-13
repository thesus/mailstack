#!/usr/bin/env sh

set -e

export CADDYPATH=/etc/certificates

exec dockerize -template /etc/Caddyfile.template:/etc/Caddyfile caddy --conf /etc/Caddyfile --log stdout --agree=true
