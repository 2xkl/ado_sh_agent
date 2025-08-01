variable "resource_group_name" {}
variable "location" {}
variable "apim_name" {}
variable "publisher_name" {
  default = "YourCompany"
}
variable "publisher_email" {
  default = "admin@yourcompany.com"
}
variable "virtual_network_type" {
  default = "Internal" # jeśli chcesz APIM w VNet, np. "Internal" albo "External"
}
variable "subnet_id" {}

resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "Developer_1" # albo inna SKU

  virtual_network_type = var.virtual_network_type

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  tags = {
    environment = "dev"
    project     = "nucleus"
  }
}

output "private_ip_address" {
  # Jeśli APIM jest w VNet z trybem Internal, możemy zwrócić prywatne IP z interfejsów
  value       = azurerm_api_management.apim.private_ip_addresses[0]
  description = "Private IP address of the APIM inside the VNet"
}

output "apim_service_url" {
  value       = azurerm_api_management.apim.gateway_url
  description = "APIM Gateway URL"
}
