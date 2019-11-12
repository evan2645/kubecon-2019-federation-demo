#!/bin/bash

set -e

# Start SPIRE server
/opt/spire/spire-server run -config ./spire-server.conf &

# Register agent and workload
sleep 1
/opt/spire/spire-server entry create \
        --spiffeID spiffe://cluster2/spire-agent \
        --selector gcp_iit:project-id:kubecon19-demo \
        --selector gcp_iit:instance-name:spire-workload-1 \
        --node

/opt/spire/spire-server entry create \
        --parentID spiffe://cluster2/spire-agent \
        --spiffeID spiffe://cluster2/my-little-service \
        --selector unix:user:evan
