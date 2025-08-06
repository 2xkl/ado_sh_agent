output "private_ip_address" {
  value = azurerm_api_management.apim.private_ip_addresses[0]
}

output "apim_service_url" {
  value = azurerm_api_management.apim.gateway_url
}

output "apim_name" {
  value = azurerm_api_management.apim.name
}

output "apim_id" {
  value = azurerm_api_management.apim.id
}
