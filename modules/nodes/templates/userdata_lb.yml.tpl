#cloud-config
users:
  - name: ${vm_ssh_user}
    ssh-authorized-keys:
      - ${vm_ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
write_files:
  - path: /root/haproxy.cfg
    content: |
      global
        log /dev/log daemon
        maxconn 32768
        chroot /var/lib/haproxy
        user haproxy
        group haproxy
        daemon
        stats socket /var/lib/haproxy/stats user haproxy group haproxy mode 0640 level operator
        tune.bufsize 32768
        tune.ssl.default-dh-param 2048
        ssl-default-bind-ciphers ALL:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH
      defaults
        log     global
        mode    http
        option  log-health-checks
        option  log-separate-errors
        option  dontlog-normal
        option  dontlognull
        option  httplog
        option  socket-stats
        retries 3
        option  redispatch
        maxconn 10000
        timeout connect     5s
        timeout client     50s
        timeout server    450s

      listen stats
        bind 0.0.0.0:8080
        bind :::80 v6only
        stats enable
        stats uri     /
        stats refresh 5s

      frontend rancher
        bind ${node_ip}:443
        mode tcp
        option tcp-check
        use_backend be-rancher
        
      frontend rke2-6443
        bind ${node_ip}:6443
        mode tcp
        use_backend be-rke2-6443
      
      frontend rke2-9345
        bind ${node_ip}:9345
        mode tcp
        use_backend be-rke2-9345
      
      backend be-rancher
        balance roundrobin
        mode tcp
        option tcp-check
%{ for s, srv_name in servers }
        server ${srv_name} ${s}:443 check
%{ endfor ~}

      backend be-rke2-6443
        balance roundrobin
        mode tcp
        option tcp-check
%{ for s, srv_name in servers }
        server ${srv_name} ${s}:6443 check
%{ endfor ~}

      backend be-rke2-9345
        balance roundrobin
        mode tcp
        option tcp-check
%{ for s, srv_name in servers }
        server ${srv_name} ${s}:9345 check
%{ endfor ~}

runcmd:
   - sudo systemctl stop firewalld
   - sudo systemctl disable firewalld
   - sudo zypper -n update 
   - sudo zypper -n install haproxy
   - sudo mv /root/haproxy.cfg /etc/haproxy/haproxy.cfg
   - sudo systemctl enable haproxy
   - sudo systemctl start haproxy