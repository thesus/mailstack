#!/usr/bin/env bash

set -e

envsubst < "/etc/rspamd/local.d/worker-controller.template.inc" > "/etc/rspamd/local.d/worker-controller.inc"

exec /usr/bin/rspamd -f -u _rspamd -g _rspamd
