variable "app_gateway_name" {
  type        = string
  description = "The name of the Application Gateway"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "frontend_ip_configuration_type" {
  type        = string
  description = "Type of frontend IP configuration: Public or Private"
}

variable "public_ip_address_id" {
  type        = string
  description = "ID of the public IP address"
  default     = null
}

variable "public_ip_name" {
  type        = string
  description = "Optional custom name for public IP used by Application Gateway"
  default     = null
}

variable "private_ip_address" {
  type        = string
  description = "Private IP address for Application Gateway"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where Application Gateway will be deployed"
}

variable "backend_pool_ip_addresses" {
  type        = list(string)
  description = "List of IP addresses for the backend pool"
}

variable "apim_name" {
  type        = string
  description = "SKU name for Application Gateway (e.g. WAF_v2)"
}

variable "sku_name" {
  type        = string
  description = "SKU name for Application Gateway (e.g. WAF_v2)"
}

variable "sku_capacity" {
  type        = number
  description = "Instance count for Application Gateway"
}

variable "waf_policy_id" {
  type        = string
  description = "Resource ID of the Web Application Firewall policy"
}

variable "rewrite_host" {
  type        = string
  description = "Host to rewrite in the header"
}

variable "probe_path" {
  type        = string
  description = "Health probe path"
  default     = "/status-0123456789abcdef"
}

variable "backend_http_port" {
  type        = number
  default     = 80
  description = "Backend HTTP port"
}
