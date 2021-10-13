variable "prefix" {
  description = "The prefix which should be used for all resources in this run"
}

variable "location" {
  description = "The Azure Region in which all resources in this run should be created."
}
variable "subscription_id" {}
variable "tenant_id" {}
variable "resource_group" {}
