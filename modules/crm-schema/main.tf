# Manages one HubSpot CRM property's group and its ordinary custom properties.
resource "hubspot_property_group" "this" {
  object_type   = var.object_type
  name          = var.group.name
  label         = var.group.label
  display_order = var.group.display_order
}

resource "hubspot_property" "this" {
  for_each = var.properties

  object_type      = var.object_type
  name             = each.key
  label            = each.value.label
  group_name       = hubspot_property_group.this.name
  type             = each.value.type
  field_type       = each.value.field_type
  description      = each.value.description
  display_order    = each.value.display_order
  form_field       = each.value.form_field
  hidden           = each.value.hidden
  data_sensitivity = "non_sensitive"
  options          = each.value.options
}
