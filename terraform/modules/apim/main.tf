resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "Developer_1"

  virtual_network_type = var.virtual_network_type

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

}

# resource "azurerm_monitor_diagnostic_setting" "apim_diag" {
#   name                       = "${var.apim_name}-diagnostic"
#   target_resource_id         = azurerm_api_management.apim.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   enabled_metric {
#     category = "AllMetrics"
#   }

#   enabled_log {
#     category_group = "allLogs"
#   }

#   enabled_log {
#     category_group = "audit"
#   }
# }
