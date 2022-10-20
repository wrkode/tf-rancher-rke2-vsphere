terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.24.1"
    }

  }
}

provider "helm" {
  kubernetes {
    host                   = local.kube_config.clusters[0].cluster.server
    cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
    client_certificate     = base64decode(local.kube_config.users[0].user.client-certificate-data)
    client_key             = base64decode(local.kube_config.users[0].user.client-key-data)
  }
}

provider "kubernetes" {
  host                   = local.kube_config.clusters[0].cluster.server
  cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
  client_certificate     = base64decode(local.kube_config.users[0].user.client-certificate-data)
  client_key             = base64decode(local.kube_config.users[0].user.client-key-data)
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

provider "rancher2" {
  api_url   = "https://${var.rancher_hostname}"
  token_key = module.rancher_server.admin_token
  insecure  = true
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${var.rancher_hostname}"
  bootstrap = true
  insecure  = true
}

# Provider config for admin
provider "rancher2" {
  alias     = "admin"
  api_url   = rancher2_bootstrap.admin.url
  token_key = module.rancher_server.admin_token
  insecure  = true
}
