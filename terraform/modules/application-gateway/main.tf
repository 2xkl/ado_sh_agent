resource "azurerm_public_ip" "appgw_public_ip" {
  count               = var.frontend_ip_configuration_type == "Public" ? 1 : 0
  name                = coalesce(var.public_ip_name, "${var.app_gateway_name}-pip")
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  zones               = ["1", "2", "3"]

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  firewall_policy_id = var.waf_policy_id

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  frontend_ip_configuration {
    name                          = "appGwPublicFrontendIpIPv4"
    public_ip_address_id          = var.frontend_ip_configuration_type == "Public" ? azurerm_public_ip.appgw_public_ip[0].id : null
    private_ip_address            = var.frontend_ip_configuration_type == "Private" ? var.private_ip_address : null
    private_ip_address_allocation = var.frontend_ip_configuration_type == "Private" ? "Static" : null
    subnet_id                     = var.frontend_ip_configuration_type == "Private" ? var.subnet_id : null
  }

  backend_address_pool {
    name         = "API"
    ip_addresses = ["10.1.2.4"]
  }

  backend_address_pool {
    name = "sinkpool"
  }

  probe {
    name = "APIM-hc"

    protocol = "Http"
    host     = "${var.apim_name}.azure-api.net"
    path     = "/status-0123456789abcdef"

    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

  }

  backend_http_settings {
    name                  = "httpsettings"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 20
    probe_name            = "APIM-hc"
  }

  rewrite_rule_set {
    name = "test"

    rewrite_rule {
      name          = "NewRewrite"
      rule_sequence = 100

      request_header_configuration {
        header_name  = "Host"
        header_value = "${var.apim_name}.azure-api.net"
      }
    }
  }

  url_path_map {
    name                               = "rule01"
    default_backend_address_pool_name  = "API"
    default_backend_http_settings_name = "httpsettings"
    default_rewrite_rule_set_name      = "test"

    path_rule {
      name                       = "internaltarget"
      paths                      = ["/internal/*"]
      backend_address_pool_name  = "sinkpool"
      backend_http_settings_name = "httpsettings"
    }

    path_rule {
      name                       = "externaltarget"
      paths                      = ["/external/*"]
      backend_address_pool_name  = "API"
      backend_http_settings_name = "httpsettings"
    }
  }

  http_listener {
    name                           = "listener01"
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name               = "rule01"
    rule_type          = "PathBasedRouting"
    http_listener_name = "listener01"
    url_path_map_name  = "rule01"
    priority           = 11
  }
}

resource "azurerm_monitor_diagnostic_setting" "appgw_diag" {
  name               = "${var.app_gateway_name}-diagnostic"
  target_resource_id = azurerm_application_gateway.appgw.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }

}