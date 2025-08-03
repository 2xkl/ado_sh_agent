module "rg_shared" {
  source = "../modules/resource-group"

  name     = var.rg_shared
  location = var.location
}

module "log_analytics" {
  source              = "../modules/log-analytics"
  name                = "shared-law"
  location            = var.location
  resource_group_name = module.rg_shared.name
}

module "app_insights" {
  source              = "../modules/app-insights"
  name                = "shared-ai"
  location            = var.location
  resource_group_name = module.rg_shared.name
  workspace_id        = module.log_analytics.workspace_id
}

module "acr" {
  source              = "../modules/acr"
  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = module.rg_shared.name
  sku                 = "Standard"
  admin_enabled       = false

  depends_on = [module.rg_shared]
}

module "rg_network" {
  source = "../modules/resource-group"

  name     = var.rg_network
  location = var.location
}

module "vnet_aks" {
  source              = "../modules/vnet"
  vnet_name           = "aks-vnet"
  address_space       = var.range_vnet_aks
  location            = var.location
  resource_group_name = module.rg_network.name
}

module "subnet_aks" {
  source              = "../modules/subnet"
  subnet_name         = "aks-subnet"
  address_prefixes    = var.range_subnet_aks
  vnet_name           = module.vnet_aks.vnet_name
  resource_group_name = module.rg_network.name
}

module "subnet_apim" {
  source              = "../modules/subnet"
  subnet_name         = "apim-subnet"
  address_prefixes    = var.range_subnet_apim
  vnet_name           = module.vnet_aks.vnet_name
  resource_group_name = module.rg_network.name
}

module "subnet_ingress" {
  source              = "../modules/subnet"
  subnet_name         = "ingress-subnet"
  address_prefixes    = var.range_subnet_ingress
  vnet_name           = module.vnet_aks.vnet_name
  resource_group_name = module.rg_network.name
}

module "aks_nsg" {
  source              = "../modules/nsg"
  nsg_name            = "aks-subnet-nsg"
  location            = var.location
  resource_group_name = module.rg_network.name
  security_rules = [
    {
      name                       = "AllowAPIMtoAKS"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.1.2.0/24"
      destination_address_prefix = "VirtualNetwork"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "aks_assoc" {
  subnet_id                 = module.subnet_aks.subnet_id
  network_security_group_id = module.aks_nsg.nsg_id
}

module "apim_nsg" {
  source              = "../modules/nsg"
  nsg_name            = "apim-subnet-nsg"
  location            = var.location
  resource_group_name = module.rg_network.name
  security_rules = [
    {
      name                       = "AllowHTTPInbound"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowHTTPSInbound"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowMgmtInbound"
      priority                   = 103
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3443"
      source_address_prefix      = "ApiManagement"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowRedisCacheInbound"
      priority                   = 104
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6381-6383"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowSyncCountersInbound"
      priority                   = 105
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "4290"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowLoadBalancerInbound"
      priority                   = 106
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowIngresstoApim"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.1.3.0/24"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowALLInbound"
      priority                   = 199
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowALLOutbound"
      priority                   = 299
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
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

module "rg_aks" {
  source = "../modules/resource-group"

  name     = var.rg_aks
  location = var.location
}

module "umi" {
  source                = "../modules/umi"
  user_managed_identity = var.aks_managed_identity
  location              = var.location
  resource_group_name   = module.rg_aks.name
}

module "aks" {
  source                   = "../modules/aks"
  resource_group_name      = module.rg_aks.name
  resource_group_node_name = var.rg_aks_node
  location                 = var.location
  aks_cluster_name         = "akscluster"
  dns_prefix               = "zakscluster001"
  node_count               = 1
  node_vm_size             = "Standard_DS2_v2"
  vnet_subnet_id           = module.subnet_aks.subnet_id

  user_managed_identity_id = module.umi.umi_id
}

# module "network_contributor_role" {
#   source       = "../modules/role-assignment"
#   scope        = module.subnet_aks.subnet_id
#   principal_id = module.umi.umi_id
# }

module "rg_ingress" {
  source = "../modules/resource-group"

  name     = var.rg_ingress
  location = var.location
}

module "apim" {
  source              = "../modules/apim"
  resource_group_name = module.rg_ingress.name
  location            = var.location
  apim_name           = "apim-custom-2xkl"
  subnet_id           = module.subnet_apim.subnet_id

  publisher_name       = "cmp"
  publisher_email      = "admin@cmp.com"
  virtual_network_type = "Internal"
  depends_on           = [azurerm_subnet_network_security_group_association.apim_assoc]
}

module "appgw_policy" {
  source              = "../modules/waf-policy-module"
  name                = "waf-policy"
  location            = var.location
  resource_group_name = module.rg_ingress.name
}

module "app_gateway" {
  source              = "../modules/application-gateway"
  resource_group_name = module.rg_ingress.name
  location            = var.location
  app_gateway_name    = "appgw"
  subnet_id           = module.subnet_ingress.subnet_id

  frontend_ip_configuration_type = "Public"
  backend_pool_ip_addresses      = [module.apim.private_ip_address]

  waf_policy_id = module.appgw_policy.waf_policy_id
  sku_name      = "WAF_v2"
  sku_capacity  = 2

  rewrite_host = "apim-custom-2xkl.azure-api.net"
}

resource "azurerm_api_management_logger" "appinsights" {
  name                = "appinsights-logger"
  api_management_name = module.apim.apim_name
  resource_group_name = module.rg_ingress.name
  # logger_type         = "applicationInsights"

  application_insights {
    instrumentation_key = module.app_insights.instrumentation_key
  }

  buffered = false
}