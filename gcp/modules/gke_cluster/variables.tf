# variable "cluster_name" {
# }
# variable "network_name" {
# }

# variable "subnet_name" {}

variable "project_id" {}

# variable "node_tag" {
# }

variable "region" {}

# variable "location" {}

# # variable "node_port" {
# #   default = "30000"
# # }

# variable "port_name" {
#   default = "http"
# }
# variable "node_pools" {
#   # type        = list(map(any))
#   description = "List of maps containing node pools"
# }






variable "private_cluster_network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
}

variable "private_cluster_name" {
  type        = string
  description = "The name of the cluster (required)"
}

variable "private_cluster_description" {
  type        = string
  description = "The description of the cluster"
}

variable "private_cluster_subnet" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
}

variable "private_gke_node_pools" {
  # type        = list(map(any))
  description = "List of maps containing node pools"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "(Beta) The IP range in CIDR notation to use for the hosted master network"
  default     = "10.0.0.0/28"
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool."
  default     = 0
}

variable "cluster_resource_labels" {}
variable "private_cluster_location" {}
variable "enable_private_nodes" {}
variable "enable_private_endpoint" {}