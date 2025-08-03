resource "azurerm_servicebus_namespace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_servicebus_topic" "default" {
  name                = var.topic_name
  namespace_id        = azurerm_servicebus_namespace.this.id
#   enable_partitioning = true
}

resource "azurerm_servicebus_subscription" "default" {
  name                = var.subscription_name
  topic_id            = azurerm_servicebus_topic.default.id
  max_delivery_count  = 10
  lock_duration       = "PT1M"
}
