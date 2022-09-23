output "cluster_name" {
  value = google_container_cluster.gke.name
}

output "network_name" {
  value = var.network_name
}

output "port_name" {
  value = "http"
}

# output "instance_group" {
#   value = google_container_cluster.gke.instance_group_urls[0]
# }

output "node_tag" {
  value = var.node_tag
}

output "cluster" {
  value = google_container_cluster.gke.name
}

output "private_cluster_name" {
  value = "${google_container_cluster.private_cluster.name}"
}

output "private_cluster_location" {
  value = "${google_container_cluster.private_cluster.location}"
}

output "private_cluster_id" {
  value = google_container_cluster.private_cluster.id
}

# output "private_cluster_endpoint" {
#   sensitive   = true
#   description = "Cluster endpoint"
#   value       = local.cluster_endpoint
#   depends_on = [
#     /* Nominally, the endpoint is populated as soon as it is known to Terraform.
#     * However, the cluster may not be in a usable state yet.  Therefore any
#     * resources dependent on the cluster being up will fail to deploy.  With
#     * this explicit dependency, dependent resources can wait for the cluster
#     * to be up.
#     */
#     google_container_cluster.private_cluster,
#     google_container_node_pool.private_cluster_pools,
#   ]
# }