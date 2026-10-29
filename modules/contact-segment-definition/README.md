# Contact Segment Definition Module

Manages HubSpot Contact segment definitions with `for_each` over stable local
keys. HubSpot-generated ILS list IDs remain the remote and import identities.
Adding or removing one key never re-addresses the others.

```hcl
module "contact_segments" {
  source = "./modules/contact-segment-definition"

  definitions = {
    all_contacts = {
      name            = "All contacts"
      processing_type = "manual"
    }
    completed_onboarding = {
      name            = "Completed onboarding"
      processing_type = "dynamic"
      filter_groups = [{
        filters = [{
          property      = "ns_onboarding_status"
          operator      = "is_equal_to"
          property_kind = "select"
          value         = "complete"
        }]
      }]
    }
  }
}
```

Each `filter_groups` entry is an OR branch. Its `filters` are AND predicates on
existing Contact property names. Equality operators need `property_kind`
(`text` or `select`) and one value. `is_known` and `is_not_known` take neither.
Manual definitions take no filter groups.

Names update in place. Dynamic filter changes update in place. Snapshot filter
changes and processing-type changes replace the definition. The module manages
definitions only, never memberships, derived size, or Contact record values.
OpenTofu is the primary engine. Terraform uses the same provider protocol.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_hubspot"></a> [hubspot](#requirement\_hubspot) | >= 0.8.0, < 0.9.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hubspot"></a> [hubspot](#provider\_hubspot) | >= 0.8.0, < 0.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hubspot_contact_segment.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/contact_segment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_definitions"></a> [definitions](#input\_definitions) | Contact segment definitions keyed by stable local identity. Each filter group is an OR branch of AND predicates on existing Contact property names. | <pre>map(object({<br/>    name            = string<br/>    processing_type = string<br/>    filter_groups = optional(list(object({<br/>      filters = list(object({<br/>        property      = string<br/>        operator      = string<br/>        property_kind = optional(string)<br/>        value         = optional(string)<br/>      }))<br/>    })), [])<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ids"></a> [ids](#output\_ids) | Generated HubSpot ILS list IDs keyed by stable local Contact segment identity. |
<!-- END_TF_DOCS -->
