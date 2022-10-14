provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}


data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vm_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "rke-nodes" {
  count            = var.vm_count
  name             = "${var.vm_prefix}${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder

  num_cpus = var.vm_cpucount
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  firmware = "efi"
  enable_disk_uuid = true
  scsi_type = "lsilogic"


  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = var.vm_disk_size
    thin_provisioned = false
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

  }

  extra_config = {
    "guestinfo.metadata" = base64encode(templatefile("${path.module}/templates/metadata.yml.tpl", {
      node_ip       = "${var.vm_network}${count.index + var.ip_range}/${var.vm_netmask}",
      node_gateway  = var.vm_gateway,
      node_dns      = var.vm_dns,
      node_hostname = "${var.vm_prefix}${count.index + 1}"
    }))

    "guestinfo.metadata.encoding" = "base64"

    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/userdata.yml.tpl", {
      node_ip       = "${var.vm_network}${count.index + var.ip_range}",
      node_hostname = "${var.vm_prefix}${count.index + 1}.${var.vm_domainname}",
      k8s_version   = "${var.kubernetes_version}",
      vm_ssh_user = var.vm_ssh_user,
      vm_ssh_key = var.vm_ssh_key
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}

###
### ALL node_command are set to insecure_node_command switch to node_command when using valid Rancher Certificates
###
resource "null_resource" "node_command_node1" {

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.rke-nodes.*.default_ip_address[0]
      user     = var.host_username
      password = var.host_password
    }
    inline = [
      "${rancher2_cluster_v2.systest.cluster_registration_token[0].insecure_node_command} --etcd --controlplane --worker"
        ]
  }
}

resource "null_resource" "node_command_node2" {

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.rke-nodes.*.default_ip_address[1]
      user     = var.host_username
      password = var.host_password
    }
    inline = [
      "${rancher2_cluster_v2.systest.cluster_registration_token[0].insecure_node_command} --worker"
        ]
  }
}

resource "null_resource" "node_command_node3" {

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.rke-nodes.*.default_ip_address[2]
      user     = var.host_username
      password = var.host_password
    }
    inline = [
      "${rancher2_cluster_v2.systest.cluster_registration_token[0].insecure_node_command} --worker"
        ]
  }
}


