variable "gcp_region" {
  description = "The GCP region to use."
  type        = string
}

variable "gcp_project_id" {
  description = "The ID of the project in which the resource belongs to."
  type        = string
}

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