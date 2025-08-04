resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = var.key_vault_id

  tenant_id = var.access_policy.tenant_id
  object_id = var.access_policy.object_id

  secret_permissions      = var.access_policy.secret_permissions
  key_permissions         = var.access_policy.key_permissions
  certificate_permissions = var.access_policy.certificate_permissions
  storage_permissions     = var.access_policy.storage_permissions

  lifecycle {
    ignore_changes = [
      secret_permissions,
      key_permissions,
      certificate_permissions,
      storage_permissions,
    ]
  }
}
