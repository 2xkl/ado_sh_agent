variable "acr_name" {
  type        = string
  description = "The name of the ACR"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which ACR will be created"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "SKU of ACR (Basic, Standard, Premium)"
}

variable "admin_enabled" {
  type        = bool
  default     = false
  description = "Whether admin access is enabled"
}
