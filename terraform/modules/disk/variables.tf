variable "vm_data_disk_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "disk_sku" {
  type    = string
  default = "StandardSSD_LRS"
}

variable "disk_size_gb" {
  type    = number
  default = 128
}
