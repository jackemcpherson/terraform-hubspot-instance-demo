# Account membership module

Creates HubSpot account memberships with `for_each` over stable local keys. Each
entry requires an email address and an explicit welcome-email decision. Removal
is blocked by default and must be deliberately enabled for disposable accounts.

```hcl
module "operators" {
  source = "./modules/account-membership"

  memberships = {
    release_operator = {
      email              = var.release_operator_email
      first_name         = "Release"
      last_name          = "Operator"
      send_welcome_email = false
      allow_removal      = true
    }
  }
}
```

Map keys are Terraform/OpenTofu identity. Email and the welcome-email choice are
replacement-only; changing either creates a replacement membership. Configured
names describe HubSpot's global user identity, not a portal-local CRM profile,
and HubSpot blocks name updates until the user activates. The provider refuses
name updates while the current membership has role or team assignments because
HubSpot does not document omission semantics for those fields.

Destroy requires both `allow_removal = true` and a current non-Super-Admin
membership whose exact Settings ID and email still match. Removing the resource
from state is the documented alternative when membership removal is unwanted.

OpenTofu is the primary engine. Terraform remains supported through the same
provider protocol contract.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_hubspot"></a> [hubspot](#requirement\_hubspot) | >= 0.5.0, < 0.6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hubspot"></a> [hubspot](#provider\_hubspot) | >= 0.5.0, < 0.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hubspot_account_membership.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/account_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_memberships"></a> [memberships](#input\_memberships) | HubSpot account memberships keyed by stable local identity. | <pre>map(object({<br/>    email              = string<br/>    first_name         = optional(string)<br/>    last_name          = optional(string)<br/>    send_welcome_email = bool<br/>    allow_removal      = optional(bool, false)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ids"></a> [ids](#output\_ids) | Canonical HubSpot Settings user IDs keyed by stable local membership identity. |
| <a name="output_super_admin"></a> [super\_admin](#output\_super\_admin) | Observed Super Admin status keyed by stable local membership identity. |
<!-- END_TF_DOCS -->
