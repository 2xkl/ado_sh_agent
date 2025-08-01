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
