resource "mongodbatlas_project_ip_access_list" "ip" {
  project_id = var.project_id_mongo
  # ip_address = var.ip_address
  cidr_block = var.mongodb_cidr_block
  comment    = var.comment
}