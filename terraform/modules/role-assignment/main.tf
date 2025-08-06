resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.scope
  role_definition_name = "Network Contributor"
  principal_id         = var.principal_id
}
