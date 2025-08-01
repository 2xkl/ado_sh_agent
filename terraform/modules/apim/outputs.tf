output "apim_id" {
  value = azurerm_api_management.apim.id
}

output "apim_name" {
  value = azurerm_api_management.apim.name
}

output "apim_service_url" {
  value = azurerm_api_management.apim.gateway_url
}

output "private_ip_address" {
  value = length(azurerm_api_management.apim.private_ip_addresses) > 0 ? azurerm_api_management.apim.private_ip_addresses[0] : ""
}
