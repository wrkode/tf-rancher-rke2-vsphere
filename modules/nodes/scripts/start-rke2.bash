#!/bin/bash

set -eux

sed -i 1d /etc/rancher/rke2/config.yaml
sleep 20
systemctl enable rke2-server
systemctl start rke2-server
# Giving time to bootstrap K8s
