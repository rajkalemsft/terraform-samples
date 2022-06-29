variable "resource_group_name" {
  default = "terraform_samples_rg"
}

variable "eh-keyvault" {
  default = "eh-keyvault-twohat"
}

variable "user-principal" {
  type = string
  description = "Service Principal to Provide the access to KV"
  default = ""
}