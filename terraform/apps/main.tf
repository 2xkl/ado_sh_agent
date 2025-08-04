data "azurerm_client_config" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = "akscluster"
  resource_group_name = "z-rg-aks-dev"
}

module "rg" {
  source = "../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
}

module "static_web_app" {
  source = "../modules/static-web-app"

  name                = var.swa_name
  location            = var.location
  resource_group_name = module.rg.name
}

module "key_vault" {
  source = "../modules/key-vault"

  name                = var.kv_name
  location            = var.location
  resource_group_name = module.rg.name
}

data "azurerm_subnet" "private" {
  name                 = "pe-subnet"
  virtual_network_name = "aks-vnet"
  resource_group_name  = "z-rg-network-dev"
}

module "kv_private_endpoint" {
  source              = "../modules/private-endpoint"
  name                = "kv"
  location            = var.location
  resource_group_name = "z-rg-network-dev"
  subnet_id           = data.azurerm_subnet.private.id
  resource_id         = module.key_vault.id
  subresource_names   = ["vault"]
}

resource "azurerm_private_dns_a_record" "keyvault" {
  name                = var.kv_name
  zone_name           = "privatelink.vaultcore.azure.net"
  resource_group_name = "z-rg-network-dev"

  ttl     = 10
  records = [module.kv_private_endpoint.private_ip_address]
}

module "storage" {
  source               = "../modules/storage-account"
  storage_account_name = "storappsdevasd213"
  resource_group_name  = module.rg.name
  location             = var.location
  replication_type     = "LRS"
  table_name           = "email"
}

module "storage_private_endpoint" {
  source              = "../modules/private-endpoint"
  name                = "storage"
  location            = var.location
  resource_group_name = "z-rg-network-dev"
  subnet_id           = data.azurerm_subnet.private.id
  resource_id         = module.storage.storage_id
  subresource_names   = ["table"]
}

resource "azurerm_private_dns_a_record" "storage" {
  name                = "storappsdevasd213"
  zone_name           = "privatelink.table.core.windows.net"
  resource_group_name = "z-rg-network-dev"

  ttl     = 10
  records = [module.storage_private_endpoint.private_ip_address]
}

module "azure_open_ai" {
  source = "../modules/azure-openai"

  name                = var.aoi_name
  location            = var.location
  resource_group_name = module.rg.name
}

resource "azurerm_key_vault_secret" "openai_endpoint" {
  name         = "OAIENDPOINT"
  value        = module.azure_open_ai.endpoint
  key_vault_id = module.key_vault.id
}

resource "azurerm_key_vault_secret" "openai_key" {
  name         = "OAIKEY"
  value        = module.azure_open_ai.primary_key
  key_vault_id = module.key_vault.id
}

module "servicebus" {
  source = "../modules/servicebus"

  name                = "sb-apps-cust-dev"
  location            = var.location
  resource_group_name = module.rg.name
  topic_name          = "events"
  subscription_name   = "mails"
}

module "inspector" {
  source = "./microservices/inspector"

  location            = var.location
  resource_group_name = module.rg.name
  oidc_issuer_url     = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  key_vault_id        = module.key_vault.id
}

module "chat" {
  source = "./microservices/chat"

  location            = var.location
  resource_group_name = module.rg.name
  oidc_issuer_url     = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  key_vault_id        = module.key_vault.id
}

module "publisher" {
  source = "./microservices/publisher"

  location                   = var.location
  resource_group_name        = module.rg.name
  oidc_issuer_url            = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  servicebus_subscription_id = module.servicebus.topic_id
}

module "receiver" {
  source = "./microservices/receiver"

  location                   = var.location
  resource_group_name        = module.rg.name
  oidc_issuer_url            = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  servicebus_subscription_id = module.servicebus.topic_id
  storage_id                 = module.storage.storage_id
}

module "viewer" {
  source = "./microservices/viewer"

  location            = var.location
  resource_group_name = module.rg.name
  oidc_issuer_url     = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  storage_id          = module.storage.storage_id
}
