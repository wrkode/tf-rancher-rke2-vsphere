output "instance_ip_addr" {
  value = vsphere_virtual_machine.rke-nodes.*.default_ip_address
}

output "lbfbtemplate" {
  value = templatefile("${path.module}/templates/userdata_lb.yml.tpl", {
        servers = {
          for node in vsphere_virtual_machine.rke-nodes : node.default_ip_address => node.name
        }
      node_ip       = "${var.lb_address}",
      vm_ssh_user = var.vm_ssh_user,
      vm_ssh_key = var.vm_ssh_key
    })
}

output "kubeconfig" {
  value = data.external.kubeconfig.result.document
}