variable "access_policy" {
  type = object({
    tenant_id               = string
    object_id               = string
    secret_permissions      = list(string)
    key_permissions         = list(string)
    certificate_permissions = list(string)
    storage_permissions     = list(string)
  })
}

variable "key_vault_id" {
  type = string
}