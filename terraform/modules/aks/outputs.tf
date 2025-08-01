output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "agent_pool_nodes_ips" {
  value = azurerm_kubernetes_cluster.aks.agent_pool_profile[0].fqdn # nie zwraca IP bezpośrednio
}
