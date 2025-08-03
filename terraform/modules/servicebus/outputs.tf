output "namespace_id" {
  value = azurerm_servicebus_namespace.this.id
}

output "topic_id" {
  value = azurerm_servicebus_topic.default.id
}

output "subscription_id" {
  value = azurerm_servicebus_subscription.default.id
}
