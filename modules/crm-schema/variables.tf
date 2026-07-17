variable "object_type" {
  type        = string
  description = "HubSpot CRM object type receiving this schema."
  nullable    = false

  validation {
    condition     = contains(["contacts", "companies", "deals", "tickets"], var.object_type)
    error_message = "object_type must be contacts, companies, deals, or tickets for this demo."
  }
}

variable "group" {
  type = object({
    name          = string
    label         = string
    display_order = number
  })
  description = "Property group owned by this module."
  nullable    = false

  validation {
    condition     = can(regex("^[a-z][a-z0-9_]*$", var.group.name))
    error_message = "group.name must be a stable lowercase HubSpot identifier."
  }

  validation {
    condition     = trimspace(var.group.label) != ""
    error_message = "group.label must not be empty."
  }

  validation {
    condition     = var.group.display_order >= -1 && var.group.display_order == floor(var.group.display_order)
    error_message = "group.display_order must be an integer greater than or equal to -1."
  }
}

variable "properties" {
  type = map(object({
    label         = string
    type          = string
    field_type    = string
    description   = optional(string, "")
    display_order = number
    form_field    = optional(bool, false)
    hidden        = optional(bool, false)
    options = optional(map(object({
      label         = string
      description   = optional(string, "")
      display_order = optional(number, -1)
      hidden        = optional(bool, false)
    })))
  }))
  description = "Ordinary non-sensitive Free-tier property definitions keyed by immutable name."
  nullable    = false

  validation {
    condition     = alltrue([for name in keys(var.properties) : can(regex("^[a-z][a-z0-9_]*$", name))])
    error_message = "Property keys must be stable lowercase HubSpot identifiers."
  }

  validation {
    condition     = alltrue([for property in values(var.properties) : contains(["bool", "enumeration", "date", "datetime", "string", "number"], property.type)])
    error_message = "Every property must use a Free-alpha scalar or enumeration type."
  }

  validation {
    condition = alltrue([
      for property in values(var.properties) :
      trimspace(property.label) != "" && trimspace(property.field_type) != ""
    ])
    error_message = "Every property must have a non-empty label and field_type."
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
      property.type == "enumeration" ? property.options != null && length(property.options) > 0 : property.options == null
    ])
    error_message = "Enumeration properties require options; scalar properties must omit them."
  }

  validation {
    condition = alltrue(flatten([
      for property in values(var.properties) : property.options == null ? [] : [
        for name in keys(property.options) : can(regex("^[a-z][a-z0-9_]*$", name))
      ]
    ]))
    error_message = "Enumeration option keys must be stable lowercase HubSpot identifiers."
  }


  validation {
    condition = alltrue(flatten([
      for property in values(var.properties) : property.options == null ? [] : [
        for option in values(property.options) :
        trimspace(option.label) != "" && option.display_order >= -1 && option.display_order == floor(option.display_order)
      ]
    ]))
    error_message = "Every option must have a non-empty label and an integer display_order greater than or equal to -1."
  }
}
