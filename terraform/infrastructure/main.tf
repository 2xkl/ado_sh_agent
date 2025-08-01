module "rg" {
  source = "../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
}