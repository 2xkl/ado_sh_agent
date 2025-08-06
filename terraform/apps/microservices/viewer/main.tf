data "azurerm_client_config" "current" {}

module "umi_viewer" {
  source                = "../../../modules/umi"
  user_managed_identity = "umi-${var.app_name}"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "federation_viewer" {
  source              = "../../../modules/federation"
  name                = var.app_name
  identity_id         = module.umi_viewer.umi_id
  oidc_issuer_url     = var.oidc_issuer_url
  k8s_namespace       = var.app_name
  k8s_service_account = "${var.app_name}-sa"
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "storage_table_read" {
  scope                = var.storage_id
  role_definition_name = "Storage Table Data Reader"
  principal_id         = module.umi_viewer.principal_id
}
