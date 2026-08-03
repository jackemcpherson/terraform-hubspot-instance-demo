# Manages supported contact email Form definitions through stable local keys.
resource "hubspot_form_definition" "this" {
  for_each = var.forms

  name = each.value.name

  field_groups = [{
    fields = [{
      label                  = each.value.email.label
      description            = each.value.email.description
      placeholder            = each.value.email.placeholder
      required               = each.value.email.required
      blocked_email_domains  = each.value.email.blocked_email_domains
      use_default_block_list = each.value.email.use_default_block_list
    }]
  }]

  configuration = {
    language                         = each.value.configuration.language
    allow_link_to_reset_known_values = each.value.configuration.allow_link_to_reset_known_values
    pre_populate_known_values        = each.value.configuration.pre_populate_known_values
    recaptcha_enabled                = each.value.configuration.recaptcha_enabled
    thank_you_text                   = each.value.configuration.thank_you_text
  }

  display_options = {
    submit_button_text = each.value.display_options.submit_button_text
    style = {
      label_text_size          = each.value.display_options.style.label_text_size
      label_text_color         = each.value.display_options.style.label_text_color
      legal_consent_text_size  = each.value.display_options.style.legal_consent_text_size
      legal_consent_text_color = each.value.display_options.style.legal_consent_text_color
      help_text_size           = each.value.display_options.style.help_text_size
      help_text_color          = each.value.display_options.style.help_text_color
      font_family              = each.value.display_options.style.font_family
      background_width         = each.value.display_options.style.background_width
      submit_font_color        = each.value.display_options.style.submit_font_color
      submit_alignment         = each.value.display_options.style.submit_alignment
      submit_size              = each.value.display_options.style.submit_size
      submit_color             = each.value.display_options.style.submit_color
    }
  }
}
