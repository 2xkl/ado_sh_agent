data "azurerm_client_config" "current" {}

module "umi_chat" {
  source                = "../../../modules/umi"
  user_managed_identity = "umi-chat"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "federation_chat" {
  source              = "../../../modules/federation"
  name                = "chat"
  identity_id         = module.umi_chat.umi_id
  oidc_issuer_url     = var.oidc_issuer_url
  k8s_namespace       = "chat"
  k8s_service_account = "chat-sa"
  resource_group_name = var.resource_group_name
}

module "kv_access_policies" {
  source = "../../../modules/key-vault-access-policies"

  key_vault_id = var.key_vault_id

  access_policies = [
    {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = module.umi_chat.principal_id
      secret_permissions      = ["Get", "List"]
      key_permissions         = []
      certificate_permissions = []
      storage_permissions     = []
    }
  ]
}
