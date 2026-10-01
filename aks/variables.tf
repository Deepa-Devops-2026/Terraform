variable "location" {
  type    = string
  default = "Central India"
}

variable "aks_name" {
  type = string
}

variable "node_count" {
  type    = number
  default = 2
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}