#cloud-config
users:
  - name: ${vm_ssh_user}
    ssh-authorized-keys:
      - ${vm_ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
write_files:
  - path: /root/config.yaml
    content: |
        server: https://lbfb.lab.k8:9345
        write-kubeconfig-mode: 0644
        tls-san:
        - lbfb.lab.k8
        token: supersecretjujitsu
        secrets-encryption: true
        profile: cis-1.6           # CIS 4.2.6, 5.2.1, 5.2.8, 5.2.9, 5.3.2
        cni: calico
  - path: /etc/sysctl.d/90-rke2.conf
    content: |
      net.ipv4.conf.all.forwarding=1
      net.ipv6.conf.all.forwarding=1

runcmd:
   - sudo useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
   - sudo mkdir -p /etc/rancher/rke2
   - sudo mv /root/config.yaml /etc/rancher/rke2/config.yaml
   - sudo systemctl stop firewalld
   - sudo systemctl disable firewalld
   - sudo zypper -n up
   - sudo curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=v1.23.6+rke2r2 sh -
   - sudo cp -f /opt/rke2/share/rke2/rke2-cis-sysctl.conf /etc/sysctl.d/60-rke2-cis.conf
   - sudo systemctl restart systemd-sysctl
   - sudo zypper -n install apparmor-parser
