module "rg" {
  source = "../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
}

module "vnet_aks" {
  source              = "../modules/vnet"
  vnet_name           = "nucleus-aks-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = module.rg.name
}

module "subnet_aks" {
  source                  = "../modules/subnet"
  subnet_name             = "aks-subnet"
  address_prefixes        = ["10.1.1.0/24"]
  vnet_name               = module.vnet_aks.vnet_name
  resource_group_name     = var.resource_group_name
  delegation_service_name = "Microsoft.ContainerService/managedClusters"
}

module "subnet_apim" {
  source              = "../modules/subnet"
  subnet_name         = "apim-subnet"
  address_prefixes    = ["10.1.2.0/24"]
  vnet_name           = module.vnet_aks.vnet_name
  resource_group_name = var.resource_group_name
}

module "subnet_ingress" {
  source              = "../modules/subnet"
  subnet_name         = "ingress-subnet"
  address_prefixes    = ["10.1.3.0/24"]
  vnet_name           = module.vnet_aks.vnet_name
  resource_group_name = var.resource_group_name
}

module "acr" {
  source              = "../modules/acr"
  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  admin_enabled       = false

  depends_on = [module.rg]
}

module "umi" {
  source                = "../modules/umi"
  user_managed_identity = var.aks_managed_identity
  location              = var.location
  resource_group_name   = var.resource_group_name
  depends_on            = [module.rg]
}

module "aks" {
  source              = "../modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  aks_cluster_name    = "nucleus-aks-cluster"
  dns_prefix          = "nucleusaks"
  node_count          = 3
  node_vm_size        = "Standard_DS2_v2"
  vnet_subnet_id      = module.subnet_aks.subnet_id

  user_managed_identity_id = module.umi.identity_id
}
