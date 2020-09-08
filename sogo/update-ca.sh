#!/bin/bash
# See sogo/entrypoint.sh for more details on why this is a separate file.

# Copy custom CA certificates to right place and update them
if stat -t /custom-ca-certificates/* 2>&1; then
    cp -r /custom-ca-certificates/* /usr/local/share/ca-certificates
    update-ca-certificates
fi
