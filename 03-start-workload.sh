#!/bin/bash

# Start ghostunnel
/opt/ghostunnel/ghostunnel \
        --listen=0.0.0.0:8443 \
        --target=127.0.0.1:8080 \
        --use-workload-api-addr=unix:///opt/spire/spire_api \
        --allow-uri=spiffe://cluster1/ns/foo/sa/sleep

# Start nc
nc -l 8080
