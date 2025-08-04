data "azurerm_client_config" "current" {}

module "umi_receiver" {
  source                = "../../../modules/umi"
  user_managed_identity = "umi-receiver"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "federation_receiver" {
  source              = "../../../modules/federation"
  name                = "receiver"
  identity_id         = module.umi_receiver.umi_id
  oidc_issuer_url     = var.oidc_issuer_url
  k8s_namespace       = "receiver"
  k8s_service_account = "receiver-sa"
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "receiver_receive" {
  scope                = var.servicebus_subscription_id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = module.umi_receiver.principal_id
}

resource "azurerm_role_assignment" "storage_table_write" {
  scope                = var.storage_id
  role_definition_id   = "0a9a5a21-2e6e-4b1b-9c0c-123f14bb2ed3"  # Storage Table Data Contributor
  principal_id         = module.umi_receiver.principal_id
}