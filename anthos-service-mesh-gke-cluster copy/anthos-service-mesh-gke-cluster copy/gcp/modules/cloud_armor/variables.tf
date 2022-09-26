variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  type        = string
}

variable "cloud_armor_name" {
  description = "Name for the Cloud Armor security policy"
  type        = string
}

variable "ip_white_list" {
  description = "A list of ip addresses that can be white listed through security policies"
}

variable "description" {}