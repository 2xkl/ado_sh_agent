variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}

variable "aks_managed_identity" {
  type = string
}
