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
}

module "storage_account" {
  source = "../modules/storage-account"

  storage_account_name = var.storage_account_name
  location             = var.location
  resource_group_name  = var.resource_group_name
}

module "vnet" {
  source              = "../modules/vnet"
  vnet_name           = "nucleus-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "subnet" {
  source              = "../modules/subnet"
  subnet_name         = "nucleus-subnet"
  address_prefixes    = ["10.0.1.0/24"]
  vnet_name           = module.vnet.vnet_name
  resource_group_name = var.resource_group_name
}

module "nic_backend" {
  source                 = "../modules/network-interface-private"
  network_interface_name = "nic-backend"
  nic_private_ip         = "10.0.1.5"
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
}

# module "nic" {
#   for_each = { for idx, vm in var.vm_config : idx => vm }

#   source = "../modules/network-interface"

#   nic_private_ip         = each.value.vmPrivateIPAddress
#   nic_subnet_id          = module.subnet.subnet_id
#   network_interface_name = each.value.vmNicName
#   location               = var.location
#   resource_group_name    = var.resource_group_name
# }

module "vm_jumpbox" {
  source               = "../modules/virtual_machine"
  vm_name              = "vm-jumpbox"
  location             = var.location
  resource_group_name  = var.resource_group_name
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  network_interface_id = module.nic_jumpbox.network_interface_id
}
