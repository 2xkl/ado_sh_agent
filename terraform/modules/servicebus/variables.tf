variable "name" {
  type        = string
  description = "Name of the Service Bus namespace"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "sku" {
  type        = string
  default     = "Standard"
}

variable "topic_name" {
  type        = string
  default     = "default-topic"
}

variable "subscription_name" {
  type        = string
  default     = "default-subscription"
}

variable "tags" {
  type        = map(string)
  default     = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
