resource "azurerm_resource_group" "this" {
  name     = "rg-linux-vm-basic-example"
  location = "West Europe"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-basic-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_subnet" "this" {
  name                 = "subnet-basic-example"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [azurerm_virtual_network.this]
}

resource "azurerm_network_interface" "this" {
  name                = "nic-basic-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet.this]
}

module "linux_virtual_machine" {
  depends_on = [azurerm_resource_group.this, azurerm_network_interface.this]
  source = "../.."

  name                = "vm-basic-example"
  resource_group_name = azurerm_resource_group.this.name
  location           = azurerm_resource_group.this.location
  size               = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.this.id]

  admin_username = "azureuser"
  admin_password = "ComplexP@ssw0rd123!"
  disable_password_authentication = false

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}