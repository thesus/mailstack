#!/usr/bin/env sh

set -e

exec dockerize -template /etc/Caddyfile.template:/etc/Caddyfile caddy --conf /etc/Caddyfile --log stdout --agree=true
