resource "azurerm_federated_identity_credential" "this" {
  name                = "${var.name}-federation"
  parent_id           = var.identity_id
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account}"
  audience            = ["api://AzureADTokenExchange"]
  resource_group_name = var.resource_group_name
}
