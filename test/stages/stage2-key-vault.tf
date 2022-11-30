module "key_vault" {
  source = "./module"

  resource_group_name = module.resource_group.name
  sku_name            = "standard" 
}

module "read_vault" {
  source = "./module"

  resource_group_name = module.resource_group.name
  name                = module.key_vault.name
  provision           = false
}

output "vault_id" {
  value = module.read_vault.id
}

output "vault_name" {
  value = module.read_vault.name
}
