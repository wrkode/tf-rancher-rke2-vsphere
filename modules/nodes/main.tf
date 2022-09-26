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
      rancherui     = "${var.rancher_hostname}",
      rke2_token    = "${var.rke2_token}",
      k8s_version   = "${var.kubernetes_version}",
      vm_ssh_user = var.vm_ssh_user,
      vm_ssh_key = var.vm_ssh_key
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}

resource "null_resource" "rke2_primary" {
  depends_on = [
    vsphere_virtual_machine.rke-lb
  ]
  
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.rke-nodes.*.default_ip_address[0]
      user     = var.host_username
      password = var.host_password
    }
    inline = [
      "sed -i 1d /etc/rancher/rke2/config.yaml",
      "systemctl enable rke2-server",
      "systemctl start rke2-server",
      "sleep 20" # Giving time to bootstrap K8s
    ]
    
  }
}

resource "null_resource" "wait_for_rke2_ready" {
    depends_on = [
      null_resource.rke2_primary
    ]
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.rke-nodes.*.default_ip_address[0]
      user     = var.host_username
      password = var.host_password
    }
    inline = [
      "while true; do STATUS=$(/var/lib/rancher/rke2/bin/kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml get nodes |grep rancher-1 | awk '{print $2}'); if [ $STATUS != \"Ready\" ]; then echo \"RKE2 Is Not Ready\"; sleep 5; continue; fi; break; done; echo \"RKE2 is Ready\""
    ]
  }
}
  
  resource "null_resource" "rke2_second" {
  depends_on = [
    null_resource.wait_for_rke2_ready
  ]
  
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.rke-nodes.*.default_ip_address[1]
      user     = var.host_username
      password = var.host_password
    }
    inline = [
      "systemctl enable rke2-server",
      "systemctl start rke2-server"
    ]
    
  }
}


resource "null_resource" "rke2_third" {
  depends_on = [
    null_resource.rke2_second
  ]
  
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.rke-nodes.*.default_ip_address[2]
      user     = var.host_username
      password = var.host_password
    }
    inline = [
      "systemctl enable rke2-server",
      "systemctl start rke2-server",
    ]
    
  }
}
resource "vsphere_virtual_machine" "rke-lb" {
  name             = var.lb_prefix
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder

  num_cpus = var.lb_cpucount
  memory   = var.lb_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  firmware = "efi"

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
      node_ip       = "${var.lb_address}/${var.lb_netmask}"
      node_gateway  = var.vm_gateway,
      node_dns      = var.vm_dns,
      node_hostname = var.lb_prefix
    }))

    "guestinfo.metadata.encoding" = "base64"


    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/userdata_lb.yml.tpl", {
        servers = {
          for node in vsphere_virtual_machine.rke-nodes : node.default_ip_address => node.name
          }
      node_ip       = "${var.lb_address}",
      vm_ssh_user = var.vm_ssh_user,
      vm_ssh_key = var.vm_ssh_key
    }))
    "guestinfo.userdata.encoding" = "base64"

  }
}
