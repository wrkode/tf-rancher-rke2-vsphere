resource "local_file" "script_kubeconfig" {
  content = templatefile("${path.module}/templates/get_kubeconfig.sh.tpl",{ ssh_pass = var.host_password, ssh_user = var.host_username, vm_ip = vsphere_virtual_machine.rke-nodes.*.default_ip_address[0], rancher_hostname = var.rancher_hostname})
  filename = "${path.module}/get_kubeconfig.sh"
  depends_on = [
    null_resource.wait_for_rke2_ready
  ]
}

data "external" "kubeconfig" {
  program = [
      "sh",
      "${path.module}/get_kubeconfig.sh"
  ]

  depends_on = [
    local_file.script_kubeconfig
  ]
}
