module "rg" {
  source = "../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
}

module "acr" {
  source              = "../modules/acr"
  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"           # lub Premium, jeśli potrzebujesz georeplikacji
  admin_enabled       = false               # true tylko jeśli potrzebujesz login/pw do pushowania

  depends_on = [ module.rg ]
}
