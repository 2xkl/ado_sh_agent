variable "location" {
  description = "Azure region in which resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "servicebus_subscription_id" {
  type = string
}

variable "storage_id" {
  type = string
}

variable "app_name" {
  type = string
}