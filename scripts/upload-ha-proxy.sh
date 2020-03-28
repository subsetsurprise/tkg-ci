#!/bin/bash

set -eu

echo "Upload of the HA Proxy OVA has started."
file_path=$(find ./base-os-ova/ -name "*.ova")

echo "$file_path"

export GOVC_TLS_CA_CERTS=/tmp/vcenter-ca.pem
echo "$GOVC_CA_CERT" > "$GOVC_TLS_CA_CERTS"

if [ -z "$VM_FOLDER" ]; then
  if govc vm.info -r ha-proxy-latest-ova | grep -q Name: ; then
    govc vm.clone -vm ha-proxy-latest-ova ha-proxy-latest
    exit 0
  else
    govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" 
    govc vm.clone -vm ha-proxy-latest-ova ha-proxy-latest
    exit 0
  fi
else
  if [ "$(govc folder.info "$VM_FOLDER" 2>&1 | grep "$VM_FOLDER" | awk '{print $2}')" != "$VM_FOLDER" ]; then
    govc folder.create "$VM_FOLDER"
  fi
  if govc import.ova -folder "$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" | grep -q 'govc: The name 'ha-proxy-latest-ova' already exists.'; then
    govc vm.clone -vm ha-proxy-latest-ova ha-proxy-latest
    exit 0
  else
    govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" 
    govc vm.clone -vm ha-proxy-latest-ova ha-proxy-latest
    exit 0
  fi
fi