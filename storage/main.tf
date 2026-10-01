resource "azurerm_resource_group" "rg" {
  name     = "terraform-storage-rg"
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version          = "TLS1_2"

  public_network_access_enabled = true
}

resource "azurerm_storage_container" "container" {
  name                  = "terraform-container"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}