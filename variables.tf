variable "resource_group_name" {
  type          = string
  description   = "Resource group to which to add key vault"
}

## Following variables have default values

variable "name" {
  type          = string
  description   = "Name to give key vault"
  default       = ""
}

variable "name_prefix" {
  type          = string
  description   = "Prefix for the key vault name (default = \"\")"
  default       = ""
}

variable "provision" {
  type          = bool
  description   = "Flag to determine whether to create a new key vault (true) or read an exisitng one (false). (Default = \"true\")"
  default       = true
}

variable "enabled_for_deployment" {
  type          = bool
  description   = "Flag to enable key vault to be utilized for Azure Virtual Machines (default = false)"
  default       = false
}

variable "enabled_for_disk_encryption" {
  type          = bool
  description   = "Flag to enable key vault to be utilized for client managed key disk encryption (default = false)"
  default       = false
}

variable "enabled_for_template_deployment" {
  type          = bool
  description   = "Flag to enable key vault to be utilzied for Azure Resource Manager to retrieve secrets (default = false)"
  default       = false
}

variable "enable_rbac_authorization" {
  type          = bool
  description   = "Flag to specify whether RBAC to be utilized for authorization of data actions (default = false)"
  default       = false
}

variable "purge_protection_enabled" {
  type          = bool
  description   = "Flag to enable purge protection. Note that this prevents terraform from deleting the key vault. (default = false)"
  default       = false
}

variable "public_network_access_enabled" {
  type          = bool
  description   = "Flag to specify whether public network access to the key vault is permitted (default = true)"
  default       = true
}

variable "soft_delete_retention_days" {
  type          = number
  description   = "Number of days to keep soft deleted vault for recovery"  
  default       = 7
}

variable "sku_name" {
  type          = string
  description   = "The name of the Azure SKU to be utilized for the key vault - \"standard\" or \"premium\" (default = \"premium\")"
  default       = "premium"
}

variable "key_permissions" {
  type          = list(string)
  description   = "List of key permissions"
  default       = [
    "Create",
    "Get",
    "Purge",
    "Delete",
    "Encrypt",
    "Decrypt",
    "Import",
    "Verify",
    "WrapKey",
    "UnwrapKey"
  ]
}

variable "secret_permissions" {
  type          = list(string)
  description   = "List of secret permissions"
  default       = [
    "Set",
    "Get",
    "Delete",
    "Purge",
    "Restore",
    "Recover"
  ]
}

variable "certificate_permissions" {
  type          = list(string)
  description   = "List of certificate permissions"
  default       = [
    "Create",
    "Delete",
    "Get",
    "Import",
    "Update",
    "Restore",
    "Recover",
    "ListIssuers"]
}

variable "storage_permissions" {
  type          = list(string)
  description   = "List of storage permissions"
  default       = [ 
    "Get",
    "Set",
    "Update",
    "Delete",
    "Purge",
    "Recover",
    "Restore",
    "GetSAS",
    "SetSAS"
  ]
}