# Azure Key Vault

## Module Overview

### Description

Module that provisions a, or reads an existing, Key Vault on Azure. 

**Note:** This module follows the Terraform conventions regarding how provider configuration is defined within the Terraform template and passed into the module - https://www.terraform.io/docs/language/modules/develop/providers.html. The default provider configuration flows through to the module. If different configuration is required for a module, it can be explicitly passed in the `providers` block of the module - https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly.

### Software dependencies

The module depends on the following software components:

#### Command Line Tools

- terraform >= v0.15

#### Terraform providers

- Azure provider >= 3.3.0

#### Module dependencies

This module makes use of the output from other modules:

- Resource Group - github.com/cloud-native-toolkit/terraform-azure-resource-group

## Example Usage

```hcl-terraform
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.3.0"
    }
  }
}

module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = "myExample-rg"
  region              = var.region
}

module "key_vault" {
  source = "github.com/cloud-native-toolkit/terraform-azure-key-vault"

  resource_group_name     = module.resource_group.name
  sku_name                = "standard" 
  name                    = "myVault"
  provision               = true
  key_permissions         = ["Create","Get","Purge","Delete","Encrypt","Decrypt"]
  secret_permissions      = []
  certificate_permissions = []
  storage_permissions     = []
}
```

## Read only usage

The module may be utilised in a read-only mode by setting `provision=false`.

Doing so will cause the module to attempt to read an existing Key Vault from the name and resource group provided. The module will then return the same details as when provisioning a new key vault including vault id, and vault_uri which can then be utilised by other modules.

For example:
```hcl-terraform
module "read-vault" {
  source = "github.com/cloud-native-toolkit/terraform-azure-key-vault"

  resource_group_name = module.resource_group.name
  name                = "myVault"
  provision           = false
}

output "myvault-id" {
  value = module.read-vault.id
}

output "myvault-uri" {
  value = module.read-vault.vault_uri
}
```

## Input variables

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | Mandatory | | Resource group to which to add key vault. Location of key vault will be obtained from this resource group. |
| name | Optional | "" | Name to give to key vault. If not supplied, name-prefix will be tried. If neither name nor name_prefix are provided, a random name will be used. |
| name_prefix | Optional | "" | Name prefix for key vault. Will append \"-vault\" to prefix for vault name. If not supplied, name will be tried. If neither name_prefix nor name are provided, a random name will be used. |
| provision | Optional | true | Flag to determine whether to create a new key vault, or read the details of an existing one (see example earlier in this readme) |
| enabled_for_deployment | Optional | false | Flag to enable key vault to be utilized for Azure Virtual Machines |
| enabled_for_disk_encryption | Optional | false | Flag to enable key vault to be utilized for client managed key disk encryption |
| enabled_for_template_deployment | Optional | false | Flag to enable key vault to be utilzied for Azure Resource Manager to retrieve secrets |
| enable_rbac_authorization | Optional | false | Flag to specify whether RBAC to be utilized for authorization of data actions |
| purge_protection_enabled | Optional | false | Flag to enable purge protection. Note that this prevents terraform from deleting the key vault. |
| public_network_access_enabled | Optional | true | Flag to specify whether public network access to the key vault is permitted. Note support for this flag being false is not currently supported in this module |
| soft_delete_retention_days | Optional | 7 | Number of days to keep soft deleted vault for recovery |
| sku_name | Optional | premium | The Azure SKU to be utilized. Possible values are standard or premium |
| key_permissions | Optional | Create, Get, Purge, Delete, Encrypt, Decrypt, Import, Verify, WrapKey, UnwrapKey | List of permissions for keys |
| secret_permissions | Optional | Set, Get, Delete, Purge, Restore, Recover | List of secret permissions | 
| certificate_permissions |  Optional | Create, Delete, Get, Import, Update, Restore, Recover, ListIssuers | List of certificate permissioins |
| storage_permissions | Optional | Get, Set, Update, Delete, Purge, Recover, Restore, GetSAS, SetSAS | List of storage permisions |

## Output variables

This module has the following output variables:
| Variable | Description |
| -------------------------------- | ----------------------------------------------------------------------------- |
| id  | The Azure identification string of the key vault  |
| name | The name of the key vault |
| vault_uri | The Azure URI of the key vault | 
| location | The region / location of the key vault |