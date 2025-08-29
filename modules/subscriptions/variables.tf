variable "management_mg_id" {}
variable "management_sub_id" {}
variable "connectivity_mg_id" {}
variable "connectivity_sub_id" {}
variable "sandbox_mg_id" {}
variable "sandbox_sub_ids" {
  type = list(string)
  default = []
}
