# Form definition module

Creates supported HubSpot contact email Form definitions with `for_each` over
stable local keys. Each entry requires a remote presentation name and can
override every supported email, validation, thank-you, submit, and style value.
Omitted values expand to the provider's complete conservative contract.

The module intentionally has no raw JSON or controls for arbitrary properties,
form types, consent, notifications, automation, contact creation, branding, or
submissions. It has no dependency on `crm-schema`: the built-in contacts
`email` Property definition is a semantic prerequisite supplied by HubSpot, not
an output this module creates.

```hcl
module "contact_forms" {
  source = "./modules/form-definition"

  forms = {
    customer_contact = {
      name = "Customer contact"
    }
    partner_contact = {
      name = "Partner contact"
      email = {
        label                 = "Partner email"
        placeholder           = "partner@example.com"
        blocked_email_domains = ["example.org"]
      }
      configuration = {
        thank_you_text = "Thank you for contacting our partner team"
      }
      display_options = {
        submit_button_text = "Contact partner team"
        style = {
          submit_alignment = "center"
          submit_color     = "#00a4bd"
        }
      }
    }
  }
}
```

Map keys are Terraform/OpenTofu identity; form names remain mutable
presentation. Renaming a key without state migration archives the old form and
creates a new generated ID. For an intentional key refactor, add an explicit
caller-side move before applying:

```hcl
moved {
  from = module.contact_forms.hubspot_form_definition.this["customer_contact"]
  to   = module.contact_forms.hubspot_form_definition.this["primary_contact"]
}
```

OpenTofu is the primary engine. Terraform remains supported through the same
provider protocol contract.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_hubspot"></a> [hubspot](#requirement\_hubspot) | >= 0.3.0, < 0.4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hubspot"></a> [hubspot](#provider\_hubspot) | >= 0.3.0, < 0.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hubspot_form_definition.this](https://registry.terraform.io/providers/jackemcpherson/hubspot/latest/docs/resources/form_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_forms"></a> [forms](#input\_forms) | Supported contact email Form definitions keyed by stable local identity. | <pre>map(object({<br/>    name = string<br/>    email = optional(object({<br/>      label                  = optional(string, "Email address")<br/>      description            = optional(string, "Contact email")<br/>      placeholder            = optional(string, "name@example.com")<br/>      required               = optional(bool, true)<br/>      blocked_email_domains  = optional(list(string), [])<br/>      use_default_block_list = optional(bool, true)<br/>    }), {})<br/>    configuration = optional(object({<br/>      language                         = optional(string, "en")<br/>      allow_link_to_reset_known_values = optional(bool, false)<br/>      pre_populate_known_values        = optional(bool, false)<br/>      recaptcha_enabled                = optional(bool, true)<br/>      thank_you_text                   = optional(string, "Thank you")<br/>    }), {})<br/>    display_options = optional(object({<br/>      submit_button_text = optional(string, "Submit")<br/>      style = optional(object({<br/>        label_text_size          = optional(string, "13px")<br/>        label_text_color         = optional(string, "#33475b")<br/>        legal_consent_text_size  = optional(string, "12px")<br/>        legal_consent_text_color = optional(string, "#33475b")<br/>        help_text_size           = optional(string, "11px")<br/>        help_text_color          = optional(string, "#516f90")<br/>        font_family              = optional(string, "Arial, sans-serif")<br/>        background_width         = optional(string, "100%")<br/>        submit_font_color        = optional(string, "#ffffff")<br/>        submit_alignment         = optional(string, "left")<br/>        submit_size              = optional(string, "12px 24px")<br/>        submit_color             = optional(string, "#ff7a59")<br/>      }), {})<br/>    }), {})<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ids"></a> [ids](#output\_ids) | Generated HubSpot form IDs keyed by stable local form identity. |
<!-- END_TF_DOCS -->