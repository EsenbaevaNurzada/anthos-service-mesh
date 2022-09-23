variable "project_id" {
  type        = string
  description = "The project ID to manage the Pub/Sub resources."
}

variable "topic" {
  type        = string
  description = "The Pub/Sub topic name."
}

variable "create_topic" {
  type        = bool
  description = "Specify true if you want to create a topic."
  default     = true
}

variable "create_subscriptions" {
  type        = bool
  description = "Specify true if you want to create subscriptions."
  default     = true
}
variable "topic_labels" {
  type        = map(string)
  description = "A map of labels to assign to the Pub/Sub topic."
  default     = {}
}

variable "push_subscriptions" {
  type        = list(map(string))
  description = "The list of the push subscriptions."
  default     = []
}

variable "pull_subscriptions" {
  type        = list(map(string))
  description = "The list of the pull subscriptions."
  default     = []
}

variable "subscription_labels" {
  type        = map(string)
  description = "A map of labels to assign to every Pub/Sub subscription."
  default     = {}
}

variable "topic_message_retention_duration" {
  type        = string
  description = "The minimum duration in seconds to retain a message after it is published to the topic."
  default     = null
}

variable "message_storage_policy" {
  type        = map(any)
  description = "A map of storage policies. Default - inherit from organization's Resource Location Restriction policy."
  default     = {}
}

variable "topic_kms_key_name" {
  type        = string
  description = "The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic."
  default     = null
}

variable "grant_token_creator" {
  type        = bool
  description = "Specify true if you want to add token creator role to the default Pub/Sub SA."
  default     = true
}

variable "schema" {
  type = object({
    name       = string
    type       = string
    definition = string
    encoding   = string
  })
  description = "Schema for the topic."
  default     = null
}

variable "enable_exactly_once_delivery" {
  type        = bool
  description = "Specify true if you want to the message sent to a subscriber is guaranteed not to be resent before the message's acknowledgement deadline expires."
  default     = false
}