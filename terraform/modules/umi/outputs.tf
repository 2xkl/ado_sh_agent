output "umi_id" {
  value = azurerm_user_assigned_identity.umi.id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.umi.principal_id
}