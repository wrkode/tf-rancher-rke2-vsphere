#cloud-config
users:
  - name: ${vm_ssh_user}
    ssh-authorized-keys:
      - ${vm_ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
write_files:
  - path: /root/config.yaml
    content: |
        write-kubeconfig-mode: 0644
        secrets-encryption: true
        profile: cis-1.6           # CIS 4.2.6, 5.2.1, 5.2.8, 5.2.9, 5.3.2
        cni: calico
  - path: /etc/sysctl.d/90-rke2.conf
    content: |
      net.ipv4.conf.all.forwarding=1
      net.ipv6.conf.all.forwarding=1
  - path: /etc/sysctl.d/60-rke2-cis.conf
    content: |
      vm.panic_on_oom=0
      vm.overcommit_memory=1
      kernel.panic=10
      kernel.panic_on_oops=1
  - path: /root/bgpconfig.yaml
    content: |
      apiVersion: projectcalico.org/v3
      kind: BGPConfiguration
      metadata:
        name: default
      spec:
        logSeverityScreen: Info
        nodeToNodeMeshEnabled: true
        asNumber: ${asnumber}
  - path: /root/bgp-glb-peer1.yaml
    content: |
      apiVersion: projectcalico.org/v3
      kind: BGPPeer
      metadata:
        name: bgp-glb-peer1
      spec:
        peerIP: ${bgp_peer1_ip}
        asNumber: ${asnumber}
  - path: /root/bgp-glb-peer2.yaml
    content: |
      apiVersion: projectcalico.org/v3
      kind: BGPPeer
      metadata:
        name: bgp-glb-peer2
      spec:
        peerIP: ${bgp_peer2_ip}
        asNumber: ${asnumber}
runcmd:
   - sudo useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
   - sudo sed -i 's/gdp root/gdp root ${vm_ssh_user}/' /etc/ssh/sshd_config
   - sudo mkdir -p /etc/rancher/rke2
   - sudo mkdir -p /var/lib/rancher/rke2/server/manifests
   - sudo mv /root/config.yaml /etc/rancher/rke2/config.yaml
   - sudo mv /root/bgpconfig.yaml /var/lib/rancher/rke2/server/manifests/rke2-bgpconfig.yaml
   - sudo mv /root/bgp-glb-peer1.yaml /var/lib/rancher/rke2/server/manifests/bgp-glb-peer1.yaml
   - sudo mv /root/bgp-glb-peer2.yaml /var/lib/rancher/rke2/server/manifests/bgp-glb-peer2.yaml
   - sudo systemctl stop firewalld
   - sudo systemctl disable firewalld
   - sudo zypper -n up
   - sudo systemctl restart systemd-sysctl
   - sudo zypper -n install apparmor-parser
