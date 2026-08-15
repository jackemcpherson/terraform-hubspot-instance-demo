# CRM user profile module

Manages selected CRM profile properties with `for_each` over stable local keys.
Each entry joins one canonical Settings user ID to its account-specific CRM
user ID. Null properties remain unmanaged.

```hcl
module "operator_profiles" {
  source = "./modules/crm-user-profile"

  profiles = {
    release_operator = {
      account_membership_id = module.operators.ids["release_operator"]
      job_title             = "Release Engineer"
      availability_status   = "available"
      time_zone             = "Australia/Melbourne"
      working_hours = [
        {
          days         = "MONDAY_TO_FRIDAY"
          start_minute = 540
          end_minute   = 1020
        }
      ]
    }
  }
}
```

The membership output creates the dependency. The profile stops management
without a remote write before membership removal during destroy. HubSpot
retains the profile values.

OpenTofu is the primary engine. Terraform uses the same provider protocol.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_hubspot"></a> [hubspot](#requirement\_hubspot) | >= 0.6.0, < 0.7.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hubspot"></a> [hubspot](#provider\_hubspot) | >= 0.6.0, < 0.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hubspot_crm_user_profile.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/crm_user_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | CRM user profiles keyed by stable local identity. | <pre>map(object({<br/>    account_membership_id = string<br/>    job_title             = optional(string)<br/>    availability_status   = optional(string)<br/>    time_zone             = optional(string)<br/>    working_hours = optional(set(object({<br/>      days         = string<br/>      start_minute = number<br/>      end_minute   = number<br/>    })))<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ids"></a> [ids](#output\_ids) | Canonical CRM user IDs keyed by stable local profile identity. |
<!-- END_TF_DOCS -->
