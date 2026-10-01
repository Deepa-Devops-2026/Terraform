variable "location" {
  type    = string
  default = "Central India"
}

variable "key_vault_name" {
  type = string
}

variable "secret_value" {
  type      = string
  sensitive = true
}