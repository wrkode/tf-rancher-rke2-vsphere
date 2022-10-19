terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      configuration_aliases = [ rancher2.bootstrap ]
      version = "1.24.1"
    }
  }
}