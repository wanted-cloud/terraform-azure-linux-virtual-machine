<!-- BEGIN_TF_DOCS -->
# wanted-cloud/terraform-azure-linux-virtual-machine

Terraform building block managing Linux based Virtual Machine resource with its dependecies.

## Table of contents

- [Requirements](#requirements)
- [Providers](#providers)
- [Variables](#inputs)
- [Outputs](#outputs)
- [Resources](#resources)
- [Usage](#usage)
- [Contributing](#contributing)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>=4.20.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>=4.20.0)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the Azure virtual machine resource.

Type: `string`

### <a name="input_os_disk"></a> [os\_disk](#input\_os\_disk)

Description: n/a

Type:

```hcl
object({
    caching                          = string
    name                             = optional(string, "")
    storage_account_type             = optional(string, "")
    disk_encryption_set_id           = optional(string, "")
    disk_size_gb                     = optional(number, 128)
    secure_vm_disk_encryption_set_id = optional(string, "")
    security_encryption_type         = optional(string, "")
    write_accelerator_enabled        = optional(bool, false)
  })
```

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Name of the resource group in which the Azure virtual machine will be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password)

Description: The password for the admin user.

Type: `string`

Default: `""`

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: The name of the admin user.

Type: `string`

Default: `""`

### <a name="input_allow_extension_operations"></a> [allow\_extension\_operations](#input\_allow\_extension\_operations)

Description: Whether to allow extension operations.

Type: `bool`

Default: `true`

### <a name="input_availability_set_id"></a> [availability\_set\_id](#input\_availability\_set\_id)

Description: The ID of the availability set to which the virtual machine belongs.

Type: `string`

Default: `""`

### <a name="input_computer_name"></a> [computer\_name](#input\_computer\_name)

Description: The name of the computer (hostname) for the virtual machine.

Type: `string`

Default: `""`

### <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data)

Description: Base64 encoded custom data to provide to the cloud-init process.

Type: `string`

Default: `""`

### <a name="input_dedicated_host_group_id"></a> [dedicated\_host\_group\_id](#input\_dedicated\_host\_group\_id)

Description: The ID of the dedicated host group to which the virtual machine belongs.

Type: `string`

Default: `""`

### <a name="input_dedicated_host_id"></a> [dedicated\_host\_id](#input\_dedicated\_host\_id)

Description: The ID of the dedicated host on which the virtual machine will be placed.

Type: `string`

Default: `""`

### <a name="input_disable_password_authentication"></a> [disable\_password\_authentication](#input\_disable\_password\_authentication)

Description: Whether to disable password authentication.

Type: `bool`

Default: `false`

### <a name="input_disk_controller_type"></a> [disk\_controller\_type](#input\_disk\_controller\_type)

Description: The type of disk controller to use for the virtual machine.

Type: `string`

Default: `""`

### <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone)

Description: The Azure edge zone in which the virtual machine will be created.

Type: `string`

Default: `""`

### <a name="input_encryption_at_host_enabled"></a> [encryption\_at\_host\_enabled](#input\_encryption\_at\_host\_enabled)

Description: Whether to enable encryption at host.

Type: `bool`

Default: `false`

### <a name="input_eviction_policy"></a> [eviction\_policy](#input\_eviction\_policy)

Description: The eviction policy for the virtual machine.

Type: `string`

Default: `""`

### <a name="input_extensions_time_budget"></a> [extensions\_time\_budget](#input\_extensions\_time\_budget)

Description: The time budget for extensions to complete.

Type: `string`

Default: `"PT1H30M"`

### <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type)

Description: Type of identity to use for the Azure service plan.

Type: `string`

Default: `""`

### <a name="input_license_type"></a> [license\_type](#input\_license\_type)

Description: The license type for the virtual machine.

Type: `string`

Default: `""`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resource group in which the Azure virtual machine will be created, if not set it will be the same as the resource group.

Type: `string`

Default: `""`

### <a name="input_max_bid_price"></a> [max\_bid\_price](#input\_max\_bid\_price)

Description: The maximum bid price for the virtual machine.

Type: `string`

Default: `"-1"`

### <a name="input_metadata"></a> [metadata](#input\_metadata)

Description: Metadata definitions for the module, this is optional construct allowing override of the module defaults defintions of validation expressions, error messages, resource timeouts and default tags.

Type:

```hcl
object({
    resource_timeouts = optional(
      map(
        object({
          create = optional(string, "30m")
          read   = optional(string, "5m")
          update = optional(string, "30m")
          delete = optional(string, "30m")
        })
      ), {}
    )
    tags                     = optional(map(string), {})
    validator_error_messages = optional(map(string), {})
    validator_expressions    = optional(map(string), {})
  })
```

Default: `{}`

### <a name="input_network_interface_ids"></a> [network\_interface\_ids](#input\_network\_interface\_ids)

Description: List of network interface IDs to associate with the virtual machine.

Type: `list(string)`

Default: `[]`

### <a name="input_os_managed_disk_id"></a> [os\_managed\_disk\_id](#input\_os\_managed\_disk\_id)

Description: The ID of the OS managed disk.

Type: `string`

Default: `""`

### <a name="input_patch_assessment_mode"></a> [patch\_assessment\_mode](#input\_patch\_assessment\_mode)

Description: The mode for patch assessment.

Type: `string`

Default: `"ImageDefault"`

### <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode)

Description: The mode for patching.

Type: `string`

Default: `"ImageDefault"`

### <a name="input_platform_fault_domain"></a> [platform\_fault\_domain](#input\_platform\_fault\_domain)

Description: The platform fault domain for the virtual machine.

Type: `string`

Default: `"Regular"`

### <a name="input_provision_vm_agent"></a> [provision\_vm\_agent](#input\_provision\_vm\_agent)

Description: Whether to provision the VM agent.

Type: `bool`

Default: `true`

### <a name="input_proximity_placement_group_id"></a> [proximity\_placement\_group\_id](#input\_proximity\_placement\_group\_id)

Description: The ID of the proximity placement group to which the virtual machine belongs.

Type: `string`

Default: `""`

### <a name="input_reboot_setting"></a> [reboot\_setting](#input\_reboot\_setting)

Description: The reboot setting for the virtual machine.

Type: `string`

Default: `""`

### <a name="input_secure_boot_enabled"></a> [secure\_boot\_enabled](#input\_secure\_boot\_enabled)

Description: Whether to enable secure boot.

Type: `bool`

Default: `false`

### <a name="input_size"></a> [size](#input\_size)

Description: The size of the Virtual Machine.

Type: `string`

Default: `"Standard_D2"`

### <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id)

Description: The ID of the source image to use for the virtual machine.

Type: `string`

Default: `""`

### <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference)

Description: The source image reference for the virtual machine.

Type:

```hcl
object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
```

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags to be applied to the Azure virtual machine.

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_identity_ids"></a> [user\_assigned\_identity\_ids](#input\_user\_assigned\_identity\_ids)

Description: List of user assigned identity IDs for the Azure service plan.

Type: `list(string)`

Default: `[]`

### <a name="input_user_data"></a> [user\_data](#input\_user\_data)

Description: The user data to provide to the virtual machine.

Type: `string`

Default: `""`

### <a name="input_virtual_machine_scale_set_id"></a> [virtual\_machine\_scale\_set\_id](#input\_virtual\_machine\_scale\_set\_id)

Description: The ID of the virtual machine scale set to which the virtual machine belongs.

Type: `string`

Default: `""`

### <a name="input_vtpm_enabled"></a> [vtpm\_enabled](#input\_vtpm\_enabled)

Description: Whether to enable vTPM.

Type: `bool`

Default: `false`

### <a name="input_zones"></a> [zones](#input\_zones)

Description: The list of availability zones in which the virtual machine will be created.

Type: `list(string)`

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_virtual_machine"></a> [virtual\_machine](#output\_virtual\_machine)

Description: n/a

## Resources

The following resources are used by this module:

- [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

## Usage

> For more detailed examples navigate to `examples` folder of this repository.

Module was also published via Terraform Registry and can be used as a module from the registry.

```hcl
module "example" {
  source  = "wanted-cloud/..."
  version = "x.y.z"
}
```

### Basic usage example

The minimal usage for the module is as follows:

```hcl
module "template" {
    source = "../.."
}
```
## Contributing

_Contributions are welcomed and must follow [Code of Conduct](https://github.com/wanted-cloud/.github?tab=coc-ov-file) and common [Contributions guidelines](https://github.com/wanted-cloud/.github/blob/main/docs/CONTRIBUTING.md)._

> If you'd like to report security issue please follow [security guidelines](https://github.com/wanted-cloud/.github?tab=security-ov-file).
---
<sup><sub>_2025 &copy; All rights reserved - WANTED.solutions s.r.o._</sub></sup>
<!-- END_TF_DOCS -->