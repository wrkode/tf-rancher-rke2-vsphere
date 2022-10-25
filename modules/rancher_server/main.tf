resource "kubernetes_namespace" "cattle-system" {
  metadata {
    name = "cattle-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}
resource "kubernetes_secret" "tls-ca" {
  metadata {
    name      = "tls-ca"
    namespace = kubernetes_namespace.cattle-system.metadata[0].name
  }

  type = "Opaque"

  data = {
    "cacerts.pem" = "${file("${path.root}/certs/cacerts.pem")}"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

resource "kubernetes_secret" "tls-rancher-ingress" {
  metadata {
    name      = "tls-rancher-ingress"
    namespace = kubernetes_namespace.cattle-system.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = "${file("${path.root}/certs/tls.crt")}"
    "tls.key" = "${file("${path.root}/certs/tls.key")}"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

# resource "helm_release" "cert_manager" {
#   repository       = "https://charts.jetstack.io"
#   name             = "jetstack"
#   chart            = "cert-manager"
#   version          = var.cert_manager.version
#   namespace        = var.cert_manager.ns
#   create_namespace = true

#   dynamic "set" {
#     for_each = var.cert_manager.chart_set
#     content {
#       name  = set.value.name
#       value = set.value.value
#     }
#   }
# }

# Install Rancher helm chart
resource "helm_release" "rancher_server" {
  repository = "https://releases.rancher.com/server-charts/${var.rancher_server.branch}"
  #  name       = "rancher-${var.rancher_server.branch}"
  name             = "rancher"
  chart            = "rancher"
  version          = var.rancher_server.version
  namespace        = var.rancher_server.ns
  create_namespace = true

  set {
    name  = "hostname"
    value = var.rancher_hostname
  }
  set {
    name  = "bootstrapPassword"
    value = var.bootstrapPassword
  }

  set {
    name  = "ingress.tls.source"
    value = "secret"
  }

  set {
    name  = "privateCA"
    value = "true"
  }

  set {
    name  = "replicas"
    value = var.rancher_replicas
  }

  dynamic "set" {
    for_each = var.rancher_server.chart_set
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    # helm_release.cert_manager,
    kubernetes_secret.tls-ca,
    kubernetes_secret.tls-rancher-ingress
  ]
}

resource "rancher2_bootstrap" "admin" {
  provider         = rancher2.bootstrap
  initial_password = var.bootstrapPassword
  password         = var.admin_password
  telemetry        = true

  depends_on = [
    helm_release.rancher_server
  ]
}
