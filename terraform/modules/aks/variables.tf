variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "aks_cluster_name" {
  type = string
}

variable "node_count" {
  type    = number
  default = 3
}

variable "node_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "vnet_subnet_id" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.32.6"
}

variable "user_managed_identity_id" {
  type    = string
  default = null
}
