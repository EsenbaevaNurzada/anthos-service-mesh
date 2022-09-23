# output "connection_strings" {
#   value = mongodbatlas_cluster.cluster.connection_strings[0].standard_srv
# }

output "user1" {
  value = mongodbatlas_database_user.user.username
}

output "ipaccesslist" {
  value = mongodbatlas_project_ip_access_list.ip.ip_address
}

# output "private_link" {
#   value = mongodbatlas_privatelink_endpoint.mongoatlas_primary.private_link_id
# }