variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where App Gateway will be deployed"
  type        = string
}

variable "frontend_ip_configuration_type" {
  description = "Type of frontend IP configuration: 'Public' or 'Private'"
  type        = string
  default     = "Public"
}

variable "public_ip_name" {
  description = "Name of Public IP resource (used if frontend IP type is Public)"
  type        = string
  default     = null
}

variable "private_ip_address" {
  description = "Private IP address to assign to App Gateway if frontend IP type is Private"
  type        = string
  default     = null
}

variable "backend_pool_ip_addresses" {
  description = "List of backend IP addresses for backend pool"
  type        = list(string)
  default     = []
}

variable "sku_name" {
  description = "SKU name for Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "Capacity (instance count) for Application Gateway"
  type        = number
  default     = 2
}

variable "routing_rule_priority" {
  description = "Priority of the request routing rule"
  type        = number
  default     = 100
}