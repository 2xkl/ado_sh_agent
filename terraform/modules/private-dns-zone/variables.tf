variable "name" {
  description = "The name of the Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the Private DNS Zone will be created"
  type        = string
}

variable "virtual_network_id" {
  description = "ID of the virtual network to link the Private DNS Zone to"
  type        = string
}
