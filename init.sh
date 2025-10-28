#!/usr/bin/env bash
#
# Initialises a new instance of the backup server.

set -e

cd infra/
tofu apply
VM_IP_ADDRESS=$(tofu output --raw vm_ip_address)

cd ../server/
nixos-anywhere \
  --flake .#server \
  "ubuntu@${VM_IP_ADDRESS}"

ssh "root@${VM_IP_ADDRESS}" git clone https://github.com/hnefatl/backup-server /etc/nixos/

echo "Backup server deployed."
echo "Use \`ssh root@${VM_IP_ADDRESS}\` to connect."
