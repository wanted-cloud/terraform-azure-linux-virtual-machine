variable "name" {
  description = "Name of the Azure virtual machine resource."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which the Azure virtual machine will be created."
  type        = string
}

variable "location" {
  description = "Location of the resource group in which the Azure virtual machine will be created, if not set it will be the same as the resource group."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to be applied to the Azure virtual machine."
  type        = map(string)
  default     = {}
}

variable "size" {
  description = "The size of the Virtual Machine."
  type        = string
  default     = "Standard_D2"
}

variable "network_interface_ids" {
  description = "List of network interface IDs to associate with the virtual machine."
  type        = list(string)
  default     = []
}

variable "admin_password" {
  description = "The password for the admin user."
  type        = string
  default     = ""
}

variable "admin_username" {
  description = "The name of the admin user."
  type        = string
  default     = ""

}

variable "license_type" {
  description = "The license type for the virtual machine."
  type        = string
  default     = ""
}

variable "availability_set_id" {
  description = "The ID of the availability set to which the virtual machine belongs."
  type        = string
  default     = ""
}

variable "computer_name" {
  description = "The name of the computer (hostname) for the virtual machine."
  type        = string
  default     = ""
}

variable "custom_data" {
  description = "Base64 encoded custom data to provide to the cloud-init process."
  type        = string
  default     = ""
}

variable "dedicated_host_id" {
  description = "The ID of the dedicated host on which the virtual machine will be placed."
  type        = string
  default     = ""
}

variable "dedicated_host_group_id" {
  description = "The ID of the dedicated host group to which the virtual machine belongs."
  type        = string
  default     = ""
}

variable "disk_controller_type" {
  description = "The type of disk controller to use for the virtual machine."
  type        = string
  default     = ""
}

variable "edge_zone" {
  description = "The Azure edge zone in which the virtual machine will be created."
  type        = string
  default     = ""
}

variable "encryption_at_host_enabled" {
  description = "Whether to enable encryption at host."
  type        = bool
  default     = false
}

variable "eviction_policy" {
  description = "The eviction policy for the virtual machine."
  type        = string
  default     = ""
}

variable "extensions_time_budget" {
  description = "The time budget for extensions to complete."
  type        = string
  default     = "PT1H30M"
}

variable "disable_password_authentication" {
  description = "Whether to disable password authentication."
  type        = bool
  default     = false
}

variable "allow_extension_operations" {
  description = "Whether to allow extension operations."
  type        = bool
  default     = true
}

variable "identity_type" {
  description = "Type of identity to use for the Azure service plan."
  type        = string
  default     = ""
}

variable "user_assigned_identity_ids" {
  description = "List of user assigned identity IDs for the Azure service plan."
  type        = list(string)
  default     = []
}

variable "patch_assessment_mode" {
  description = "The mode for patch assessment."
  type        = string
  default     = "ImageDefault"
}

variable "patch_mode" {
  description = "The mode for patching."
  type        = string
  default     = "ImageDefault"
}

variable "max_bid_price" {
  description = "The maximum bid price for the virtual machine."
  type        = string
  default     = "-1"
}

variable "platform_fault_domain" {
  description = "The platform fault domain for the virtual machine."
  type        = string
  default     = "Regular"
}

variable "provision_vm_agent" {
  description = "Whether to provision the VM agent."
  type        = bool
  default     = true
}

variable "proximity_placement_group_id" {
  description = "The ID of the proximity placement group to which the virtual machine belongs."
  type        = string
  default     = ""
}

variable "reboot_setting" {
  description = "The reboot setting for the virtual machine."
  type        = string
  default     = ""
}

variable "secure_boot_enabled" {
  description = "Whether to enable secure boot."
  type        = bool
  default     = false
}

variable "source_image_id" {
  description = "The ID of the source image to use for the virtual machine."
  type        = string
  default     = ""
}

variable "zones" {
  description = "The list of availability zones in which the virtual machine will be created."
  type        = list(string)
  default     = []

}

variable "vtpm_enabled" {
  description = "Whether to enable vTPM."
  type        = bool
  default     = false
}

variable "virtual_machine_scale_set_id" {
  description = "The ID of the virtual machine scale set to which the virtual machine belongs."
  type        = string
  default     = ""
}

variable "source_image_reference" {
  description = "The source image reference for the virtual machine."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "os_managed_disk_id" {
  description = "The ID of the OS managed disk."
  type        = string
  default     = ""
}

variable "user_data" {
  description = "The user data to provide to the virtual machine."
  type        = string
  default     = ""
}

variable "os_disk" {

  type = object({
    caching                          = string
    name                             = optional(string, "")
    storage_account_type             = optional(string, "")
    disk_encryption_set_id           = optional(string, "")
    disk_size_gb                     = optional(number, 128)
    secure_vm_disk_encryption_set_id = optional(string, "")
    security_encryption_type         = optional(string, "")
    write_accelerator_enabled        = optional(bool, false)
  })
}