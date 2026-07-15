# CRM schema module

Creates one HubSpot property group and a keyed set of ordinary non-sensitive
properties for a single CRM object type. Property and enumeration-option map keys
are immutable CRM identities; labels remain editable presentation values.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_hubspot"></a> [hubspot](#requirement\_hubspot) | = 0.1.0-alpha.1 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hubspot"></a> [hubspot](#provider\_hubspot) | = 0.1.0-alpha.1 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| hubspot_property.this | resource |
| hubspot_property_group.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_group"></a> [group](#input\_group) | Property group owned by this module. | <pre>object({<br/>    name          = string<br/>    label         = string<br/>    display_order = number<br/>  })</pre> | n/a | yes |
| <a name="input_object_type"></a> [object\_type](#input\_object\_type) | HubSpot CRM object type receiving this schema. | `string` | n/a | yes |
| <a name="input_properties"></a> [properties](#input\_properties) | Ordinary non-sensitive Free-tier property definitions keyed by immutable name. | <pre>map(object({<br/>    label         = string<br/>    type          = string<br/>    field_type    = string<br/>    description   = optional(string, "")<br/>    display_order = number<br/>    form_field    = optional(bool, false)<br/>    hidden        = optional(bool, false)<br/>    options = optional(map(object({<br/>      label         = string<br/>      description   = optional(string, "")<br/>      display_order = optional(number, -1)<br/>      hidden        = optional(bool, false)<br/>    })))<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_group"></a> [group](#output\_group) | Canonical property-group identity. |
| <a name="output_properties"></a> [properties](#output\_properties) | Canonical property identities keyed by immutable name. |
<!-- END_TF_DOCS -->
