locals {
  key_vault_name = var.name == "" && var.name_prefix == "" ? "vault-${random_string.name.result}" : var.name_prefix != "" ? "${var.name_prefix}-vault" : var.name
}

resource "random_string" "name" {
  length    = 5
  special   = false
  upper     = false
  lower     = true
  number    = false
}

resource null_resource print_names {
  provisioner "local-exec" {
    command = "echo 'Resource group name: ${var.resource_group_name}'"
  }
}

data azurerm_client_config default {
}

data azurerm_resource_group resource_group {
  depends_on = [null_resource.print_names]

  name = var.resource_group_name
}

resource "azurerm_key_vault" "key_vault" {
  count = var.provision ? 1 : 0

  name                        = local.key_vault_name
  location                    = data.azurerm_resource_group.resource_group.location
  resource_group_name         = data.azurerm_resource_group.resource_group.name
  tenant_id                   = data.azurerm_client_config.default.tenant_id
  sku_name                    = var.sku_name

  enabled_for_deployment            = var.enabled_for_deployment
  enabled_for_disk_encryption       = var.enabled_for_disk_encryption
  enabled_for_template_deployment   = var.enabled_for_template_deployment
  enable_rbac_authorization         = var.enable_rbac_authorization
  public_network_access_enabled     = var.public_network_access_enabled
  purge_protection_enabled          = var.purge_protection_enabled
  soft_delete_retention_days        = var.soft_delete_retention_days

  access_policy {
    object_id = data.azurerm_client_config.default.object_id
    tenant_id = data.azurerm_client_config.default.tenant_id

    key_permissions         = var.key_permissions
    secret_permissions      = var.secret_permissions
    certificate_permissions = var.certificate_permissions
    storage_permissions     = var.storage_permissions
  }
}

data "azurerm_key_vault" "key_vault" {
  depends_on = [azurerm_key_vault.key_vault]

  name = local.key_vault_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}