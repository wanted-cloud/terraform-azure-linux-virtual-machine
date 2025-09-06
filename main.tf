/*
 * # wanted-cloud/terraform-azure-linux-virtual-machine
 * 
 * Terraform building block managing Linux based Virtual Machine resource with its dependecies.
 */

resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.name
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  size                            = var.size
  network_interface_ids           = var.network_interface_ids
  allow_extension_operations      = var.allow_extension_operations
  disable_password_authentication = var.disable_password_authentication
  encryption_at_host_enabled      = var.encryption_at_host_enabled
  provision_vm_agent              = var.provision_vm_agent
  secure_boot_enabled             = var.secure_boot_enabled
  vtpm_enabled                    = var.vtpm_enabled

  extensions_time_budget       = var.extensions_time_budget != "" ? var.extensions_time_budget : null
  patch_assessment_mode        = var.patch_assessment_mode != "" ? var.patch_assessment_mode : null
  patch_mode                   = var.patch_mode != "" ? var.patch_mode : null
  max_bid_price                = var.max_bid_price != "" ? var.max_bid_price : null
  platform_fault_domain        = var.platform_fault_domain != "" ? var.platform_fault_domain : null
  proximity_placement_group_id = var.proximity_placement_group_id != "" ? var.proximity_placement_group_id : null
  reboot_setting               = var.reboot_setting != "" ? var.reboot_setting : null

  zone               = length(var.zones) > 0 ? var.zones : null
  os_managed_disk_id = var.os_managed_disk_id != "" ? var.os_managed_disk_id : null

  source_image_id = var.source_image_id != "" ? var.source_image_id : null

  computer_name                = var.computer_name != "" ? var.computer_name : null
  availability_set_id          = var.availability_set_id != "" ? var.availability_set_id : null
  license_type                 = var.license_type != "" ? var.license_type : null
  custom_data                  = var.custom_data != "" ? var.custom_data : null
  user_data                    = var.user_data != "" ? var.user_data : null
  dedicated_host_id            = var.dedicated_host_id != "" ? var.dedicated_host_id : null
  dedicated_host_group_id      = var.dedicated_host_group_id != "" ? var.dedicated_host_group_id : null
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id != "" ? var.virtual_machine_scale_set_id : null

  disk_controller_type = var.disk_controller_type != "" ? var.disk_controller_type : null
  edge_zone            = var.edge_zone != "" ? var.edge_zone : null
  eviction_policy      = var.eviction_policy != "" ? var.eviction_policy : null

  admin_username = var.admin_username != "" ? var.admin_username : null
  admin_password = var.admin_password != "" ? var.admin_password : null

  tags = merge(local.metadata.tags, var.tags)


  dynamic "identity" {
    for_each = var.identity_type != "" ? [var.identity_type] : []
    content {
      type         = identity.value
      identity_ids = var.user_assigned_identity_ids
    }
  }

  dynamic "os_disk" {
    for_each = var.os_managed_disk_id == "" ? [var.os_disk] : []
    content {
      caching                          = os_disk.value.caching
      storage_account_type             = os_disk.value.storage_account_type
      disk_encryption_set_id           = os_disk.value.disk_encryption_set_id
      disk_size_gb                     = os_disk.value.disk_size_gb
      secure_vm_disk_encryption_set_id = os_disk.value.secure_vm_disk_encryption_set_id
      security_encryption_type         = var.os_disk.security_encryption_type != "" ? var.os_disk.security_encryption_type : null
      write_accelerator_enabled        = var.os_disk.write_accelerator_enabled != "" ? var.os_disk.write_accelerator_enabled : null
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_reference != null ? [var.source_image_reference] : []
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_linux_virtual_machine"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_linux_virtual_machine"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_linux_virtual_machine"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_linux_virtual_machine"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}