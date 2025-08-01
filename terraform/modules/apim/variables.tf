variable "resource_group_name" {
  description = "Nazwa resource group"
  type        = string
}

variable "location" {
  description = "Region Azure, np. westeurope"
  type        = string
}

variable "apim_name" {
  description = "Nazwa usługi API Management"
  type        = string
}

variable "publisher_name" {
  description = "Nazwa wydawcy API"
  type        = string
  default     = "YourCompany"
}

variable "publisher_email" {
  description = "Email wydawcy API"
  type        = string
  default     = "admin@yourcompany.com"
}

variable "virtual_network_type" {
  description = "Typ wirtualnej sieci APIM (np. Internal, External)"
  type        = string
  default     = "Internal"
}

variable "subnet_id" {
  description = "ID subnetu, w którym ma być umieszczone APIM (jeśli VNet)"
  type        = string
}
