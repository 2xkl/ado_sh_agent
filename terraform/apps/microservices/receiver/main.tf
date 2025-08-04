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
  oidc_issuer_url     = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  k8s_namespace       = "receiver"
  k8s_service_account = "receiver-sa"
  resource_group_name = var.resource_group_name
}