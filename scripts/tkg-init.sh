#!/bin/bash

set -eu

echo "Beginning tkg init script."
file_path=$(find ./tkg-cli/ -name "tkg")
echo "The tkg path is: $file_path"
cp "$file_path" /bin/tkg
chmod +x /bin/tkg
apt install docker-ce docker-ce-cli containerd.io
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
cp kubectl /bin/kubectl
chmod +x /bin/kubectl

config_path=$(find ./tkg-ci/ -name "config.yml")
tkg init || cat "$config_path" >> /root/.tkg/config.yaml
echo "" >> /root/.tkg/config.yaml
echo "VSPHERE_SERVER: $VSPHERE_SERVER" >> /root/.tkg/config.yaml
echo "VSPHERE_USERNAME: $VSPHERE_USERNAME" >> /root/.tkg/config.yaml
echo "VSPHERE_PASSWORD: $VSPHERE_PASSWORD" >> /root/.tkg/config.yaml

cat /root/.tkg/config.yaml

tkg init --infrastructure=vsphere --plan=prod
