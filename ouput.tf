output "rancher_url" {
  value = "https://${var.rancher_hostname}"
}

output "rke_nodes" {
  value = "${module.nodes.instance_ip_addr}"
}
/*
output "lbfbtemplate" {
  value = "${module.nodes.lbfbtemplate}"
  
}
*/
output "kubeconfig" {
  value = "${module.nodes.kubeconfig}"
}