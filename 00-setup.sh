#!/bin/bash

set -e

echo
echo "Installing SPIRE"
echo

curl https://github.com/spiffe/spire/releases/download/0.9.0/spire-0.9.0-linux-x86_64-glibc.tar.gz --output spire-0.9.0.tar.gz

tar -xvzf ./spire-0.9.0.tar.gz

mv spire-0.9.0 /opt/spire
mkdir /opt/spire/.data
chown evan:evan /opt/spire/.data

echo
echo "Installing Ghostunnel"
echo

curl https://github.com/square/ghostunnel/releases/download/v1.5.1/ghostunnel-v1.5.1-linux-amd64-with-pkcs11 --output ghostunnel

mkdir /opt/ghostunnel
mv ghostunnel /opt/ghostunnel/
chmod +x /opt/ghostunnel/ghostunnel

echo
echo "Done."

