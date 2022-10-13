terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.24.1"
    }
  }
}
/*
provider "rancher2" {
  api_url    = "https://${var.rancher_hostname}"
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
  insecure = true
}

*/