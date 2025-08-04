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