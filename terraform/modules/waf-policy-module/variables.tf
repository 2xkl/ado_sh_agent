variable "name" {
  type        = string
  description = "WAF policy name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "mode" {
  type        = string
  default     = "Prevention"
  description = "WAF mode: Detection or Prevention"
}

variable "tags" {
  type    = map(string)
  default = {}
}
