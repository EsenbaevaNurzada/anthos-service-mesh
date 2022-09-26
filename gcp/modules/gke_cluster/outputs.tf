# output "cluster_name" {
#   value = google_container_cluster.gke.name
# }

# output "network_name" {
#   value = var.network_name
# }

# output "port_name" {
#   value = "http"
# }

# # output "instance_group" {
# #   value = google_container_cluster.gke.instance_group_urls[0]
# # }

# output "node_tag" {
#   value = var.node_tag
# }

# output "cluster" {
#   value = google_container_cluster.gke.name
# }

output "private_cluster_name" {
  value = "${google_container_cluster.private_cluster.name}"
}

output "private_cluster_location" {
  value = "${google_container_cluster.private_cluster.location}"
}

output "private_cluster_id" {
  value = google_container_cluster.private_cluster.id
}