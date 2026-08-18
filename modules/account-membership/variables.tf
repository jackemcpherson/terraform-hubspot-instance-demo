variable "memberships" {
  type = map(object({
    email              = string
    first_name         = optional(string)
    last_name          = optional(string)
    send_welcome_email = bool
    allow_removal      = optional(bool, false)
  }))
  description = "HubSpot account memberships keyed by stable local identity."
  nullable    = false

  validation {
    condition     = alltrue([for key in keys(var.memberships) : can(regex("^[a-z][a-z0-9_]*$", key))])
    error_message = "Membership keys must be stable lowercase local identifiers."
  }

  validation {
    condition = alltrue([
      for membership in values(var.memberships) :
      membership.email == lower(trimspace(membership.email)) &&
      can(regex("^[^[:space:]@]+@[^[:space:]@]+$", membership.email))
    ])
    error_message = "Every membership email must be a lowercase address without surrounding whitespace."
  }

  validation {
    condition     = length(distinct([for membership in values(var.memberships) : membership.email])) == length(var.memberships)
    error_message = "Membership emails must be unique within one module instance."
  }

  validation {
    condition = alltrue(flatten([
      for membership in values(var.memberships) : [
        membership.first_name == null || trimspace(membership.first_name) != "",
        membership.last_name == null || trimspace(membership.last_name) != "",
      ]
    ]))
    error_message = "Configured membership names must contain a non-whitespace character."
  }
}
