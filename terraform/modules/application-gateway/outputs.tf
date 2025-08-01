output "app_gateway_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.appgw.id
}

output "public_ip_address" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_public_ip[0].ip_address
}

output "private_ip_address" {
  description = "Private IP address of the Application Gateway"
  value       = var.private_ip_address
}
