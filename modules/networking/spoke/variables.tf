variable "environment" {}
variable "location_short" {}
variable "location" {}
variable "address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}
variable "vm_subnet_prefix" {
  type    = list(string)
  default = ["10.1.1.0/24"]
}
variable "rg_name" {}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
variable "additional_subnets" {
  type    = map(object({
    address_prefixes = list(string)
  }))
  default = {}
}
