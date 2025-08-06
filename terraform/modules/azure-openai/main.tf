resource "azurerm_cognitive_account" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"

  custom_subdomain_name = var.name
}

resource "azurerm_cognitive_deployment" "gpt_35_turbo" {
  name                 = "gpt-35-turbo"
  cognitive_account_id = azurerm_cognitive_account.this.id

  sku {
    name = "Standard"
  }

  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0125"
  }
}
