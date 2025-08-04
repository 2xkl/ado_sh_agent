data "azurerm_client_config" "current" {}

module "umi_viewer" {
  source                = "../../../modules/umi"
  user_managed_identity = "umi-viewer"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "federation_viewer" {
  source              = "../../../modules/federation"
  name                = "viewer"
  identity_id         = module.umi_viewer.umi_id
  oidc_issuer_url     = var.oidc_issuer_url
  k8s_namespace       = "viewer"
  k8s_service_account = "viewer-sa"
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "storage_table_read" {
  scope                = var.storage_id
  role_definition_id   = "0a9a5a21-2e6e-4b1b-9c0c-123f14bb2ed4"  # Storage Table Data Reader
  principal_id         = module.umi_viewer.principal_id
}