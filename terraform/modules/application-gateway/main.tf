resource "azurerm_public_ip" "appgw_public_ip" {
  count               = var.frontend_ip_configuration_type == "Public" ? 1 : 0
  name                = var.public_ip_name != null ? var.public_ip_name : "${var.app_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    name     = var.sku_name
    tier     = var.sku_name
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontendIpConfig"
    public_ip_address_id = var.frontend_ip_configuration_type == "Public" ? azurerm_public_ip.appgw_public_ip[0].id : null
    private_ip_address   = var.frontend_ip_configuration_type == "Private" ? var.private_ip_address : null
    private_ip_address_allocation = var.frontend_ip_configuration_type == "Private" ? "Static" : null
    subnet_id           = var.frontend_ip_configuration_type == "Private" ? var.subnet_id : null
  }

  backend_address_pool {
    name = "backendPool"
    ip_addresses = var.backend_pool_ip_addresses
  }

  backend_http_settings {
    name                  = "httpSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "httpListener"
    frontend_ip_configuration_name = "frontendIpConfig"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "httpListener"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSettings"
  }

  tags = {
    environment = "dev"
    project     = "nucleus"
  }
}
