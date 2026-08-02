# CRM schema module

Creates keyed HubSpot property groups and ordinary non-sensitive properties for
exactly one CRM object type. Group, property, and option map keys are immutable
remote names or CRM record values; labels remain editable presentation values.
The module derives HubSpot storage/editor pairs from `text` and `select` and has
no raw escape hatch.

```hcl
module "contact_schema" {
  source = "./modules/crm-schema"

  object_type = "contacts"
  groups = {
    customer_context = { label = "Customer context" }
  }
  properties = {
    customer_summary = {
      label = "Customer summary"
      group = "customer_context"
    }
    customer_tier = {
      label = "Customer tier"
      group = "customer_context"
      kind  = "select"
      options = {
        standard = { label = "Standard" }
        premium  = { label = "Premium" }
      }
    }
  }
}
```

Property references create groups before properties and archive properties before
groups. Teardown is archival; option removal does not migrate CRM record values.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_hubspot"></a> [hubspot](#requirement\_hubspot) | >= 0.2.0, < 0.3.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hubspot"></a> [hubspot](#provider\_hubspot) | >= 0.2.0, < 0.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hubspot_property.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/property) | resource |
| [hubspot_property_group.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/property_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_groups"></a> [groups](#input\_groups) | Property groups keyed by immutable HubSpot internal name. | <pre>map(object({<br/>    label         = string<br/>    display_order = optional(number, -1)<br/>  }))</pre> | n/a | yes |
| <a name="input_object_type"></a> [object\_type](#input\_object\_type) | Exact HubSpot CRM object type receiving this CRM property schema. | `string` | n/a | yes |
| <a name="input_properties"></a> [properties](#input\_properties) | Ordinary non-sensitive properties keyed by immutable HubSpot internal name. | <pre>map(object({<br/>    label         = string<br/>    group         = string<br/>    kind          = optional(string, "text")<br/>    description   = optional(string, "")<br/>    display_order = optional(number, -1)<br/>    form_field    = optional(bool, false)<br/>    hidden        = optional(bool, false)<br/>    options = optional(map(object({<br/>      label         = string<br/>      description   = optional(string, "")<br/>      display_order = optional(number, -1)<br/>      hidden        = optional(bool, false)<br/>    })), {})<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_groups"></a> [groups](#output\_groups) | Canonical property-group identities keyed by immutable name. |
| <a name="output_properties"></a> [properties](#output\_properties) | Canonical property identities keyed by immutable name. |
<!-- END_TF_DOCS -->
