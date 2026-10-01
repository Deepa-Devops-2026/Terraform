resource "azurerm_resource_group" "rg" {
name = "terraform--vm-rg"
location = var.location"
}

resource "azurerm_virtual_network" "vnet" {
name = "terraform-vm-vnet"
location = var.location
resource_group_name = azurerm_resource_group.rg.name
address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
name = "vm-subnet"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name

address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
name = "terraform-vm-pip"
location = var.location
resource_group_name = azurerm_resource_group.rg.name
allocation_method = "Static"
sku = "Standard"
}

resource "azurerm_network_security_group" "nsg" {
name = "terraform-vm-nsg"
location = var.location
resource_group_name = azurerm_resource_group.rg.name
security_rule{
name = "allow-ssh"
priority = "100"
direction = "Inound"
access = "Allow"
protocol = "Tcp"
source_port_range = "*"
destination_port_range = "22"
source_address_prefix = "*"
destination_address_prefix = "*"
}
}
resource "azurerm_network_interface_card" "nic" {
name = "terraform-vm-nic"
location = var.location
resource_group_name = azurerm_resource_group.rg.name
ip_configuration{
name = "internal"
subnet_id = azurerm_subnet.subnet.id
private_ip_address_allocation = "Dynamic"
public_ip_address_id = azure_public_ip.pip.id
}
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "terraform-linux-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("C:/Users/YOUR_USERNAME/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
