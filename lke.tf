resource "linode_lke_cluster" "module-lke-cluster" {
    # Basic LKE values
    label       = var.name
    k8s_version = var.k8s_version
    region      = var.region
    tags        = var.tags

    # Enable high availability for the control plane
    control_plane {
        high_availability = var.controlplane_ha
    }

    # The pool
    dynamic "pool" {
      for_each = var.pools
      content {
        type  = pool.value["type"]
        count = pool.value["count"]
        dynamic "autoscaler" {
          for_each = pool.value.autoscaling ? [1] : []
          content {
              min = pool.value.scale_min
              max = pool.value.scale_max
          }
        }
      }
    }
}


#### LOCALS
locals {
  instance-id-list = flatten([
    for pool in linode_lke_cluster.module-lke-cluster.pool: [
      for node in pool.nodes:
        node.instance_id
    ]
  ])

}