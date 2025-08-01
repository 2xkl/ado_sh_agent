resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  zone                = var.zone != "" ? var.zone : null

  network_interface_ids = [var.nic_id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.disk_size_gb
    name                 = "${var.vm_name}osdisk"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.vm_sku
    version   = "latest"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_managed_id]
  }

  boot_diagnostics {
    storage_account_uri = var.primary_blob_endpoint
  }

  # os_profile_windows_config {
  #   provision_vm_agent = true
  # }
}
