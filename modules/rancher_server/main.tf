resource "helm_release" "cert_manager" {
  repository = "https://charts.jetstack.io"
  name       = "jetstack"
  chart      = "cert-manager"
  version    = var.cert_manager.version
  namespace  = var.cert_manager.ns
  create_namespace = true

  dynamic set {
    for_each = var.cert_manager.chart_set
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

# Install Rancher helm chart
resource "helm_release" "rancher_server" {
  repository = "https://releases.rancher.com/server-charts/${var.rancher_server.branch}"
#  name       = "rancher-${var.rancher_server.branch}"
  name       = "rancher"
  chart      = "rancher"
  version    = var.rancher_server.version
  namespace  = var.rancher_server.ns
  create_namespace = true

  set {
    name  = "hostname"
    value = var.rancher_hostname
  }
  set {
    name = "bootstrapPassword"
    value = var.bootstrapPassword
  }

  set {
    name = "ingress.tls.source"
    value = "rancher"
  }

  set {
    name  = "replicas"
    value = var.rancher_replicas
  }

  dynamic set {
    for_each = var.rancher_server.chart_set
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    helm_release.cert_manager
  ]
}

resource "rancher2_bootstrap" "admin" {
    provider         = rancher2.bootstrap
    initial_password = "${var.bootstrapPassword}"
    password         = "${var.admin_password}"
    telemetry        = true 

    depends_on = [
      helm_release.rancher_server
    ]
}

output "admin_token" {
  value = rancher2_bootstrap.admin.token
}