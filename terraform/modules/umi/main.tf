resource "azurerm_user_assigned_identity" "umi" {
  name                = var.user_managed_identity
  location            = var.location
  resource_group_name = var.resource_group_name
}
