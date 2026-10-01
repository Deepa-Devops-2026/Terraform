data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-keyvault-rg"
  location = var.location
}

resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  public_network_access_enabled = true

  rbac_authorization_enabled = true
}

resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "my-password"
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_role_assignment.kv_admin
  ]
}