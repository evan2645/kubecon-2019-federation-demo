#!/bin/bash

set -e

echo "Installing prerequisites (wget, netcat)"
echo

apt-get update
apt-get install -y wget netcat

echo
echo "Installing SPIRE"
echo

wget https://github.com/spiffe/spire/releases/download/0.9.0/spire-0.9.0-linux-x86_64-glibc.tar.gz

tar -xvzf ./spire-0.9.0-linux-x86_64-glibc.tar.gz

mv spire /opt/
chown evan:evan /opt/spire/.data

echo
echo "Installing Ghostunnel"
echo

wget https://github.com/square/ghostunnel/releases/download/v1.5.1/ghostunnel-v1.5.1-linux-amd64-with-pkcs11

mkdir /opt/ghostunnel
mv ghostunnel-v1.5.1-linux-amd64-with-pkcs11 /opt/ghostunnel/ghostunnel
chmod +x /opt/ghostunnel/ghostunnel

echo
echo "Done."

