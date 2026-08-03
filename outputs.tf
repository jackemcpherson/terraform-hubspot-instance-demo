output "managed_schema" {
  description = "Managed HubSpot CRM groups and property names by object type."
  value = {
    for object_type, schema in local.schemas : object_type => {
      groups     = module.crm_schema[object_type].groups
      properties = module.crm_schema[object_type].properties
    }
  }
}

output "observed_managed_properties" {
  description = "Managed property names read back through the collection data source."
  value = {
    for object_type, schema in local.schemas : object_type => sort([
      for property_name in keys(data.hubspot_property_definitions.observed[object_type].definitions) : property_name
      if contains(keys(schema.properties), property_name)
    ])
  }
}

output "builtin_email_property" {
  description = "A built-in contact property read through the singular data source."
  value = {
    name       = data.hubspot_property_definition.builtin_email.name
    label      = data.hubspot_property_definition.builtin_email.label
    field_type = data.hubspot_property_definition.builtin_email.field_type
  }
}

output "northstar_form_ids" {
  description = "Generated HubSpot form IDs keyed by stable local form identity."
  value       = module.forms.ids
}

output "northstar_contact_form_id" {
  description = "Generated identity of the stable-keyed Northstar contact form."
  value       = module.forms.ids["contact_us"]
}
