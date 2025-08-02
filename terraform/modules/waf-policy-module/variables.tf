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

# variable "custom_rules" {
#   description = "Optional list of custom rules"
#   type = list(object({
#     name      = string
#     priority  = number
#     rule_type = string
#     match_conditions = list(object({
#       match_variables = list(object({
#         variable_name = string
#         selector      = optional(string)
#       }))
#       operator     = string
#       match_values = list(string)
#       transforms   = optional(list(string))
#       negate       = optional(bool)
#     }))
#     action = string
#   }))
#   default = []
# }

variable "tags" {
  type    = map(string)
  default = {}
}
