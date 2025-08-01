resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipConfig"
    subnet_id                     = var.nic_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.nic_private_ip
  }
}
