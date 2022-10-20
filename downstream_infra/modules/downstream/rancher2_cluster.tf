
resource "rancher2_cluster_v2" "downstream" {
  name                                     = var.cluster_name
  kubernetes_version                       = var.kubernetes_version
  enable_network_policy                    = "true"
  default_cluster_role_for_project_members = "user"

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
