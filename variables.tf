variable "resource_group_name" {
  default       = "diploma"
  description   = "Resource group name in azure"
}

variable "resource_group_location" {
  default       = "westeurope"
  description   = "Location of the resource group."
}

variable "username" {
  default       = "azureuser"
  description   = "Username for access to VM"
}

variable "password" {
  default       = "SuperSecur!ty@Pa$$word!"
  description   = "Password for access to VM"
}