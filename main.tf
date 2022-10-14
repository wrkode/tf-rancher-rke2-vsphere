locals {
  kube_config = yamldecode(module.nodes.kubeconfig)
}

module "nodes" {
  source             = "./modules/nodes"
  vsphere_server     = var.vsphere_server
  vsphere_user       = var.vsphere_user
  vsphere_password   = var.vsphere_password
  vsphere_datacenter = var.vsphere_datacenter
  vsphere_cluster    = var.vsphere_cluster
  vsphere_network    = var.vsphere_network

  vm_prefix     = var.vm_prefix
  vm_count      = var.vm_count
  vm_datastore  = var.vm_datastore
  vm_cpucount   = var.vm_cpucount
  vm_memory     = var.vm_memory
  vm_domainname = var.vm_domainname
  vm_network    = var.vm_network
  vm_netmask    = var.vm_netmask
  vm_gateway    = var.vm_gateway
  vm_dns        = var.vm_dns
  vm_template   = var.vm_template
  vm_disk_size  = var.vm_disk_size
  ip_range      = var.ip_range



  lb_address    = var.lb_address
  lb_prefix     = var.lb_prefix
  lb_datastore  = var.lb_datastore
  lb_cpucount   = var.lb_cpucount
  lb_memory     = var.lb_memory
  lb_domainname = var.lb_domainname
  lb_netmask    = var.lb_netmask
  lb_gateway    = var.lb_gateway
  lb_dns        = var.lb_dns

  vm_ssh_key  = var.vm_ssh_key
  vm_ssh_user = var.vm_ssh_user

  rancher_hostname = var.rancher_hostname
  rke2_token       = var.rke2_token
  host_username    = var.host_username
  host_password    = var.host_password
}

resource "random_string" "bootstrap-password" {
  length = 32
}

module "rancher_server" {
  source = "./modules/rancher_server"
  rancher_k8s = {
    host                   = local.kube_config.clusters[0].cluster.server
    cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
    client_certificate     = base64decode(local.kube_config.users[0].user.client-certificate-data)
    client_key             = base64decode(local.kube_config.users[0].user.client-key-data)
  }
  rancher_server = {
    ns        = "cattle-system"
    version   = var.rancher_version
    branch    = "latest"
    chart_set = []
  }
  rancher_hostname  = var.rancher_hostname
  rancher_version   = var.rancher_version
  bootstrapPassword = random_string.bootstrap-password.result

  depends_on = [module.nodes]
}

/*
resource "null_resource" "wait_for_rancher" {
  provisioner "local-exec" {
    command = <<EOF
      while true; do curl -kv https://"${var.rancher_hostname}" 2>&1 | grep -q "dynamiclistener-ca"; if [ $? != 0 ]; then echo "Rancher URL isn't ready yet"; sleep 5; continue; fi; break; done; echo "Rancher URL is Ready";
              EOF
  }

  depends_on = [module.rancher]
}
*/