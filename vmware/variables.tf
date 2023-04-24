variable "vm-name" {
  type        = string
  description = "Name of the instance"
}
variable "domain" {
  type        = string
  description = "Domain"
}
variable "template" {
  type        = string
  description = "Name of the template to be used for deployment"
}
variable "datacenter" {
  type        = string
  description = "Name of the Datacenter to be used for deployment"
}
variable "cluster" {
  type        = string
  description = "Name of the Cluster to be used for deployment"
}
variable "host" {
  type        = string
  description = "Name of the ESXi host to be used for deployment"
}
variable "folder" {
  type        = string
  description = "Name of the folder to be used for deployment"
}
variable "datastore" {
  type        = string
  description = "Name of the Datastore to be used for deployment"
}
variable "admin-passwd" {
  type        = string
  default     = "Sup3rSecr3t"
  description = "Set an Admin passwd"
}
variable "quantity" {
  type        = number
  description = "How many instances to be deployed"
}
variable "port-group" {
  type        = string
  description = "Name of the Port Group to be used for deployment"
}
variable "vsphere-user" {
  type        = string
  description = "Set vSphere username for connection"
}
variable "vsphere-server" {
  type        = string
  description = "Set vSphere Server"
}
variable "vsphere-passwd" {
  type        = string
  description = "Set vSphere passwd for connection"
}
