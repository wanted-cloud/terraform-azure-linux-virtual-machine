resource "azurerm_resource_group" "this" {
  name     = "rg-linux-vm-advanced-example"
  location = "North Europe"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-advanced-example"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_subnet" "this" {
  name                 = "subnet-advanced-example"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["172.16.1.0/24"]

  depends_on = [azurerm_virtual_network.this]
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-advanced-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_network_interface" "this" {
  name                = "nic-advanced-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.1.10"
  }

  depends_on = [azurerm_subnet.this]
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

module "linux_virtual_machine" {
  depends_on = [azurerm_resource_group.this, azurerm_network_interface.this]
  source = "../.."

  name                = "vm-advanced-example"
  resource_group_name = azurerm_resource_group.this.name
  location           = azurerm_resource_group.this.location
  size               = "Standard_D2s_v5"
  network_interface_ids = [azurerm_network_interface.this.id]

  admin_username = "azureuser"
  admin_password = "ComplexP@ssw0rd123!"
  disable_password_authentication = false

  encryption_at_host_enabled = true
  secure_boot_enabled       = true
  vtpm_enabled             = true

  boot_diagnostics = {
    storage_account_uri = null
  }

  identity = {
    type = "SystemAssigned"
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 64
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Environment = "Advanced"
    Purpose     = "Testing"
    ManagedBy   = "Terraform"
  }
}