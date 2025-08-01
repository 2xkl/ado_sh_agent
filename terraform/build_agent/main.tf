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
  source = "../modules/storage_account"
  name   = var.storage_account_name

  storage_account_name = var.storage_account_name
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

# module "nic" {
#   for_each = { for idx, vm in var.vm_config : idx => vm }

#   source = "../modules/network_interface"
#   name   = "${each.value.vmNicName}-${var.idx}"

#   nic_private_ip         = each.value.vmPrivateIPAddress
#   nic_subnet_id          = module.subnet.subnet_id
#   network_interface_name = each.value.vmNicName
# }

# module "vm" {
#   for_each = { for idx, vm in var.vm_config : idx => vm }

#   source = "../modules/vm"
#   name   = "${each.value.vmName}-${var.deploytime}"

#   vm_name                  = each.value.vmName
#   vm_hostname              = each.value.vmHostname
#   data_disks               = each.value.vmDataDisks
#   nic_id                   = module.nic[each.key].network_interface_id
#   primary_blob_endpoint    = module.storage_account.primary_blob_endpoint
#   user_assigned_managed_id = module.umi.umi_id
#   zone                     = each.value.vmAvailabilityZone
#   admin_password           = var.admin_password
#   admin_user               = var.admin_user
# }
