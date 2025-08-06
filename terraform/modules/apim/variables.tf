variable "resource_group_name" {}
variable "location" {}
variable "apim_name" {}
variable "publisher_name" {
  default = "YourCompany"
}
variable "publisher_email" {
  default = "admin@yourcompany.com"
}
variable "virtual_network_type" {
  default = "Internal"
}
variable "subnet_id" {}

variable "log_analytics_workspace_id" {}
