
resource "rancher2_cluster_v2" "loadtest" {
  name                  = "loadtest"
  kubernetes_version    = var.kubernetes_version
  enable_network_policy = "true"
  default_cluster_role_for_project_members = "user"

  local_auth_endpoint {
    ca_certs = ""
    enabled  = var.ace_enabled
    fqdn     = var.ace_fqdn
  }

  rke_config {
    machine_selector_config {
      config = {
        cloud-provider-name     = ""
        profile                 = "cis-1.6"
        protect-kernel-defaults = true
      }
    }
  }
}