
module "downstream" {
  source             = "./modules/downstream"
  cluster_name = "systest"
  vsphere_server     = var.vsphere_server
  vsphere_user       = var.vsphere_user
  vsphere_password   = var.vsphere_password
  vsphere_datacenter = var.vsphere_datacenter
  vsphere_cluster    = var.vsphere_cluster
  vsphere_network    = var.vsphere_network

  vm_folder     = var.vm_folder
  vm_prefix     = "systest"
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
  vm_ssh_key    = var.vm_ssh_key
  vm_ssh_user   = var.vm_ssh_user

  rancher_hostname   = var.rancher_hostname
  kubernetes_version = var.kubernetes_version
  host_username      = var.host_username
  host_password      = var.host_password
  rancher_access_key = var.rancher_access_key
  rancher_secret_key = var.rancher_secret_key
}
