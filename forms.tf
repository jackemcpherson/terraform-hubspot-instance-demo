module "forms" {
  source = "./modules/form-definition"

  forms = {
    contact_us = {
      name = "ns_contact_us"
      email = {
        label       = "Work email"
        description = "How Northstar can follow up"
        placeholder = "you@company.example"
        required    = true
      }
      configuration = {
        recaptcha_enabled = true
        thank_you_text    = "Thanks — Northstar will be in touch."
      }
      display_options = {
        submit_button_text = "Contact Northstar"
        style = {
          submit_alignment = "center"
          submit_color     = "#00a4bd"
        }
      }
    }
  }
}
