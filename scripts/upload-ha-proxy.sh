#!/bin/bash

set -eu

echo "Upload of the HA Proxy OVA has started."
file_path=$(find ./ha-proxy-ova/ -name "*.ova")

echo "$file_path"

export GOVC_TLS_CA_CERTS=/tmp/vcenter-ca.pem
echo "$GOVC_CA_CERT" > "$GOVC_TLS_CA_CERTS"

if [ -z "$VM_FOLDER" ]; then
  if govc vm.info -r ha-proxy-latest-ova | grep -q Name: ; then
    if govc vm.info -r ha-proxy-latest | grep -q Name: ; then
    exit 0
    else
      govc vm.clone -vm ha-proxy-latest-ova -on false ha-proxy-latest
      exit 0
    fi
  else
    echo "The OVA is being imported."
    govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" 
    govc vm.clone -vm ha-proxy-latest-ova -on false ha-proxy-latest
    exit 0
  fi
else
  if [ "$(govc folder.info "$VM_FOLDER" 2>&1 | grep "$VM_FOLDER" | awk '{print $2}')" != "$VM_FOLDER" ]; then
    govc folder.create "$VM_FOLDER"
  fi
  if govc vm.info -r ha-proxy-latest-ova | grep -q Name: ; then
    if govc vm.info -r ha-proxy-latest | grep -q Name: ; then
    exit 0
    else
      govc vm.clone -vm ha-proxy-latest-ova -on false ha-proxy-latest
      exit 0
    fi
  else
    govc import.ova -folder="$VM_FOLDER" -name ha-proxy-latest-ova "$file_path" 
    govc vm.clone -vm ha-proxy-latest-ova -on false ha-proxy-latest
    exit 0
  fi
fi