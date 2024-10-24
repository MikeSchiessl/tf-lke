
output "lke-cluster" {
  value = linode_lke_cluster.module-lke-cluster
}

output "lke-firewall" {
  value = linode_firewall.module-lke-firewall_
}

output "instance-id-list" {
  value = local.instance-id-list
}
