
locals {
    kube_config = yamldecode(module.nodes.kubeconfig)
}
provider "helm" {
    kubernetes {
        host = local.kube_config.clusters[0].cluster.server
        cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
        client_certificate = base64decode(local.kube_config.users[0].user.client-certificate-data)
        client_key = base64decode(local.kube_config.users[0].user.client-key-data)
    }
}

