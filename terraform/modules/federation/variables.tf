variable "name" {
  description = "Name prefix for the federated credential"
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "identity_id" {
  description = "The ID of the User Assigned Managed Identity"
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL from the AKS cluster"
  type        = string
}

variable "k8s_namespace" {
  description = "Kubernetes namespace where the app is deployed"
  type        = string
}

variable "k8s_service_account" {
  description = "Name of the Kubernetes service account"
  type        = string
}
