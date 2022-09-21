#cloud-config
users:
  - name: ${vm_ssh_user}
    ssh-authorized-keys:
      - ${vm_ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
write_files:
  - path: /etc/sysctl.d/90-rke2.conf
    content: |
      net.ipv4.conf.all.forwarding=1
      net.ipv6.conf.all.forwarding=1
  - path: /root/nginx.conf
    content: |
        load_module lib64/nginx/modules/ngx_stream_module.so;

        worker_processes 4;
        worker_rlimit_nofile 40000;

        events {
            worker_connections 8192;
        }

        stream {
            upstream rancher_servers_http {
                least_conn;
            %{ for s in servers ~}
                server ${s}:80 max_fails=3 fail_timeout=5s;
            %{ endfor ~}
            }
            server {
                listen 80;
                proxy_pass rancher_servers_http;
            }

            upstream rancher_servers_https {
                least_conn;
            %{ for s in servers ~}
                server ${s}:443 max_fails=3 fail_timeout=5s;
            %{ endfor ~}
            }
            server {
                listen     443;
                proxy_pass rancher_servers_https;
            }

            upstream rancher_servers_9345 {
                least_conn;
            %{ for s in servers ~}
                server ${s}:9345 max_fails=3 fail_timeout=5s;
            %{ endfor ~}
            }
            server {
                listen     9345;
                proxy_pass rancher_servers_9345;
            }
        }
runcmd:
   - sudo systemctl stop firewalld
   - sudo systemctl disable firewalld
   - sudo zypper -n update 
   - sudo zypper -n install nginx
   - sudo mv /root/nginx.conf /etc/nginx/nginx.conf
   - sudo systemctl enable nginx
   - sudo systemctl start nginx