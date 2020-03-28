#!/bin/bash

set -eu

file_path=$(find ./tkg-cli/ -name "tkg")
mv "$file_path" ~/tkg
chmod +x tkg

config_path=$(find ./tkg-ci/ -name "config.yml")
tkg init
cat "$config_path" >> ~/.tkg/config.yaml

tkg init --infrastructure=vsphere --plan=prod
