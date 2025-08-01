module "rg" {
  source = "../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
}

module "umi" {
  source                = "../modules/umi"
  user_managed_identity = var.user_managed_identity
  location              = var.location
  resource_group_name   = var.resource_group_name
  depends_on            = [module.rg]
}

module "storage_account" {
  source = "../modules/storage-account"

  storage_account_name = var.storage_account_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  depends_on           = [module.rg]
}

module "vnet" {
  source              = "../modules/vnet"
  vnet_name           = "nucleus-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [module.rg]
}

module "subnet_backend" {
  source              = "../modules/subnet"
  subnet_name         = "nucleus-subnetbe"
  address_prefixes    = ["10.0.0.0/24"]
  vnet_name           = module.vnet.vnet_name
  resource_group_name = var.resource_group_name
}

module "subnet_public" {
  source              = "../modules/subnet"
  subnet_name         = "nucleus-subnetpub"
  address_prefixes    = ["10.0.1.0/24"]
  vnet_name           = module.vnet.vnet_name
  resource_group_name = var.resource_group_name
}

module "jumpbox_nsg" {
  source              = "../modules/nsg"
  nsg_name            = "${var.resource_group_name}-jumpbox-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rules = [
    {
      name                       = "AllowSSHFromMyIP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "91.236.5.10/32"
      destination_port_range     = "22"
      source_port_range          = "*"
      destination_address_prefix = "*"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "apim_assoc" {
  subnet_id                 = module.subnet_public.subnet_id
  network_security_group_id = module.jumpbox_nsg.nsg_id
}


module "nic_backend" {
  source                 = "../modules/network-interface-private"
  network_interface_name = "nic-backend"
  nic_private_ip         = "10.0.0.5"
  nic_subnet_id          = module.subnet_backend.subnet_id
  location               = var.location
  resource_group_name    = var.resource_group_name
}

module "nic_jumpbox" {
  source                 = "../modules/network-interface-public"
  network_interface_name = "nic-jumpbox"
  nic_private_ip         = "10.0.1.10"
  nic_subnet_id          = module.subnet_public.subnet_id
  location               = var.location
  resource_group_name    = var.resource_group_name
  zone                   = var.vm_config.vmAvailabilityZone
  depends_on             = [module.rg]
}

module "vm" {
  source                   = "../modules/vm"
  vm_name                  = var.vm_config.vmName
  vm_hostname              = var.vm_config.vmHostname
  primary_blob_endpoint    = module.storage_account.primary_blob_endpoint
  user_assigned_managed_id = module.umi.umi_id
  zone                     = var.vm_config.vmAvailabilityZone
  admin_password           = "Kurkam33Kurkam33"
  admin_username           = "kurkam"
  location                 = var.location
  resource_group_name      = var.resource_group_name

  nic_ids = [
    module.nic_backend.network_interface_id,
    module.nic_jumpbox.network_interface_id
  ]
}
