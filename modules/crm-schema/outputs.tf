output "group" {
  description = "Canonical property-group identity."
  value = {
    id   = hubspot_property_group.this.id
    name = hubspot_property_group.this.name
  }
}

output "properties" {
  description = "Canonical property identities keyed by immutable name."
  value = {
    for name, property in hubspot_property.this : name => property.id
  }
}
