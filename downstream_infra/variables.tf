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

variable "rancher_hostname" {
  type        = string
  description = "Name for the Rancher host"
}

variable "vm_ssh_key" {
  type        = string
  description = "SSH key to add to the cloud-init for user access"
  sensitive = true
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

variable "kubernetes_version" {
  type        = string
  description = "RKE2 K8s version to be installed" 
}

variable "rancher_access_key" {
  type        = string
  description = "pre-created Rancher access key"
  sensitive   = true
}

variable "rancher_secret_key" {
  type        = string
  description = "pre-created Rancher secret key"
  sensitive   = true 
}

variable "ace_fqdn" {
  type        = string
  description = "Fully Qualified Name for Authorized Cluster Endpoint"
}

variable "ace_enabled" {
  type        = bool
  default     = true
  description = "enable/disable Autorized Cluster Endpoint"
}

#### BGP required Vars ####

variable "asnumber" {
  type        = number
  description = "BGP Autonomous System Number"
}

variable "bgp_peer1_ip" {
  type        = string
  description = "First BGP Peer IP Address" 
}

variable "bgp_peer2_ip" {
  type        = string
  description = "Second BGP Peer IP Address" 
}

variable "cluster_cidr" {
  type        = string
  description = "CIDR that the pods will be provisioned with"
}

variable "service_cidr" {
  type        = string
  description = "CIDR for the Cluster services"
}

variable "block_size" {
  type        = number
  description = "Block size for Calico nodes"
}
