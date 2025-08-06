variable "subnet_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_prefixes" {
  type = list(string)
}

variable "resource_group_name" {
  type = string
}

variable "delegation_service_name" {
  description = "Optional delegation service name, e.g. Microsoft.ContainerService/managedClusters"
  type        = string
  default     = ""
}