#!/bin/bash

set -eu

file_path=$(find ./ha-proxy-ova/ -name "*.ova")

echo "$file_path"

export GOVC_TLS_CA_CERTS=/tmp/vcenter-ca.pem
echo "$GOVC_CA_CERT" > "$GOVC_TLS_CA_CERTS"

if [ -z "$VM_FOLDER" ]; then
  if govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" | grep -q 'govc: The name 'base-os-latest-ova' already exists.'; then
    govc vm.clone -vm ha-proxy-latest-ova -snapshot $(govc snapshot.tree -vm ha-proxy-latest-ova -C) -folder="$VM_FOLDER" ha-proxy-latest
  else
    govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" 
    govc vm.clone -vm ha-proxy-latest-ova -snapshot $(govc snapshot.tree -vm ha-proxy-latest-ova -C) -folder="$VM_FOLDER" ha-proxy-latest
  fi
else
  if [ "$(govc folder.info "$VM_FOLDER" 2>&1 | grep "$VM_FOLDER" | awk '{print $2}')" != "$VM_FOLDER" ]; then
    govc folder.create "$VM_FOLDER"
  fi
  if govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" | grep -q 'govc: The name 'base-os-latest-ova' already exists.'; then
    govc vm.clone -vm ha-proxy-latest-ova -snapshot $(govc snapshot.tree -vm ha-proxy-latest-ova -C) -folder="$VM_FOLDER" ha-proxy-latest
  else
    govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" 
    govc vm.clone -vm ha-proxy-latest-ova -snapshot $(govc snapshot.tree -vm ha-proxy-latest-ova -C) -folder="$VM_FOLDER" ha-proxy-latest
  fi
fi