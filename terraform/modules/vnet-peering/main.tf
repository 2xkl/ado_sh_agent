resource "azurerm_virtual_network_peering" "source_to_target" {
  name                      = "${var.name_prefix}-to-${var.target_vnet_name}"
  resource_group_name       = var.source_rg
  virtual_network_name      = var.source_vnet_name
  remote_virtual_network_id = var.target_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "target_to_source" {
  name                      = "${var.target_vnet_name}-to-${var.name_prefix}"
  resource_group_name       = var.target_rg
  virtual_network_name      = var.target_vnet_name
  remote_virtual_network_id = var.source_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
