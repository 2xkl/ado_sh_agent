resource "azurerm_web_application_firewall_policy" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    enabled                     = true
    mode                        = var.mode
    request_body_check          = true
    max_request_body_size_in_kb = 128
    file_upload_limit_in_mb     = 100
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  tags = var.tags
}
