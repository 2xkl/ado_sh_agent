data "azurerm_client_config" "current" {}

module "umi_receiver" {
  source                = "../../../modules/umi"
  user_managed_identity = "umi-${var.app_name}"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "federation_receiver" {
  source              = "../../../modules/federation"
  name                = var.app_name
  identity_id         = module.umi_receiver.umi_id
  oidc_issuer_url     = var.oidc_issuer_url
  k8s_namespace       = var.app_name
  k8s_service_account = "${var.app_name}-sa"
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "receiver_receive" {
  scope                = var.servicebus_subscription_id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = module.umi_receiver.principal_id
}

resource "azurerm_role_assignment" "storage_table_write" {
  scope                = var.storage_id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = module.umi_receiver.principal_id
}
