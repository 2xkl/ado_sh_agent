resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
#   tags     = var.tags
}

# module "rg" {
#   source = "../modules/resource-group"

#   name     = var.resource_group_name
#   location = var.location
# }

# provider "azurerm" {
#   features {}
# }



# module "storage_account" {
#   source = "../modules/storage-account"

#   storage_account_name = var.storage_account_name
#   resource_group_name  = module.rg.name
#   location             = module.rg.location
# }

# module "storage_container" {
#   source = "../modules/storage-account-container"

#   container_name        = var.container_name
#   storage_account_id    = module.storage_account.id
#   container_access_type = "private"
# }

# module "keyvault" {
#   source = "../modules/keyvault"

#   name                         = var.key_vault_name
#   location                     = var.location
#   resource_group_name          = module.rg.name
#   tenant_id                    = var.tenant_id
#   admin_object_id              = var.admin_object_id
#   service_connection_object_id = var.service_connection_object_id
# }
