provider "rancher2" {
  api_url   = "https://${var.rancher_hostname}"
  bootstrap = true
}

resource "rancher2_bootstrap" "admin" {
    initial_password = "${var.bootstrapPassword}"
    password         =  "${var.admin_password}"
    telemetry        = true 
}

resource "rancher2_cloud_credential" "ccvsphere" {
  name = "ccvsphere"
  description = "VSphere Cloud Credentials 01"

  vsphere_credential_config {
    vcenter = "${var.vsphere_server}"
    username = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
  }
  
}

resource "rancher2_cluster_v2" "systest01" {

  name                  = "systest01"
  kubernetes_version    = "v1.24.4+rke2r1"
  enable_network_policy = "true"
  default_cluster_role_for_project_members = "user"

  rke_config {
    machine_pools {
      name = "cplane_pool"
      cloud_credential_secret_name = rancher2_cloud_credential.ccvsphere.id
      control_plane_role = true
      etcd_role = true
      worker_role = false
      quantity = 3
      machine_config {
        kind = rancher2_machine
      }
    }
    machine_selector_config {
      config = {
        profile = "cis-1.6"
      } 
    }
    machine_global_config = <<EOF
cni: "calico"
cluster-cidr: "172.10.0.0/16"
service-cidr: "172.11.0.0/16"
disable-kube-proxy: false
etcd-expose-metrics: false
EOF
    upgrade_strategy {
      control_plane_concurrency = "10%"
      worker_concurrency        = "10%"
    }
    etcd {
      snapshot_schedule_cron = "0 */5 * * *"
      snapshot_retention     = 5
    }
    chart_values = <<EOF
rke2-calico:
  installation:
    calicoNetwork:
      nodeAddressAutodetectionV4:
        interface: eth0
    EOF
  }
}
