terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.24.1"
    }
  }
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
