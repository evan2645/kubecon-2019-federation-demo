#!/bin/bash

# Start simple webserver
cd html
python -m SimpleHTTPServer 8080 &

# Start ghostunnel
/opt/ghostunnel/ghostunnel server \
        --listen=0.0.0.0:8443 \
        --target=127.0.0.1:8080 \
        --use-workload-api-addr=unix:///opt/spire/.data/workload_api \
        --allow-uri=spiffe://cluster-1/ns/foo/sa/sleep
