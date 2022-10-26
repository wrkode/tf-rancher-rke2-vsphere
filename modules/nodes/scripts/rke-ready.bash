#!/bin/bash

set -eux

while true; do
  STATUS=$(/var/lib/rancher/rke2/bin/kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml get nodes |grep rancher-1 | awk '{print $2}')
    if [ -z $STATUS ]; then
      echo $STATUS
      echo "RKE2 Is Not Ready"
      sleep 5
      continue
    fi
  break
done

echo "RKE2 is Ready"
