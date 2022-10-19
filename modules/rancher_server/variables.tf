variable "cert_manager" {
  type = object({
    ns = string
    version = string
    chart_set = list(object({
      name = string
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

variable rancher_hostname {
  type        = string
  description = "Name for the Rancher host"
}

variable "rancher_server" {
  type = object({
    
    ns = string
    version = string
    branch = string
    chart_set = list(object({
      name = string
      value = string
    }))
  })
  default = {
    ns      = "cattle-system"
    version = "v2.6.6"
    branch  = "latest"
    chart_set = [
      {
        name  = "bootstrapPassword"
        value = "T3mP04cc3ss!$"
      }
    ]
  }
  description = "Rancher server helm chart properties. Chart sets can be added using chart_set param"
}

variable "rancher_version" {
  type        = string
  description = "Version of Rancher Server to install"
  default     = "v2.6.8"
}

variable "rancher_chart_options" {
  type = list(object({
      name  = string
      value = string
    }))
  description = "List of options for the Rancher Helm Chart"
  default     = []
}


variable "rancher_replicas" {
  type        = number
  description = "Rancher server replicas to set on deployment"
  default     = 3
}

variable "rancher_k8s" {
  type = object({
    host = string
    client_certificate = string
    client_key = string
    cluster_ca_certificate = string
  })
  description = "K8s cluster client configuration"
}

variable "bootstrapPassword" {
  type        = string
  description = "Rancher Bootstrap Password"
}

variable "admin_password" {
  type        = string
  description = "Rancher Admin User Password"
}
