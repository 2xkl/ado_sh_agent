resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes

  dynamic "delegation" {
    for_each = var.delegation_service_name != "" ? [var.delegation_service_name] : []

    content {
      name = "delegation-${delegation.value}"

      service_delegation {
        name    = delegation.value
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}
