resource "azurerm_managed_disk" "datadisk" {
  name                 = var.vm_data_disk_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.disk_sku
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
}
