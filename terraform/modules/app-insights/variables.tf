variable "name" {
  description = "Application Insights name"
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

variable "application_type" {
  description = "Type of Application Insights (e.g. 'web')"
  type        = string
  default     = "web"
}

variable "workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}
