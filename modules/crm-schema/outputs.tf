output "groups" {
  description = "Canonical property-group identities keyed by immutable name."
  value = {
    for name, group in hubspot_property_group.this : name => {
      id   = group.id
      name = group.name
    }
  }
}

output "properties" {
  description = "Canonical property identities keyed by immutable name."
  value = {
    for name, property in hubspot_property.this : name => {
      id    = property.id
      name  = property.name
      group = var.properties[name].group
      kind  = var.properties[name].kind
    }
  }
}
