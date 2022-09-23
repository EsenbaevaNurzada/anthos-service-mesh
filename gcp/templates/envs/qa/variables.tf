######################################
########## SERVICE ACCOUNTS ##########
######################################
variable "service_accounts" {
  type = list(object({
    account_id   = string,
    account_name = string,
    role         = string
  }))
}

######################################
############ CLOUD ARMOR #############
######################################
variable "cloud_armor_name" {
  type        = string
  description = ""
}
variable "cloud_armor_description" {
  type        = string
  description = ""
}

######################################
############ GKE CLUSTER #############
######################################
variable "gke_cluster_name" {
  type        = string
  description = ""
}
variable "node_tag" {
  type        = string
  description = ""
}
variable "location" {
  type        = string
  description = ""
}
variable "port_name" {
  type        = string
  description = ""
}
variable "node_pools" {
  description = "List of maps containing node pools"
}
variable "subnet_name" {}
variable "subnet_region" {}

######################################
########### LOAD BALANCER ############
######################################
variable "lb_name" {
  type        = string
  description = ""
}
variable "backends" {

}
variable "lb_ssl" {
  type = bool
}
variable "create_url_map" {
  type        = string
  description = ""
}
variable "url_map_name" {
  type        = string
  description = ""
}
variable "algorithm" {
  type = string
}
variable "rsa_bits" {
  type        = number
  description = ""
}
variable "validity_period_hours" {
  type        = number
  description = ""
}
variable "early_renewal_hours" {
  type        = number
  description = ""
}
variable "allowed_uses" {
  type        = list(any)
  description = ""
}
variable "dns_names" {
  type        = list(any)
  description = ""
}
variable "subject" {
  type        = map(any)
  description = ""
}

######################################
########## MONGO DB ATLAS ############
######################################
variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
}
variable "mongo_project_id" {
  type        = string
  description = "Mongo Atlas Project ID "
}
variable "mongo_public_key" {
  type        = string
  description = ""
}
variable "mongo_private_key" {
  type        = string
  description = ""
}
variable "gcp_region" {
  type        = string
  description = ""
}
variable "cloud_provider" {
  type        = string
  description = ""
}
variable "google_compute_address_name" {
  type        = string
  description = ""
}
variable "google_compute_address_type" {
  type        = string
  description = ""
}
variable "google_compute_address" {
  type        = string
  description = ""
}
variable "mongo_cluster_name" {
  type        = string
  description = ""
}
variable "mongo_cluster_version" {
  type        = string
  description = ""
}
variable "mongo_cluster_type" {
  type        = string
  description = ""
}
variable "cloud_backup" {
  type        = bool
  description = ""
}
variable "autoscaling" {
  type        = bool
  description = ""
}
variable "mongo_cluster_size" {
  type        = string
  description = ""
}
variable "num_shards" {
  type        = number
  description = ""
}
variable "mongo_cluster_region" {
  type        = string
  description = ""
}
variable "electable_nodes" {
  type        = number
  description = ""
}
variable "priority" {
  type        = number
  description = ""
}
variable "read_only_nodes" {
  type        = number
  description = ""
}
variable "subnet" {
  type        = string
  description = ""
}
# Database user
variable "db_username" {
  type        = string
  description = ""
}
variable "db_password" {
  type        = string
  description = ""
}
variable "auth_database_name" {
  type        = string
  description = ""
}
variable "db_role_name" {
  type        = string
  description = ""
}
variable "database_name" {
  type        = string
  description = ""
}
variable "db_key" {}
variable "db_value" {}

######################################
############## PUBSUB ################
######################################
variable "topic" {
  type        = string
  description = "The Pub/Sub topic name."
}
variable "topic_labels" {
  type        = map(any)
  description = ""
}
variable "push_subscriptions" {
  description = "The list of the push subscriptions."
  default     = []
}
variable "pull_subscriptions" {
  description = "The list of the pull subscriptions."
  default     = []
}
variable "schema" {
  type = object({
    name       = string
    type       = string
    definition = string
    encoding   = string
  })
  description = "Schema for the topic."
}

######################################
############## SPANNER ###############
######################################
variable "instance_config" {
  type        = string
  description = ""
}
variable "instance_labels" {
  type        = map(any)
  description = ""
}
variable "spanner_name" {
  type        = string
  description = ""
}
variable "databases" {}

######################################
################ VPC #################
######################################
variable "network_name" {
  type        = string
  description = "The name of the network being created"
}
variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
}
variable "routing_mode" {
  type        = string
  description = "The network routing mode (default 'GLOBAL')"
}
variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
}
variable "delete_default_igw" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
}
variable "mtu" {
  type        = number
  description = "The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively."
}
variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
}

######################################
################Subnet################
######################################

variable "subnets" {
  description = "The list of subnets being created"
}
variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}
######################################
################ROUTES################
######################################
variable "firewall_rules" {
  type        = any
  description = "List of firewall rules"
  default     = []
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC"
  default     = []
}


######################################
#########  Cloud Storage  ############
######################################
variable "storage_location" {
  description = "The location of the bucket."
  type        = string
}
variable "storage_name" {
  description = "The name of the bucket."
  type        = string
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = null
}

variable "storage_labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  type        = map(string)
  default     = null
}

variable "bucket_policy_only" {
  description = "Enables Bucket Policy Only access to a bucket."
  type        = bool
  default     = false
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = false
}

variable "iam_members" {
  description = "The list of IAM members to grant permissions on the bucket."
  type = list(object({
    role   = string
    member = string
  }))
  default = []
}

variable "retention_policy" {
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type = object({
    is_locked        = bool
    retention_period = number
  })
  default = null
}

variable "encryption" {
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type = list(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = any

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    condition = any
  }))
  default = []
}

######################################
######  Memorystore Memcached  #######
######################################

variable "enable_apis" {
  description = "Flag for enabling memcache.googleapis.com in your project"
  type        = bool
  default     = true
}

variable "memcached_name" {
  description = "The ID of the instance or a fully qualified identifier for the instance."
  type        = string
}

variable "authorized_network" {
  description = "The full name of the Google Compute Engine network to which the instance is connected. If left unspecified, the default network will be used."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of nodes in the memcache instance."
  type        = number
  default     = 1
}

variable "cpu_count" {
  description = "Number of CPUs per node"
  type        = number
  default     = 1
}

variable "memory_size_mb" {
  description = "Memcache memory size in MiB. Defaulted to 1024"
  type        = number
  default     = 1024
}

variable "zones" {
  description = "Zones where memcache nodes should be provisioned. If not provided, all zones will be used."
  type        = list(string)
  default     = null
}

variable "display_name" {
  description = "An arbitrary and optional user-provided name for the instance."
  type        = string
  default     = null
}

variable "reserved_ip_range" {
  description = "The CIDR range of internal addresses that are reserved for this instance."
  type        = string
  default     = null
}

variable "memcached_labels" {
  description = "The resource labels to represent user provided metadata."
  type        = map(string)
  default     = {}
}

variable "params" {
  description = "Parameters for the memcache process"
  type        = map(string)
  default     = null
}

variable "maintenance_policy" {
  description = "The maintenance policy for an instance."
  # type = object(any)
  type = object({
    day      = string
    duration = number
    start_time = object({
      hours   = number
      minutes = number
      seconds = number
      nanos   = number
    })
  })
  default = null
}