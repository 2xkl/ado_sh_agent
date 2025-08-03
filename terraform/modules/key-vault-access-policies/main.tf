resource "azurerm_key_vault_access_policy" "this" {
  for_each = {
    for idx, policy in var.access_policies :
    "${policy.tenant_id}-${policy.object_id}-${idx}" => policy
  }

  key_vault_id = var.key_vault_id
  tenant_id    = each.value.tenant_id
  object_id    = each.value.object_id

  secret_permissions      = lookup(each.value, "secret_permissions", [])
  key_permissions         = lookup(each.value, "key_permissions", [])
  certificate_permissions = lookup(each.value, "certificate_permissions", [])
  storage_permissions     = lookup(each.value, "storage_permissions", [])

  lifecycle {
    ignore_changes = [
      secret_permissions,
      key_permissions,
      certificate_permissions,
      storage_permissions,
    ]
  }
}
