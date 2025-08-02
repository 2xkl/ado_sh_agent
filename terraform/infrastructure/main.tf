module "rg" {
  source = "../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
}

module "log_analytics" {
  source              = "../modules/log-analytics"
  name                = "nucleus-law"
  location            = var.location
  resource_group_name = module.rg.name
}

module "app_insights" {
  source              = "../modules/app-insights"
  name                = "nucleus-ai"
  location            = var.location
  resource_group_name = module.rg.name
  workspace_id        = module.log_analytics.workspace_id
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
      name                       = "sub"
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
      name                       = "sub"
      priority                   = 111
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.1.4.0/24"
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
      name                       = "AllowStorageHTTPOutbound"
      priority                   = 200
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "Storage"
    },
    {
      name                       = "AllowStorageIFSOutbound"
      priority                   = 201
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "445"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "Storage"
    },
    {
      name                       = "AllowAADOutbound"
      priority                   = 202
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "AzureActiveDirectory"
    },
    {
      name                       = "AllowSQLOutbound"
      priority                   = 203
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "SQL"
    },
    {
      name                       = "AllowEventHubAMQPOutbound"
      priority                   = 204
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5671-5672"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "EventHub"
    },
    {
      name                       = "AllowEventHubHTTPOutbound"
      priority                   = 205
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "EventHub"
    },
    {
      name                       = "AllowHealthMonitoringOutbound"
      priority                   = 206
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "12000"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "AzureCloud"
    },
    {
      name                       = "AllowHealthHTTPMonitoringOutbound"
      priority                   = 207
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "AzureCloud"
    },
    {
      name                       = "AllowMonitoringOutbound"
      priority                   = 208
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1886"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "AzureMonitor"
    },
    {
      name                       = "AllowHTTPMonitoringOutbound"
      priority                   = 209
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "AzureMonitor"
    },
    {
      name                       = "AllowSMTP25RelayOutbound"
      priority                   = 210
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "25"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "Internet"
    },
    # {
    #   name                       = "AllowSMTP587RelayyOutbound"
    #   priority                   = 211
    #   direction                  = "Outbound"
    #   access                     = "Allow"
    #   protocol                   = "Tcp"
    #   source_port_range          = "*"
    #   destination_port_range     = "587"
    #   source_address_prefix      = "Internet"
    #   destination_address_prefix = azurerm_firewall.iag.ip_configuration.0.private_ip_address
    # },
    # {
    #   name                       = "AllowSMTP25028RelayyOutbound"
    #   priority                   = 212
    #   direction                  = "Outbound"
    #   access                     = "Allow"
    #   protocol                   = "Tcp"
    #   source_port_range          = "*"
    #   destination_port_range     = "25028"
    #   source_address_prefix      = "Internet"
    #   destination_address_prefix = azurerm_firewall.iag.ip_configuration.0.private_ip_address
    # },
    {
      name                       = "AllowRedisCacheOutbound"
      priority                   = 213
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6381-6383"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      }, {

      name                       = "AllowSyncCountersOutbound"
      priority                   = 214
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "4290"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
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

module "appgw_policy" {
  source              = "../modules/waf-policy-module"
  name                = "nucleus-waf-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "app_gateway" {
  source              = "../modules/application-gateway"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_gateway_name    = "nucleus-appgw"
  subnet_id           = module.subnet_ingress.subnet_id

  frontend_ip_configuration_type = "Public"
  backend_pool_ip_addresses      = [module.apim.private_ip_address]

  waf_policy_id = module.appgw_policy.id
  sku_name      = "WAF_v2"
  sku_capacity  = 2

  rewrite_host = "nucleus-apim.azure-api.net"
}
