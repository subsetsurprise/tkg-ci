#!/bin/bash

set -eu

echo "I made it into the script"
file_path=$(find ./base-os-ova/ -name "*.ova")

echo "$file_path"

export GOVC_TLS_CA_CERTS=/tmp/vcenter-ca.pem
echo "$GOVC_CA_CERT" > "$GOVC_TLS_CA_CERTS"

if [ -z "$VM_FOLDER" ]; then
  govc import.ova "$file_path" -folder="$VM_FOLDER" -name=base-os-latest-ova
  govc vm.clone -vm "$file_path" -snapshot $(govc snapshot.tree -vm "$file_path" -C) base-os-latest
else
  if [ "$(govc folder.info "$VM_FOLDER" 2>&1 | grep "$VM_FOLDER" | awk '{print $2}')" != "$VM_FOLDER" ]; then
    govc folder.create "$OM_VM_FOLDER"
  fi
  govc import.ova -folder="$VM_FOLDER" "$file_path" -folder="$VM_FOLDER" -name=base-os-latest-ova
  govc vm.clone -vm "$file_path" -snapshot $(govc snapshot.tree -vm "$file_path" -C) -folder="$VM_FOLDER" base-os-latest
fi