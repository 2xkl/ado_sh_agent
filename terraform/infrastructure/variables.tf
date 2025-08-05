variable "rg_shared" {
  type = string
}

variable "rg_network" {
  type = string
}

variable "rg_aks" {
  type = string
}

variable "rg_aks_node" {
  type = string
}

variable "rg_ingress" {
  type = string
}

variable "location" {
  type = string
}

variable "range_vnet_ingress" {
  type = list(string)
}

variable "range_subnet_apim" {
  type = list(string)
}

variable "range_subnet_agw" {
  type = list(string)
}

variable "range_vnet_aks" {
  type = list(string)
}

variable "range_subnet_aks" {
  type = list(string)
}

variable "range_vnet_endpoints" {
  type = list(string)
}

variable "range_subnet_pe" {
  type = list(string)
}

variable "acr_name" {
  type = string
}

variable "apim_name" {
  type = string
}

variable "aks_managed_identity" {
  type = string
}

variable "range_subnet_pe" {
  type = list(string)
}
