#!/bin/sh

exec /usr/bin/curl -s --data-binary @- http://rspamd:11334/learnspam < /dev/stdin
