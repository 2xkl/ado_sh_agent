variable "resource_group_name" {
  type    = string
  default = "do-test-state-rg"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "storage_account_name" {
  type    = string
  default = "devops123123"
}

variable "container_name" {
  type    = string
  default = "tfstate"
}

variable "key_vault_name" {
  type    = string
  default = "strangekvtestss2"
}

variable "tenant_id" {
  type = string
}

variable "service_connection_object_id" {
  type = string
}

variable "admin_object_id" {
  type = string
}