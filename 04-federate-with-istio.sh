#!/bin/bash

set -e

echo "Please paste the CA certificate(s) for the trust domain \"cluster-1\":"
BOOTSTRAP_CERT=$(cat -)

PARENT_ID="spiffe://cluster-2/spire-agent"
SPIFFE_ID="spiffe://cluster-2/my-cool-service"

ENTRY_ID=$(/opt/spire/bin/spire-server entry show | \
        grep -B 1 $SPIFFE_ID | \
        grep Entry | \
        awk '{print $4}')

tmpfile=$(mktemp)
echo "$BOOTSTRAP_CERT" > tmpfile
/opt/spire/bin/spire-server bundle set \
        --id spiffe://cluster-1 \
        --path $tmpfile

/opt/spire/bin/spire-server entry update \
        --entryID $ENTRY_ID \
        --parentID $PARENT_ID \
        --spiffeID $SPIFFE_ID \
        --selector unix:user:evan \
        --federatesWith spiffe://cluster-1
