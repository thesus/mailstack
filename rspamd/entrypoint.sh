#!/usr/bin/env bash

set -e

exec dockerize -template /var/tmp/rspamd:/etc/rspamd/local.d/ /usr/bin/rspamd -f -u _rspamd -g _rspamd
