mock_provider "hubspot" {
  mock_data "hubspot_property_definition" {
    defaults = {
      id         = "contacts/email"
      label      = "Email"
      field_type = "text"
    }
  }

  mock_data "hubspot_property_definitions" {
    defaults = {
      definitions = {}
    }
  }
}

run "plans_cumulative_crm_property_schema" {
  command = plan

  assert {
    condition     = toset(keys(local.schemas)) == toset(["contacts", "companies", "deals", "tickets"])
    error_message = "The demo must cover all four supported CRM object types."
  }

  assert {
    condition     = alltrue([for schema in values(local.schemas) : length(schema.groups) > 0 && length(schema.properties) > 0])
    error_message = "Every object type must own meaningful groups and properties."
  }

  assert {
    condition     = alltrue([for schema in values(local.schemas) : alltrue([for property in values(schema.properties) : contains(["text", "select"], try(property.kind, "text"))])])
    error_message = "The cumulative demo must use only text and select property kinds."
  }

  assert {
    condition     = length(module.crm_schema["contacts"].properties) == 3 && length(module.crm_schema["tickets"].groups) == 1
    error_message = "Module outputs must expose stable property and group identities."
  }
}
