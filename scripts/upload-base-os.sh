#!/bin/bash

set -eu

file_path=$(find ./base-os-ova/ -name "*.ova")
uuid=$(uuidgen)
name="base-os-" + "$uuid"

echo "$name"
echo "$file_path"

export GOVC_TLS_CA_CERTS=/tmp/vcenter-ca.pem
echo "$GOVC_CA_CERT" > "$GOVC_TLS_CA_CERTS"

if [ -z "$OM_VM_FOLDER" ]; then
  govc import.ova "$file_path"
  govc vm.clone -vm "$name" -snapshot $(govc snapshot.tree -vm "$name" -C) base-os-latest
else
  if [ "$(govc folder.info "$OM_VM_FOLDER" 2>&1 | grep "$OM_VM_FOLDER" | awk '{print $2}')" != "$OM_VM_FOLDER" ]; then
    govc folder.create "$OM_VM_FOLDER"
  fi
  govc import.ova -folder="$OM_VM_FOLDER" "$file_path"
  govc vm.clone -vm "$name" -snapshot $(govc snapshot.tree -vm "$name" -C) base-os-latest
fi