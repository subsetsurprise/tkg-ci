#!/bin/bash

set -eu

echo "Upload of the HA Proxy OVA has started."
file_path=$(find ./ha-proxy-ova/ -name "*.ova")

echo "$file_path"

export GOVC_TLS_CA_CERTS=/tmp/vcenter-ca.pem
echo "$GOVC_CA_CERT" > "$GOVC_TLS_CA_CERTS"

if [ -z "$VM_FOLDER" ]; then
  if govc vm.info -r ha-proxy-latest-ova | grep -q Name: ; then
    exit 0
  else
    echo "The OVA is being imported."
    govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" 
  fi
else
  if [ "$(govc folder.info "$VM_FOLDER" 2>&1 | grep "Name:" | awk '{print $2}')" != "$VM_FOLDER" ]; then
    govc folder.create "$VM_FOLDER"
  fi
  if govc vm.info -r ha-proxy-latest-ova | grep -q Name: ; then
    echo "A folder has been created and the OVA is being imported."
    govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path"
    exit 0
  fi
fi