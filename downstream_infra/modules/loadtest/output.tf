
output "node_command" {
  value = rancher2_cluster_v2.loadtest.cluster_registration_token[0].node_command
}