variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type = string
}

# variable "container_name" {
#   type = string
# }

# variable "key_vault_name" {
#   type = string
# }

variable "user_managed_identity" {
  type = string
}

# variable "deploytime" {
#   type = string
# }

# variable "vm_config" {
#   type = list(object({
#     vmName            = string
#     vmHostname        = string
#     vmDataDisks       = list(object({ name = string }))
#     vmNicName         = string
#     vmPrivateIPAddress = string
#     vmNicSubnet       = string
#     vmAvailabilityZone = string
#   }))
# }

# variable "admin_user" {
#   type = string
# }

# variable "admin_password" {
#   type      = string
#   sensitive = true
# }