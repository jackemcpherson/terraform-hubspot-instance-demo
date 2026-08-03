variable "forms" {
  type = map(object({
    name = string
    email = optional(object({
      label                  = optional(string, "Email address")
      description            = optional(string, "Contact email")
      placeholder            = optional(string, "name@example.com")
      required               = optional(bool, true)
      blocked_email_domains  = optional(list(string), [])
      use_default_block_list = optional(bool, true)
    }), {})
    configuration = optional(object({
      language                         = optional(string, "en")
      allow_link_to_reset_known_values = optional(bool, false)
      pre_populate_known_values        = optional(bool, false)
      recaptcha_enabled                = optional(bool, true)
      thank_you_text                   = optional(string, "Thank you")
    }), {})
    display_options = optional(object({
      submit_button_text = optional(string, "Submit")
      style = optional(object({
        label_text_size          = optional(string, "13px")
        label_text_color         = optional(string, "#33475b")
        legal_consent_text_size  = optional(string, "12px")
        legal_consent_text_color = optional(string, "#33475b")
        help_text_size           = optional(string, "11px")
        help_text_color          = optional(string, "#516f90")
        font_family              = optional(string, "Arial, sans-serif")
        background_width         = optional(string, "100%")
        submit_font_color        = optional(string, "#ffffff")
        submit_alignment         = optional(string, "left")
        submit_size              = optional(string, "12px 24px")
        submit_color             = optional(string, "#ff7a59")
      }), {})
    }), {})
  }))
  description = "Supported contact email Form definitions keyed by stable local identity."
  nullable    = false

  validation {
    condition     = alltrue([for key in keys(var.forms) : can(regex("^[a-z][a-z0-9_]*$", key))])
    error_message = "Form keys must be stable lowercase local identifiers."
  }

  validation {
    condition     = alltrue([for form in values(var.forms) : form.name != "" && trimspace(form.name) == form.name])
    error_message = "Every form name must be nonblank and have no surrounding whitespace."
  }

  validation {
    condition     = length(distinct([for form in values(var.forms) : form.name])) == length(var.forms)
    error_message = "Form names must be unique within one module instance."
  }
}
