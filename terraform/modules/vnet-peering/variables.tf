variable "name_prefix" {
  description = "Prefix for naming the peering"
  type        = string
}

variable "source_rg" {
  description = "Resource group of the source VNet"
  type        = string
}

variable "source_vnet_name" {
  description = "Name of the source VNet"
  type        = string
}

variable "source_vnet_id" {
  description = "ID of the source VNet"
  type        = string
}

variable "target_rg" {
  description = "Resource group of the target VNet"
  type        = string
}

variable "target_vnet_name" {
  description = "Name of the target VNet"
  type        = string
}

variable "target_vnet_id" {
  description = "ID of the target VNet"
  type        = string
}
