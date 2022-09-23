# # output "cluster_name" {
# #   value = module.gke_cluster.cluster_name
# # }

# output "load-balancer-ip" {
#   value = module.gce-lb-https.external_ip
# }

# output "subnets_ips" {
#   value       = [for network in module.subnets.subnets : network.ip_cidr_range]
#   description = "The IPs and CIDRs of the subnets being created"
# }

# output "route_names" {
#   value       = [for route in module.routes.routes : route.name]
#   description = "The route names associated with this VPC"
# }

# output "topic_name" {
#   value       = module.pubsub.topic
#   description = "The name of the Pub/Sub topic created"
# }

# output "topic_labels" {
#   value       = module.pubsub.topic_labels
#   description = "The labels of the Pub/Sub topic created"
# }

# # output "private_link" {
# #   value = module.atlas_cluster.private_link
# # }