output "rancher_url" {
  value = "https://${var.rancher_hostname}"
}

output "rke_nodes" {
  value = module.nodes.instance_ip_addr
}

output "lbfbtemplate" {
  value     = module.nodes.lbfbtemplate
  sensitive = true

}

output "kubeconfig" {
  value = module.nodes.kubeconfig
}

output "rancher-bootstrap-password" {
  value = random_string.bootstrap-password.result
}

output "rancher-admin-password" {
  value = random_string.admin-password.result
}
