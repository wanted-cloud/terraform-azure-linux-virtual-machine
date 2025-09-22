resource "azurerm_resource_group" "this" {
  name     = "rg-linux-vm-advanced-full-example"
  location = "East US 2"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-advanced-full-example"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_subnet" "primary" {
  name                 = "subnet-primary"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["192.168.1.0/24"]

  depends_on = [azurerm_virtual_network.this]
}

resource "azurerm_subnet" "secondary" {
  name                 = "subnet-secondary"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["192.168.2.0/24"]

  depends_on = [azurerm_virtual_network.this]
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-advanced-full-example"
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

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_public_ip" "this" {
  name                = "pip-advanced-full-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                = "Standard"
  zones              = ["1"]

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_network_interface" "this" {
  name                = "nic-advanced-full-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.primary.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.1.10"
    public_ip_address_id          = azurerm_public_ip.this.id
    primary                       = true
  }

  ip_configuration {
    name                          = "secondary"
    subnet_id                     = azurerm_subnet.secondary.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  depends_on = [azurerm_subnet.primary, azurerm_subnet.secondary]
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_proximity_placement_group" "this" {
  name                = "ppg-advanced-full-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [azurerm_resource_group.this]
}

module "linux_virtual_machine" {
  depends_on = [azurerm_resource_group.this, azurerm_network_interface.this, azurerm_proximity_placement_group.this]
  source = "../.."

  name                = "vm-advanced-full-example"
  resource_group_name = azurerm_resource_group.this.name
  location           = azurerm_resource_group.this.location
  size               = "Standard_E4s_v5"
  network_interface_ids = [azurerm_network_interface.this.id]

  admin_username = "azureuser"
  admin_password = "ComplexP@ssw0rd123!"
  disable_password_authentication = false

  priority                   = "Regular"
  provision_vm_agent        = true
  allow_extension_operations = true

  encryption_at_host_enabled = true
  secure_boot_enabled       = true
  vtpm_enabled             = true

  patch_mode            = "AutomaticByPlatform"
  patch_assessment_mode = "AutomaticByPlatform"

  proximity_placement_group_id = azurerm_proximity_placement_group.this.id

  zones = ["1"]

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Advanced Full VM Example</h1>" > /var/www/html/index.html
  EOF
  )

  boot_diagnostics = {
    storage_account_uri = null
  }

  identity = {
    type = "SystemAssigned"
  }

  additional_capabilities = {
    ultra_ssd_enabled = false
  }

  termination_notification = {
    enabled = true
    timeout = "PT10M"
  }

  os_disk = {
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_size_gb          = 128
    write_accelerator_enabled = false
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Environment          = "AdvancedFull"
    Purpose             = "CompleteTesting"
    ManagedBy           = "Terraform"
    CostCenter          = "IT-Infrastructure"
    Owner               = "DevOps-Team"
    Project             = "LinuxVMModule"
    DeploymentType      = "Example"
    SecurityLevel       = "High"
    BackupRequired      = "Yes"
    MonitoringEnabled   = "Yes"
  }
}