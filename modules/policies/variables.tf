# modules/policy/variables.tf
variable "location_short" {}
variable "environment" {}
variable "tenant_id" {}
variable "policy_json_path" {
  description = "Path to the directory containing JSON policy files"
  type        = string
}

variable "policy_type" {
  description = "Type of policies to apply (common or sandbox)"
  type        = string
  validation {
    condition     = contains(["common", "sandbox"], var.policy_type)
    error_message = "Policy type must be either 'common' or 'sandbox'."
  }
}

variable "initiative_name" {
  description = "Name of the policy initiative"
  type        = string
}

variable "initiative_display_name" {
  description = "Display name of the policy initiative"
  type        = string
}

variable "initiative_description" {
  description = "Description of the policy initiative"
  type        = string
}

variable "scope" {
  description = "Scope of the policy assignment (management_group or subscription)"
  type        = string
  validation {
    condition     = contains(["management_group", "subscription"], var.scope)
    error_message = "Scope must be either 'management_group' or 'subscription'."
  }
}

#variable "management_group_id" {
#  description = "ID of the management group for assignment (required if scope is management_group)"
#  type        = string
#  default     = ""
#}

variable "assignment_description" {
  description = "Description of the policy assignment"
  type        = string
}

variable "initiative_parameters" {
  description = "Parameters for the policy initiative (if any)"
  type        = map(any)
  default     = {}
}
