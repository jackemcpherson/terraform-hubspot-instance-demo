variable "definitions" {
  type = map(object({
    name            = string
    processing_type = string
    filter_groups = optional(list(object({
      filters = list(object({
        property      = string
        operator      = string
        property_kind = optional(string)
        value         = optional(string)
      }))
    })), [])
  }))
  description = "Contact segment definitions keyed by stable local identity. Each filter group is an OR branch of AND predicates on existing Contact property names."
  nullable    = false

  validation {
    condition     = alltrue([for key in keys(var.definitions) : can(regex("^[a-z][a-z0-9_]*$", key))])
    error_message = "Contact segment keys must be stable lowercase local identifiers."
  }

  validation {
    condition = alltrue([
      for definition in values(var.definitions) : definition.name != "" && trimspace(definition.name) == definition.name
    ])
    error_message = "Contact segment names must be nonblank without surrounding whitespace."
  }

  validation {
    condition     = length(distinct([for definition in values(var.definitions) : definition.name])) == length(var.definitions)
    error_message = "Contact segment names must be unique within one module instance."
  }

  validation {
    condition     = alltrue([for definition in values(var.definitions) : contains(["manual", "dynamic", "snapshot"], definition.processing_type)])
    error_message = "Each processing type must be manual, dynamic, or snapshot."
  }

  validation {
    condition = alltrue([
      for definition in values(var.definitions) : (
        definition.processing_type == "manual" ? length(definition.filter_groups) == 0 : length(definition.filter_groups) > 0
      )
    ])
    error_message = "Manual definitions take no filter groups; dynamic and snapshot definitions need at least one."
  }

  validation {
    condition     = alltrue(flatten([for definition in values(var.definitions) : [for group in definition.filter_groups : length(group.filters) > 0]]))
    error_message = "Every filter group must contain at least one AND predicate."
  }

  validation {
    condition = alltrue(flatten([
      for definition in values(var.definitions) : [
        for group in definition.filter_groups : [
          for filter in group.filters : (
            filter.property != "" && trimspace(filter.property) == filter.property && (
              contains(["is_equal_to", "is_not_equal_to"], filter.operator) ? (
                contains(["text", "select"], coalesce(filter.property_kind, "unset")) &&
                filter.value != null && try(trimspace(filter.value) != "", false)
                ) : (
                contains(["is_known", "is_not_known"], filter.operator) &&
                filter.property_kind == null && filter.value == null
              )
            )
          )
        ]
      ]
    ]))
    error_message = "Equality predicates need a text or select property_kind and one nonblank value; is_known and is_not_known take neither."
  }
}
