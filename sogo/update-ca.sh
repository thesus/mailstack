#!/bin/bash
# See sogo/entrypoint.sh for more details on why this is a separate file.

# Copy custom CA certificates to right place and update them
cp -r /custom-ca-certificates/* /usr/local/share/ca-certificates
update-ca-certificates
