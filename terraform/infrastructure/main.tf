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
  source              = "../modules/subnet"
  subnet_name         = "aks-subnet"
  address_prefixes    = ["10.1.1.0/24"]
  vnet_name           = module.vnet_aks.vnet_name
  resource_group_name = var.resource_group_name
  # delegation_service_name = "Microsoft.ContainerService/managedClusters"
}

module "subnet_apim" {
  source              = "../modules/subnet"
  subnet_name         = "apim-subnet"
  address_prefixes    = ["10.1.2.0/24"]
  vnet_name           = module.vnet_aks.vnet_name
  resource_group_name = var.resource_group_name
}

module "apim_nsg" {
  source              = "../modules/nsg"
  nsg_name            = "${var.resource_group_name}-apim-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rules = [
    {
      name                       = "Allow-APIM-Frontend-to-Subnet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork" # zamiast AzureApiManagement
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-Subnet-to-APIM-Frontend"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork" # zamiast AzureApiManagement
    },
    {
      name                       = "Allow-VNet-Internal"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "Allow-Internet-Outbound"
      priority                   = 130
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    },
    {
      name                        = "Allow-APIM-ControlPlane"
      priority                    = 300
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "3443"
      source_address_prefix       = "*"
      destination_address_prefix  = "AzureApiManagement"
      resource_group_name         = var.resource_group_name
      network_security_group_name = azurerm_network_security_group.this.name
    },
    {
      name                       = "Deny-All-Inbound"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Deny-All-Outbound"
      priority                   = 4001
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "apim_assoc" {
  subnet_id                 = module.subnet_apim.subnet_id
  network_security_group_id = module.apim_nsg.nsg_id
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

  user_managed_identity_id = module.umi.umi_id
}

module "apim" {
  source              = "../modules/apim"
  resource_group_name = var.resource_group_name
  location            = var.location
  apim_name           = "nucleus-apim"
  subnet_id           = module.subnet_apim.subnet_id

  publisher_name       = "YourCompany"
  publisher_email      = "admin@yourcompany.com"
  virtual_network_type = "Internal"
  depends_on           = [azurerm_subnet_network_security_group_association.apim_assoc]
}

module "app_gateway" {
  source              = "../modules/application-gateway"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_gateway_name    = "nucleus-appgw"
  subnet_id           = module.subnet_ingress.subnet_id

  frontend_ip_configuration_type = "Public"

  backend_pool_ip_addresses = [module.apim.private_ip_address]

  routing_rule_priority = 100
}
