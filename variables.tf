variable "admin_password" {
  
}

variable "bootstrapPassword" {
  
}

variable "vsphere_server" {
  type        = string
  description = "FQDN or IP address of vCenter instance"
}

variable "vsphere_user" {
  type        = string
  description = "Username for the vCenter instance"
}

variable "vsphere_password" {
  type        = string
  description = "Password for the vCenter instance"
  sensitive   = true
}

variable "vsphere_datacenter" {
  type        = string
  description = "Name of the vCenter Datacenter object"
}

variable "vsphere_cluster" {
  type        = string
  description = "Name of the vCenter Cluster object"
}

variable "vsphere_network" {
  type        = string
  description = "Name of the vDS/vSS Port Group to attach to the VM's"
}

variable "vm_folder" {
  type        = string
  description = "DC Folder for Virtual Machines"
}

variable "vm_prefix" {
  type        = string
  description = "Name prefix for VM's. A numerical value will be appended"
}

variable "vm_disk_size" {
  type        = number
  description = "disk size"
}

variable "vm_count" {
  type        = number
  description = "Number of RKE instances to create"
}

variable "vm_datastore" {
  type        = string
  description = "Name of the vCenter datastore object"
}

variable "vm_cpucount" {
  type        = number
  description = "Number of vCPU's to assign to the VM's"
}

variable "vm_memory" {
  type        = number
  description = "Amount of memory (in MB) to assign to the VM's"
}

variable "vm_domainname" {
  type        = string
  description = "Domain name suffix for the VM"
}

variable "vm_network" {
  type        = string
  description = "CIDR network to use with appended . IE - 172.16.10."
}

variable "vm_netmask" {
  type        = string
  description = "Subnet Mask length for VM's"
}

variable "vm_gateway" {
  type        = string
  description = "Gateway address for VM"
}

variable "vm_dns" {
  type        = string
  description = "IP address of DNS server"
}

variable "vm_template" {
  type        = string
  description = "Name of VM template to use"
}

variable "lb_address" {
  type        = string
  description = "IP address for the NGINX loadbalancer"
}

variable "lb_prefix" {
  type        = string
  description = "Name prefix for the Loadbalancer"
}

variable "lb_datastore" {
  type        = string
  description = "Datastore object to store the Loadbalancer VM"
}

variable "lb_cpucount" {
  type        = number
  description = "Number of CPU's to assign to the Loadbalancer VM"
}

variable "lb_memory" {
  type        = number
  description = "Amount of RAM in MB to assign to the Loadbalancer VM"
}

variable "lb_domainname" {
  type        = string
  description = "Domain name suffix for the VM"
}

variable "lb_netmask" {
  type        = string
  description = "Subnet mask for the Loadbalancer VM"
}

variable "lb_gateway" {
  type        = string
  description = "Gateway for the Loadbalancer VM"
}

variable "lb_dns" {
  type        = string
  description = "DNS Server for the Loadbalancer VM"
}

variable "cert_manager" {
  type = object({
    ns      = string
    version = string
    chart_set = list(object({
      name  = string
      value = string
    }))
  })
  default = {
    ns      = "cert-manager"
    version = "v1.7.1"
    chart_set = [
      {
        name  = "installCRDs"
        value = "true"
      }
    ]
  }
  description = "Cert-manager helm chart properties. Chart sets can be added using chart_set param"
}

variable "rancher_hostname" {
  type        = string
  description = "Name for the Rancher host"
}

variable "rke2_token" {
  type        = string
  description = "RKE2 registration token"
  sensitive   = true

}
variable "vm_ssh_key" {
  type        = string
  description = "SSH key to add to the cloud-init for user access"
  sensitive   = true
}

variable "vm_ssh_user" {
  type        = string
  description = "Username for ssh access"
}

variable "host_username" {
  type        = string
  description = "root user"
}

variable "host_password" {
  type        = string
  description = "root user password"
  sensitive   = true
}
variable "ip_range" {
  type        = number
  description = "starting octet"

}

# Rancher version to be deployed
variable "rancher_version" {
  type        = string
  description = "Version of Rancher Server to install"
  default     = "v2.6.6"
}

variable "kubernetes_version" {
  type        = string
  description = "RKE2 K8s version to be installed"

}

variable "rancher_chart_options" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of options for the Rancher Helm Chart"
  default     = []
}
