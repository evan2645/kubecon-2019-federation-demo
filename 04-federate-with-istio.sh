#!/bin/bash

set -e

SPIFFE_ID="spiffe://cluster2/my-little-service"

ENTRY_ID=$(/opt/spire/spire-server entry show | \
        grep -B 1 $SPIFFE_ID | \
        grep Entry | \
        awk '{print $4}')

/opt/spire/spire-server entry update \
        --entryID $ENTRY_ID \
        --spiffeID $SPIFFE_ID \
        --selector unix:user:evan \
        --federatesWith spiffe://cluster-1
