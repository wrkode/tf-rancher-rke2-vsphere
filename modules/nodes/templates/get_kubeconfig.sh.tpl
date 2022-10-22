#!/bin/bash
DOCUMENT=$(sshpass -p ${ssh_pass} ssh ${ssh_user}@${vm_ip} -o "UserKnownHostsFile=/dev/null" -o StrictHostKeyChecking=no -- cat /etc/rancher/rke2/rke2.yaml)
jq -n --arg doc "$DOCUMENT" '{"document":$doc}' | sed -e s/127\.0\.0\.1/${rancher_hostname}/g