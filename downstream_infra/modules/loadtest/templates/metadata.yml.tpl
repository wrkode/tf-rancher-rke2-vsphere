network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - ${node_ip}
      gateway4: ${node_gateway}
      nameservers:
        addresses:
          - ${node_dns}
local-hostname: ${node_hostname}
instance-id: ${node_hostname}
