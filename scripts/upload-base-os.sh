#!/bin/bash

set -eu

echo "I made it into the script"
file_path=$(find ./base-os-ova/ -name "*.ova")

echo "$file_path"
govc vm.info base-os-latest-ova

export GOVC_TLS_CA_CERTS=/tmp/vcenter-ca.pem
echo "$GOVC_CA_CERT" > "$GOVC_TLS_CA_CERTS"

if [ -z "$VM_FOLDER" ]; then
  if govc | grep -q 'govc: The name 'base-os-latest-ova' already exists.'; then
    govc vm.clone -vm base-os-latest-ova -snapshot $(govc snapshot.tree -vm base-os-latest-ova -C) base-os-latest
  else
    govc import.ova -folder="$VM_FOLDER" -name base-os-latest-ova "$file_path" 
    govc vm.clone -vm base-os-latest-ova -snapshot $(govc snapshot.tree -vm base-os-latest-ova -C) base-os-latest
  fi
else
  if [ "$(govc folder.info "$VM_FOLDER" 2>&1 | grep "$VM_FOLDER" | awk '{print $2}')" != "$VM_FOLDER" ]; then
    govc folder.create "$VM_FOLDER"
  fi
  if govc import.ova -folder "$VM_FOLDER" -name base-os-latest-ova "$file_path" | grep -q 'govc: The name 'base-os-latest-ova' already exists.'; then
    govc vm.clone -vm base-os-latest-ova -snapshot $(govc snapshot.tree -vm base-os-latest-ova -C) base-os-latest
  else
    govc import.ova -folder="$VM_FOLDER" -name base-os-latest-ova "$file_path" 
    govc vm.clone -vm base-os-latest-ova -snapshot $(govc snapshot.tree -vm base-os-latest-ova -C) base-os-latest
  fi
fi