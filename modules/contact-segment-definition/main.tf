# Manages Contact segment definitions through stable local keys. Memberships,
# derived size, and Contact record values stay outside this module.
resource "hubspot_contact_segment" "this" {
  for_each = var.definitions

  name            = each.value.name
  processing_type = each.value.processing_type
  # Manual definitions must omit filters entirely rather than send an empty set.
  filter_groups = length(each.value.filter_groups) == 0 ? null : each.value.filter_groups
}
