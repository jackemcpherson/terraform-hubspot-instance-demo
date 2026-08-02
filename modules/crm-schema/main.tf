# Manages one CRM object's ordinary non-sensitive property schema.
resource "hubspot_property_group" "this" {
  for_each = var.groups

  object_type   = var.object_type
  name          = each.key
  label         = each.value.label
  display_order = each.value.display_order
}

resource "hubspot_property" "this" {
  for_each = var.properties

  object_type      = var.object_type
  name             = each.key
  label            = each.value.label
  group_name       = hubspot_property_group.this[each.value.group].name
  type             = each.value.kind == "select" ? "enumeration" : "string"
  field_type       = each.value.kind == "select" ? "select" : "text"
  description      = each.value.description
  display_order    = each.value.display_order
  form_field       = each.value.form_field
  hidden           = each.value.hidden
  data_sensitivity = "non_sensitive"
  options          = each.value.options

  lifecycle {
    precondition {
      condition     = contains(keys(var.groups), each.value.group)
      error_message = "Every property group must reference a key in groups."
    }
  }
}
