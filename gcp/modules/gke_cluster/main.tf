data "google_client_config" "current" {}

# data "google_container_engine_versions" "default" {
#   location = var.location
# }

data "google_container_engine_versions" "private_cluster" {
  location = var.private_cluster_location
}

# resource "google_container_cluster" "gke" {
#   name                     = var.cluster_name
#   location                 = var.location
#   remove_default_node_pool = true
#   initial_node_count       = 1
#   min_master_version       = data.google_container_engine_versions.default.latest_master_version
#   network                  = var.network_name
#   subnetwork               = var.subnet_name
#   ip_allocation_policy {
#     cluster_ipv4_cidr_block = ""
#     services_ipv4_cidr_block = ""
#   }
#   // Use ABAC until official Kubernetes plugin supports RBAC.
#   enable_legacy_abac = true
# }


#######################################################

# resource "google_container_node_pool" "current" {
#   for_each       = var.node_pools
#   project        = var.project_id
#   cluster        = google_container_cluster.gke.id
#   name           = each.key
#   # version        = google_container_cluster.gke.min_master_version                   
#   location       = google_container_cluster.gke.location
#   node_locations = lookup(each.value, "node_locations", null)
#   initial_node_count = lookup(each.value, "initial_node_count", 1)

#   dynamic "autoscaling" {
#     for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
#     content {
#       min_node_count = lookup(autoscaling.value, "min_count", 1)
#       max_node_count = lookup(autoscaling.value, "max_count", 100)
#     }
#   }

#   upgrade_settings {
#     max_surge       = lookup(each.value, "max_surge", 1)
#     max_unavailable = lookup(each.value, "max_unavailable", 0)
#   }

#    management {
#     auto_repair  = lookup(each.value, "auto_repair", true)
#     auto_upgrade = lookup(each.value, "auto_upgrade", false)
#   }

#   node_config {
#     local_ssd_count  = lookup(each.value, "local_ssd_count", 0)
#     disk_size_gb     = lookup(each.value, "disk_size_gb", 100)
#     disk_type        = lookup(each.value, "disk_type", "pd-standard")
#     min_cpu_platform = lookup(each.value, "min_cpu_platform", "")
#     image_type       = lookup(each.value, "image_type", "COS_CONTAINERD")
#     machine_type     = lookup(each.value, "machine_type", "e2-medium")
#     preemptible      = lookup(each.value, "preemptible", false)
#     # spot             = lookup(each.value, "spot", false)
#     shielded_instance_config {
#       enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
#       enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
#     }
#   }
#     lifecycle {
#       ignore_changes = [initial_node_count]
#    }
# }

# provider "kubernetes" {
#   host                   = google_container_cluster.gke.endpoint
#   token                  = data.google_client_config.current.access_token
#   client_certificate     = base64decode(google_container_cluster.gke.master_auth.0.client_certificate)
#   client_key             = base64decode(google_container_cluster.gke.master_auth.0.client_key)
#   cluster_ca_certificate = base64decode(google_container_cluster.gke.master_auth.0.cluster_ca_certificate)
# }

# provider "kubernetes" {
#   host                   = google_container_cluster.private_cluster.endpoint
#   token                  = data.google_client_config.current.access_token
#   client_certificate     = base64decode(google_container_cluster.private_cluster.master_auth.0.client_certificate)
#   client_key             = base64decode(google_container_cluster.private_cluster.master_auth.0.client_key)
#   cluster_ca_certificate = base64decode(google_container_cluster.private_cluster.master_auth.0.cluster_ca_certificate)
# }



/******************************************
  Create a Private Container Cluster
 *****************************************/

#  locals {
#    cluster_endpoint  = (var.enable_private_nodes && length(google_container_cluster.private_cluster.private_cluster_config) > 0) ? (var.enable_private_endpoint ? google_container_cluster.private_cluster.private_cluster_config.0.private_endpoint : google_container_cluster.private_cluster.private_cluster_config.0.public_endpoint) : google_container_cluster.private_cluster.endpoint
#  }

resource "google_container_cluster" "private_cluster" {
  name              = var.private_cluster_name
  description       = var.private_cluster_description
  project           = var.project_id
  initial_node_count       = 1
  location          = var.private_cluster_location
  network           = var.private_cluster_network
  subnetwork        = var.private_cluster_subnet
  resource_labels   = var.cluster_resource_labels
  remove_default_node_pool = true
  enable_legacy_abac       = true
  min_master_version = data.google_container_engine_versions.private_cluster.latest_master_version

   master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [{
      enable_private_nodes    = var.enable_private_nodes
      enable_private_endpoint = var.enable_private_endpoint
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }] : []

    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block
    }
  }

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
}
}
/******************************************
  Create Container Cluster node pools
 *****************************************/

resource "google_container_node_pool" "private_cluster_pools" {
  for_each           = var.private_gke_node_pools
  name               = each.key
  project            = var.project_id
  location           = google_container_cluster.private_cluster.location
  node_locations     = lookup(each.value, "node_locations", null)
  cluster            = google_container_cluster.private_cluster.id
  node_count         = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)
  max_pods_per_node  = lookup(each.value, "max_pods_per_node", null)
  initial_node_count = lookup(each.value, "initial_node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count", 1)
      max_node_count = lookup(autoscaling.value, "max_count", 100)
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", false)
  }

  upgrade_settings {
    max_surge       = lookup(each.value, "max_surge", 1)
    max_unavailable = lookup(each.value, "max_unavailable", 0)
  }

  node_config {
    image_type       = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type     = lookup(each.value, "machine_type", "e2-medium")
    min_cpu_platform = lookup(each.value, "min_cpu_platform", "")
    local_ssd_count  = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb     = lookup(each.value, "disk_size_gb", 100)
    disk_type        = lookup(each.value, "disk_type", "pd-standard")
    preemptible      = lookup(each.value, "preemptible", false)

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
      enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]

  }
}