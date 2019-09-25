#!/bin/bash
# Copy custom CA certificates to right place and update them
cp -r /custom-ca-certificates/* /usr/local/share/ca-certificates
update-ca-certificates
