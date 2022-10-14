output "rancher_url" {
  value = "https://${var.rancher_hostname}"
}

output "rke_nodes" {
  value = "${module.nodes.instance_ip_addr}"
}

output "kubeconfig" {
  value = "${module.nodes.kubeconfig}"
}