resource "azurerm_key_vault" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  # soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover"
    ]
  }

  lifecycle {
    ignore_changes = [
      access_policy
    ]
  }

}

data "azurerm_client_config" "current" {}
