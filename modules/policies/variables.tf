variable "environment" {
  description = "The deployment environment (e.g., prod, dev)."
  type        = string
}
variable "location_short" {
  description = "Short code for the Azure region (e.g., uks for UK South)."
  type        = string
}
variable "platform_mg_id" {
  description = "The ID of the platform management group to apply full policies to."
  type        = string
}
variable "sandbox_mg_id" {
  description = "The ID of the sandbox management group to apply limited policies to."
  type        = string
}
