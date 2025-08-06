variable "name" {
  description = "Name prefix for the private endpoint and connection"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the private endpoint"
  type        = string
}

variable "resource_id" {
  description = "ID of the Azure resource (e.g., Key Vault, Storage Account)"
  type        = string
}

variable "subresource_names" {
  description = "Subresource names (e.g., ['vault'] for Key Vault, ['blob'] for Storage)"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
