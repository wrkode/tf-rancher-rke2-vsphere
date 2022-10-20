
output "node_command" {
  value = rancher2_cluster_v2.downstream.cluster_registration_token[0].node_command
}
