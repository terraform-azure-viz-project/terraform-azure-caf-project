variable "environment" {}
variable "location_short" {}
variable "location" {}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
