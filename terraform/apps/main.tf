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

# module "servicebus" {
#   source              = "../modules/servicebus"
#   name                = "sb-apps-dev"
#   location            = var.location
#   resource_group_name = module.rg_shared.name
#   topic_name          = "events"
#   subscription_name   = "inspector"
# }

data "azurerm_kubernetes_cluster" "aks" {
  name                = "akscluster"
  resource_group_name = "z-rg-aks-dev"
}

module "umi_inspector" {
  source                = "../modules/umi"
  user_managed_identity = "umi-inspector"
  location              = var.location
  resource_group_name   = module.rg_aks.name
}

module "federation_inspector" {
  source              = "../modules/federation"
  name                = "inspektor"
  identity_id         = module.umi_inspektor.identity.id
  oidc_issuer_url     = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  k8s_namespace       = "inspektor"
  k8s_service_account = "inspektor-sa"
  resource_group_name = module.rg_aks.name
}

module "umi_chat" {
  source                = "../modules/umi"
  user_managed_identity = "umi-chat"
  location              = var.location
  resource_group_name   = module.rg_aks.name
}

module "federation_chat" {
  source              = "../modules/federation"
  name                = "chat"
  identity_id         = module.umi_chat.identity.id
  oidc_issuer_url     = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  k8s_namespace       = "chat"
  k8s_service_account = "chat-sa"
  resource_group_name = module.rg_aks.name
}

resource "azurerm_role_assignment" "kv_reader_inspektor" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.umi_inspector.identity.principal_id
}

resource "azurerm_role_assignment" "kv_reader_chat" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.umi_chat.identity.principal_id
}
