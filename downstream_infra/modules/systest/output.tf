
output "node_command" {
  value = rancher2_cluster_v2.systest.cluster_registration_token[0].node_command
}