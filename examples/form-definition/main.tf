terraform {
  required_version = ">= 1.8, < 2.0"

  required_providers {
    hubspot = {
      source  = "jackemcpherson/hubspot"
      version = ">= 0.3.0, < 0.4.0"
    }
  }
}

module "contact_forms" {
  source = "../../modules/form-definition"

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

output "form_ids" {
  value = module.contact_forms.ids
}
