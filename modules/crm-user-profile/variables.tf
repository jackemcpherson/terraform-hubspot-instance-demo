variable "profiles" {
  type = map(object({
    account_membership_id = string
    job_title             = optional(string)
    availability_status   = optional(string)
    time_zone             = optional(string)
    working_hours = optional(set(object({
      days         = string
      start_minute = number
      end_minute   = number
    })))
  }))
  description = "CRM user profiles keyed by stable local identity."
  nullable    = false

  validation {
    condition     = alltrue([for key in keys(var.profiles) : can(regex("^[a-z][a-z0-9_]*$", key))])
    error_message = "Profile keys must be stable lowercase local identifiers."
  }

  validation {
    condition = alltrue([
      for profile in values(var.profiles) :
      can(regex("^[1-9][0-9]*$", profile.account_membership_id))
    ])
    error_message = "Every account_membership_id must be one canonical numeric Settings user ID."
  }

  validation {
    condition = alltrue([
      for profile in values(var.profiles) :
      profile.job_title != null ||
      profile.availability_status != null ||
      profile.time_zone != null ||
      profile.working_hours != null
    ])
    error_message = "Every profile must manage at least one supported property."
  }

  validation {
    condition = alltrue([
      for profile in values(var.profiles) :
      profile.availability_status == null || contains(["available", "away"], profile.availability_status)
    ])
    error_message = "availability_status must be available, away, or null."
  }

  validation {
    condition = alltrue([
      for profile in values(var.profiles) :
      profile.time_zone == null || (trimspace(profile.time_zone) != "" && trimspace(profile.time_zone) == profile.time_zone)
    ])
    error_message = "Configured time_zone values must be nonblank and have no surrounding whitespace."
  }

  validation {
    condition = alltrue([
      for profile in values(var.profiles) :
      profile.working_hours == null || profile.time_zone != null
    ])
    error_message = "working_hours requires a managed time_zone."
  }

  validation {
    condition = alltrue(flatten([
      for profile in values(var.profiles) : [
        for interval in coalesce(profile.working_hours, []) :
        contains([
          "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY",
          "MONDAY_TO_FRIDAY", "SATURDAY_SUNDAY", "EVERY_DAY"
        ], interval.days) &&
        interval.start_minute >= 0 && interval.start_minute <= 1440 &&
        interval.end_minute >= 0 && interval.end_minute <= 1440 &&
        interval.end_minute > interval.start_minute
      ]
    ]))
    error_message = "Working-hours intervals must use documented days, minute values from 0 through 1440, and an end later than the start."
  }
}
