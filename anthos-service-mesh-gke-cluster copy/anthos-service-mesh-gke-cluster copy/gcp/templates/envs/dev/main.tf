terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.90, < 5.0"
    }
     kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.6.1"
    }

    random = {
      source = "hashicorp/random"
    }
    tls = {
      source = "hashicorp/tls"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
}

resource "random_id" "randomId" {
  byte_length = 1
}

provider "google" {
  project = var.gcp_project_id
  credentials = file("cred.json")
}

provider "google-beta" {
  project = var.gcp_project_id
  credentials = file("cred.json")
}

# ######################################
# ########## SERVICE ACCOUNTS ##########
# ######################################
# module "service_account" {
#   source   = "../../../modules/service_account"
#   project  = var.gcp_project_id
#   for_each = { for account in var.service_accounts : account.account_id => account }

#   account_id   = each.value.account_id
#   account_name = each.value.account_name
#   role         = each.value.role
# }

# ######################################
# ############ CLOUD ARMOR #############
# ######################################
# module "cloud_armor" {
#   source           = "../../../modules/cloud_armor"
#   project          = var.gcp_project_id
#   cloud_armor_name = var.cloud_armor_name
#   ip_white_list    = [module.gce-lb-https.external_ip]
#   description      = var.cloud_armor_description
# }

######################################
############ GKE CLUSTER #############
######################################

data "google_project" "project" {
  project_id = var.gcp_project_id
}

module "gke_cluster" {
  source       = "../../../modules/gke_cluster"
  # cluster_name = var.gke_cluster_name
  # network_name = module.vpc.network_name
  # subnet_name  = module.subnets.subnets["${var.subnet_region}/${var.subnet_name}"].name
  project_id   = var.gcp_project_id
  # node_tag     = var.node_tag
  region       = var.gcp_region
  # location     = var.location
  # port_name    = var.port_name
  # node_pools   = var.node_pools

  ####private gke cluster######
  private_cluster_name        = var.private_cluster_name
  private_cluster_description = var.private_cluster_description
  private_cluster_location    = var.private_cluster_location
  # private_cluster_network   = module.vpc.network_name
  private_cluster_network     = "default"
  # private_cluster_subnet    = module.subnets.subnets[0]
  private_cluster_subnet      = "default"
  enable_private_nodes        = var.enable_private_nodes
  enable_private_endpoint     = var.enable_private_endpoint
  master_ipv4_cidr_block      = var.master_ipv4_cidr_block
  cluster_resource_labels     = {"mesh_id" : "proj-${data.google_project.project.number}"}
  private_gke_node_pools      = var.private_gke_node_pools
}


#############REGISTER GKE CLUSTERS TO FLEET########################

module "hub" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
  project_id   = var.gcp_project_id
  location     = module.gke_cluster.private_cluster_location
  cluster_name = module.gke_cluster.private_cluster_name
  depends_on = [module.gke_cluster]
}


# #######################################
# ############ LOAD BALANCER ############
# #######################################
# module "gce-lb-https" {
#   project_id        = var.gcp_project_id
#   source            = "../../../modules/lb_gke"
#   name              = var.lb_name
#   ssl               = var.lb_ssl
#   private_key       = tls_private_key.example.private_key_pem
#   certificate       = tls_self_signed_cert.example.cert_pem
#   firewall_networks = [module.vpc.network_name]
#   # security_policy   = var.security_policy
#   // Make sure when you create the cluster that you provide the `--tags` argument to add the appropriate `target_tags` referenced in the http module.
#   # target_tags = [module.gke_cluster.cluster_name]

#   // Use custom url map.
#   url_map        = google_compute_url_map.my-url-map.self_link
#   create_url_map = var.create_url_map

#   // Get selfLink URLs for the actual instance groups (not the manager) of the existing GKE cluster:
#   //   gcloud compute instance-groups list --uri
#   //
#   // You also must add the named port on the existing GKE clusters instance group that correspond to the `service_port` and `service_port_name` referenced in the module definition.
#   //   gcloud compute instance-groups set-named-ports INSTANCE_GROUP_NAME --named-ports=NAME:PORT
#   // replace `INSTANCE_GROUP_NAME` with the name of your GKE cluster's instance group and `NAME` and `PORT` with the values of `service_port_name` and `service_port` respectively.
#   backends = var.backends
# }

# resource "google_compute_url_map" "my-url-map" {
#   // note that this is the name of the load balancer
#   name            = var.url_map_name
#   default_service = module.gce-lb-https.backend_services["default"].self_link
#   project         = var.gcp_project_id
#   # host_rule {
#   #   hosts        = ["*"]
#   #   path_matcher = "allpaths"
# }

# resource "tls_private_key" "example" {
#   algorithm = var.algorithm
#   rsa_bits  = var.rsa_bits
# }

# resource "tls_self_signed_cert" "example" {
#   # key_algorithm   = tls_private_key.example.algorithm
#   private_key_pem = tls_private_key.example.private_key_pem
#   # Certificate expires after 12 hours.
#   validity_period_hours = var.validity_period_hours
#   # Generate a new certificate if Terraform is run within three
#   # hours of the certificate's expiration time.
#   early_renewal_hours = var.early_renewal_hours
#   # Reasonable set of uses for a server SSL certificate.
#   allowed_uses = var.allowed_uses
#   dns_names    = var.dns_names
#   subject {
#     common_name  = "example.com"
#     organization = "ACME Examples, Inc"
#   }
# }

# ######################################
# ########## MONGO DB ATLAS ############
# ######################################
# provider "mongodbatlas" {
#   public_key  = var.mongo_public_key
#   private_key = var.mongo_private_key
# }

# module "atlas_cluster" {
#   source           = "../../../modules/mongodb_atlas"
#   project_id_mongo = var.mongo_project_id
#   network_name     = module.vpc.network_name

#   # Private link
#   gcp_project                 = var.gcp_project_id
#   gcp_region                  = var.gcp_region
#   subnet_name                 = module.subnets.subnets[var.subnet].name
#   google_compute_address_name = var.google_compute_address_name
#   google_compute_address_type = var.google_compute_address_type
#   google_compute_address      = var.google_compute_address

#   # Atlas cluster
#   cloud_provider               = var.cloud_provider
#   cluster_name                 = var.mongo_cluster_name
#   mongodbversion               = var.mongo_cluster_version
#   cluster_type                 = var.mongo_cluster_type
#   cloud_backup                 = var.cloud_backup
#   auto_scaling_disk_gb_enabled = var.autoscaling
#   provider_instance_size_name  = var.mongo_cluster_size
#   ## replication_specs for the cluster
#   num_shards      = var.num_shards
#   region_name     = var.mongo_cluster_region
#   electable_nodes = var.electable_nodes
#   priority        = var.priority
#   read_only_nodes = var.read_only_nodes

#   # Database user
#   db_username        = var.db_username
#   db_password        = var.db_password
#   auth_database_name = var.auth_database_name
#   ## roles
#   db_role_name  = var.db_role_name
#   database_name = var.database_name
#   ## labels
#   db_key   = var.db_key
#   db_value = var.db_value

#   # IP access list
#   mongodb_cidr_block = module.subnets.subnets[var.subnet].ip_cidr_range
#   # comment    = "GKE cluster ${module.gke_cluster.cluster_name}"
#   comment = "GKE sandbox"
# }



# ######################################
# ############## PUBSUB ################
# ######################################
# module "pubsub" {
#   source             = "../../../modules/pubsub"
#   project_id         = var.gcp_project_id
#   topic              = var.topic
#   topic_labels       = var.topic_labels
#   push_subscriptions = var.push_subscriptions
#   pull_subscriptions = var.pull_subscriptions
#   schema             = var.schema
# }

# ######################################
# ############## SPANNER ###############
# ######################################
# module "spanner" {
#   source          = "../../../modules/spanner"
#   project_id      = var.gcp_project_id
#   display_name    = var.spanner_name
#   instance_config = var.instance_config
#   instance_labels = var.instance_labels
#   databases       = var.databases
# }

# ######################################
# ################ VPC #################
# ######################################
# module "vpc" {
#   source                                 = "../../../modules/vpc/vpc"
#   network_name                           = var.network_name
#   auto_create_subnetworks                = var.auto_create_subnetworks
#   routing_mode                           = var.routing_mode
#   project_id                             = var.gcp_project_id
#   description                            = var.description
#   shared_vpc_host                        = var.shared_vpc_host
#   delete_default_internet_gateway_routes = var.delete_default_igw
#   mtu                                    = var.mtu
# }

# /******************************************
# 	Subnet configuration
#  *****************************************/
# module "subnets" {
#   source           = "../../../modules/vpc/subnets"
#   project_id       = var.gcp_project_id
#   network_name     = module.vpc.network_name
#   subnets          = var.subnets
#   secondary_ranges = var.secondary_ranges
# }

# /******************************************
# 	Routes
#  *****************************************/
# module "routes" {
#   source            = "../../../modules/vpc/routes"
#   project_id        = var.gcp_project_id
#   network_name      = module.vpc.network_name
#   routes            = var.routes
#   module_depends_on = [module.subnets.subnets]
# }

# /******************************************
# 	Firewall rules
#  *****************************************/
# locals {
#   rules = [
#     for f in var.firewall_rules : {
#       name                    = f.name
#       direction               = f.direction
#       priority                = lookup(f, "priority", null)
#       description             = lookup(f, "description", null)
#       ranges                  = lookup(f, "ranges", null)
#       source_tags             = lookup(f, "source_tags", null)
#       source_service_accounts = lookup(f, "source_service_accounts", null)
#       target_tags             = lookup(f, "target_tags", null)
#       target_service_accounts = lookup(f, "target_service_accounts", null)
#       allow                   = lookup(f, "allow", [])
#       deny                    = lookup(f, "deny", [])
#       log_config              = lookup(f, "log_config", null)
#     }
#   ]
# }

# module "firewall_rules" {
#   source       = "../../../modules/vpc/firewall-rules"
#   project_id   = var.gcp_project_id
#   network_name = module.vpc.network_name
#   rules        = local.rules
# }


# ######################################
# ###### Cloud Storage (Bucket) ########
# ######################################

# module "cloud_storage" {
#   source = "../../../modules/cloud_storage"

#   storage_name       = var.storage_name
#   gcp_project_id     = var.gcp_project_id
#   storage_location   = var.storage_location
#   storage_class      = var.storage_class
#   storage_labels     = var.storage_labels
#   force_destroy      = var.force_destroy
#   bucket_policy_only = var.bucket_policy_only

# }

# ######################################
# ###### Memorystore Memcached #########
# ######################################

# module "private-service-access" {
#   source      = "../../../modules/private_service_access"
#   project_id  = var.gcp_project_id
#   vpc_network = module.vpc.network_name
#   depends_on = [
#     module.vpc
#   ]
# }
# module "memorystore_memcached" {
#   source = "../../../modules/memorystore_memcached"

#   memcached_name     = var.memcached_name
#   node_count         = var.node_count
#   gcp_project_id     = var.gcp_project_id
#   gcp_region         = var.gcp_region
#   authorized_network = module.vpc.network_id
# }
