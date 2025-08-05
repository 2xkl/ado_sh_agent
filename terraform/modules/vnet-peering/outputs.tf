output "source_to_target_name" {
  value = azurerm_virtual_network_peering.source_to_target.name
}

output "target_to_source_name" {
  value = azurerm_virtual_network_peering.target_to_source.name
}
