variable "object_type" {
  type        = string
  description = "Exact HubSpot CRM object type receiving this CRM property schema."
  nullable    = false

  validation {
    condition     = contains(["contacts", "companies", "deals", "tickets"], var.object_type)
    error_message = "object_type must be contacts, companies, deals, or tickets."
  }
}

variable "groups" {
  type = map(object({
    label         = string
    display_order = optional(number, -1)
  }))
  description = "Property groups keyed by immutable HubSpot internal name."
  nullable    = false

  validation {
    condition     = alltrue([for name in keys(var.groups) : can(regex("^[a-z][a-z0-9_]*$", name))])
    error_message = "Group keys must be stable lowercase HubSpot identifiers."
  }

  validation {
    condition     = alltrue([for group in values(var.groups) : trimspace(group.label) != ""])
    error_message = "Every group label must be nonblank."
  }

  validation {
    condition = alltrue([
      for group in values(var.groups) :
      group.display_order >= -1 && group.display_order == floor(group.display_order)
    ])
    error_message = "Every group display_order must be an integer greater than or equal to -1."
  }
}

variable "properties" {
  type = map(object({
    label         = string
    group         = string
    kind          = optional(string, "text")
    description   = optional(string, "")
    display_order = optional(number, -1)
    form_field    = optional(bool, false)
    hidden        = optional(bool, false)
    options = optional(map(object({
      label         = string
      description   = optional(string, "")
      display_order = optional(number, -1)
      hidden        = optional(bool, false)
    })), {})
  }))
  description = "Ordinary non-sensitive properties keyed by immutable HubSpot internal name."
  nullable    = false

  validation {
    condition     = alltrue([for name in keys(var.properties) : can(regex("^[a-z][a-z0-9_]*$", name))])
    error_message = "Property keys must be stable lowercase HubSpot identifiers."
  }

  validation {
    condition     = alltrue([for property in values(var.properties) : trimspace(property.label) != ""])
    error_message = "Every property label must be nonblank."
  }

  validation {
    condition     = alltrue([for property in values(var.properties) : contains(["text", "select"], property.kind)])
    error_message = "Every property kind must be text or select."
  }

  validation {
    condition = alltrue([
      for property in values(var.properties) :
      property.display_order >= -1 && property.display_order == floor(property.display_order)
    ])
    error_message = "Every property display_order must be an integer greater than or equal to -1."
  }

  validation {
    condition = alltrue([
      for property in values(var.properties) :
      property.kind == "select" ? length(property.options) > 0 : length(property.options) == 0
    ])
    error_message = "Text properties must have no options; select properties require at least one option."
  }

  validation {
    condition = alltrue(flatten([
      for property in values(var.properties) : [
        for name in keys(property.options) : can(regex("^[a-z][a-z0-9_]*$", name))
      ]
    ]))
    error_message = "Option keys must be stable lowercase HubSpot identifiers."
  }

  validation {
    condition = alltrue(flatten([
      for property in values(var.properties) : [
        for option in values(property.options) : trimspace(option.label) != ""
      ]
    ]))
    error_message = "Every option label must be nonblank."
  }

  validation {
    condition = alltrue(flatten([
      for property in values(var.properties) : [
        for option in values(property.options) :
        option.display_order >= -1 && option.display_order == floor(option.display_order)
      ]
    ]))
    error_message = "Every option display_order must be an integer greater than or equal to -1."
  }
}
