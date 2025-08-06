variable "scope" {
  description = "Scope at which the role will be assigned (e.g., subnet, RG, VNet)"
  type        = string
}

variable "principal_id" {
  description = "The object ID of the principal to assign the role to"
  type        = string
}
