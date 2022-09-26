variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  type        = string
}

variable "account_id" {
  type = string
}

variable "account_name" {
  type = string
}

variable "role" {
  type = string
}