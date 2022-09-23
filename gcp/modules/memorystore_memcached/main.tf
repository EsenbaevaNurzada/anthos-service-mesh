provider "google" {
  region  = var.gcp_region
  project = var.gcp_project_id
}

resource "google_memcache_instance" "memorystore_memcached" {
  depends_on         = [module.enable_apis]
  provider           = google-beta
  project            = var.gcp_project_id
  zones              = var.zones
  name               = var.memcached_name
  region             = var.gcp_region
  authorized_network = var.authorized_network
  node_count         = var.node_count
  display_name       = var.display_name == null ? var.memcached_name : var.display_name
  labels             = var.memcached_labels

  node_config {
    cpu_count      = var.cpu_count
    memory_size_mb = var.memory_size_mb
  }

  dynamic "memcache_parameters" {
    for_each = var.params == null ? [] : [var.params]
    content {
      params = memcache_parameters.value
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? [var.maintenance_policy] : []
    content {
      weekly_maintenance_window {
        day      = maintenance_policy.value["day"]
        duration = maintenance_policy.value["duration"]
        start_time {
          hours   = maintenance_policy.value["start_time"]["hours"]
          minutes = maintenance_policy.value["start_time"]["minutes"]
          seconds = maintenance_policy.value["start_time"]["seconds"]
          nanos   = maintenance_policy.value["start_time"]["nanos"]
        }
      }
    }
  }

}


module "enable_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.0"

  project_id  = var.gcp_project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "memcache.googleapis.com",
  ]
}