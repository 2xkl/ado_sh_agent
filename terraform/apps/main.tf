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

module "servicebus" {
  source              = "../modules/servicebus"
  name                = "sb-apps-dev"
  location            = var.location
  resource_group_name = module.rg_shared.name
  topic_name          = "events"
  subscription_name   = "inspector"
}