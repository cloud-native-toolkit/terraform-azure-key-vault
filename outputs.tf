output "id" {
  description   = "Key vault Id"
  value         = data.azurerm_key_vault.key_vault.id
}

output "vault_uri" {
  description   = "Key vault URI"
  value         = data.azurerm_key_vault.key_vault.vault_uri
}

output "location" {
  description   = "Region / location of the key vault"
  value         = data.azurerm_key_vault.key_vault.location
}

output "name" {
  description  = "Name of the key vault"
  value = var.provision ? azurerm_key_vault.key_vault[0].name : local.key_vault_name
}
