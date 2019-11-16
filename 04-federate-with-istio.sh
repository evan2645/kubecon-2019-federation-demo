#!/bin/bash

set -e

BUNDLE_FILE=$(mktemp)
echo "Please paste the CA certificate(s) for the trust domain \"cluster-1\":"
while read line; do
        echo "$line" >> $BUNDLE_FILE
done

PARENT_ID="spiffe://cluster-2/spire-agent"
SPIFFE_ID="spiffe://cluster-2/my-cool-service"

ENTRY_ID=$(/opt/spire/bin/spire-server entry show | \
        grep -B 1 $SPIFFE_ID | \
        grep Entry | \
        awk '{print $4}')

/opt/spire/bin/spire-server bundle set \
        --id spiffe://cluster-1 \
        --path $BUNDLE_FILE

/opt/spire/bin/spire-server entry update \
        --entryID $ENTRY_ID \
        --parentID $PARENT_ID \
        --spiffeID $SPIFFE_ID \
        --selector unix:user:evan \
        --federatesWith spiffe://cluster-1

rm $BUNDLE_FILE
