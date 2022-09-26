variable instance_name {
  description = "A unique identifier for the instance, which cannot be changed after the instance is created. The name must be between 6 and 30 characters in length."
  type        = string
  default     = null
}

variable instance_config {
  description = "The name of the instance's configuration which defines the geographic placement and replication of your databases in this instance. It determines where your data is stored."
  type        = string
}

variable display_name {
  description = "The descriptive name for this instance as it appears in UIs. Must be unique per project and between 4 and 30 characters in length."
  type        = string
}

variable num_nodes {
  description = "The number of nodes allocated to this instance. At most one of either node_count or processing_units can be present in terraform."
  type        = string
  default     = null
}

variable processing_units {
  description = "The number of processing units allocated to this instance. At most one of processing_units or node_count can be present in terraform."
  type        = string
  default     = null
}

variable instance_labels {
  description = "An object containing a list of key: value pairs"
  type        = map(string)
}

variable project_id {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable force_destroy {
  description = "The ID of the project in which the resource belongs."
  type        = bool
  default     = true
}

variable databases {
  type        = any
  description = "The list of the database names, which cannot be changed after creation. Values are of the form [a-z][-a-z0-9]*[a-z0-9]"
  # default     = []
}
