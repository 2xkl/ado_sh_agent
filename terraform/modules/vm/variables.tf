variable "vm_name" {
  type = string
}

variable "vm_hostname" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "nic_ids" {
  type = list(string)
}

variable "primary_blob_endpoint" {
  type = string
}

variable "user_assigned_managed_id" {
  type = string
}

variable "zone" {
  type    = string
  default = ""
}

variable "vm_sku" {
  type    = string
  default = "2022-datacenter-azure-edition"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2lds_v5"
}

variable "disk_size_gb" {
  type    = number
  default = 128
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "0001-com-ubuntu-server-focal"
}

variable "image_sku" {
  type    = string
  default = "20_04-lts"
}
