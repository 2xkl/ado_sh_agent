output "private_ip_address" {
  # Jeśli APIM jest w VNet z trybem Internal, możemy zwrócić prywatne IP z interfejsów
  value       = azurerm_api_management.apim.private_ip_addresses[0]
  description = "Private IP address of the APIM inside the VNet"
}

output "apim_service_url" {
  value       = azurerm_api_management.apim.gateway_url
  description = "APIM Gateway URL"
}
