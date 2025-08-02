resource "azurerm_public_ip" "this" {
  name                = "${var.network_interface_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"] # <- to dodaj
}

resource "azurerm_network_interface" "this" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.nic_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.nic_private_ip
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}