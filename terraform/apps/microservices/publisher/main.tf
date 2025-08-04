data "azurerm_client_config" "current" {}

module "umi_publisher" {
  source                = "../../../modules/umi"
  user_managed_identity = "umi-publisher"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "federation_publisher" {
  source              = "../../../modules/federation"
  name                = "publisher"
  identity_id         = module.umi_publisher.umi_id
  oidc_issuer_url     = var.oidc_issuer_url
  k8s_namespace       = "publisher"
  k8s_service_account = "publisher-sa"
  resource_group_name = var.resource_group_name
}
