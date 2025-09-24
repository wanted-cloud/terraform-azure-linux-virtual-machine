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

  priority                                               = var.priority
  bypass_platform_safety_checks_on_user_schedule_enabled = var.bypass_platform_safety_checks_on_user_schedule_enabled
  capacity_reservation_group_id                          = var.capacity_reservation_group_id != "" ? var.capacity_reservation_group_id : null

  extensions_time_budget       = var.extensions_time_budget != "" ? var.extensions_time_budget : null
  patch_assessment_mode        = var.patch_assessment_mode != "" ? var.patch_assessment_mode : null
  patch_mode                   = var.patch_mode != "" ? var.patch_mode : null
  max_bid_price                = var.max_bid_price != "" ? var.max_bid_price : null
  platform_fault_domain        = var.platform_fault_domain != "" ? var.platform_fault_domain : null
  proximity_placement_group_id = var.proximity_placement_group_id != "" ? var.proximity_placement_group_id : null
  reboot_setting               = var.reboot_setting != "" ? var.reboot_setting : null

  zone               = length(var.zones) > 0 ? var.zones[0] : null
  os_managed_disk_id = var.os_managed_disk_id != "" ? var.os_managed_disk_id : null
  source_image_id    = var.source_image_id != "" ? var.source_image_id : null

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

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key
    content {
      public_key = admin_ssh_key.value.public_key
      username   = admin_ssh_key.value.username
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics != null ? [var.boot_diagnostics] : []
    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.additional_capabilities != null ? [var.additional_capabilities] : []
    content {
      ultra_ssd_enabled   = additional_capabilities.value.ultra_ssd_enabled
      hibernation_enabled = additional_capabilities.value.hibernation_enabled
    }
  }

  dynamic "plan" {
    for_each = var.plan != null ? [var.plan] : []
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  dynamic "gallery_application" {
    for_each = var.gallery_application
    content {
      version_id                                  = gallery_application.value.version_id
      automatic_upgrade_enabled                   = gallery_application.value.automatic_upgrade_enabled
      configuration_blob_uri                      = gallery_application.value.configuration_blob_uri != "" ? gallery_application.value.configuration_blob_uri : null
      order                                       = gallery_application.value.order
      tag                                         = gallery_application.value.tag != "" ? gallery_application.value.tag : null
      treat_failure_as_deployment_failure_enabled = gallery_application.value.treat_failure_as_deployment_failure_enabled
    }
  }

  dynamic "secret" {
    for_each = var.secret
    content {
      key_vault_id = secret.value.key_vault_id

      dynamic "certificate" {
        for_each = secret.value.certificate
        content {
          url = certificate.value.url
        }
      }
    }
  }

  dynamic "termination_notification" {
    for_each = var.termination_notification != null ? [var.termination_notification] : []
    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  dynamic "os_image_notification" {
    for_each = var.os_image_notification != null ? [var.os_image_notification] : []
    content {
      timeout = os_image_notification.value.timeout
    }
  }

  dynamic "os_disk" {
    for_each = var.os_managed_disk_id == "" ? [var.os_disk] : []
    content {
      caching                          = os_disk.value.caching
      storage_account_type             = os_disk.value.storage_account_type != "" ? os_disk.value.storage_account_type : null
      name                             = os_disk.value.name != "" ? os_disk.value.name : null
      disk_encryption_set_id           = os_disk.value.disk_encryption_set_id != "" ? os_disk.value.disk_encryption_set_id : null
      disk_size_gb                     = os_disk.value.disk_size_gb
      secure_vm_disk_encryption_set_id = os_disk.value.secure_vm_disk_encryption_set_id != "" ? os_disk.value.secure_vm_disk_encryption_set_id : null
      security_encryption_type         = os_disk.value.security_encryption_type != "" ? os_disk.value.security_encryption_type : null
      write_accelerator_enabled        = os_disk.value.write_accelerator_enabled

      dynamic "diff_disk_settings" {
        for_each = os_disk.value.diff_disk_settings != null ? [os_disk.value.diff_disk_settings] : []
        content {
          option    = diff_disk_settings.value.option
          placement = diff_disk_settings.value.placement
        }
      }
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