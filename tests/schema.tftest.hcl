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

run "plans_exact_free_tier_property_budget" {
  command = plan

  assert {
    condition = sum([
      for schema in values(local.schemas) : length(schema.properties)
    ]) == 10
    error_message = "The demo must stay within HubSpot Free's ten-property budget."
  }

  assert {
    condition     = length(module.crm_schema["contacts"].properties) == 4
    error_message = "The contact schema must contain four managed properties."
  }

  assert {
    condition     = length(module.crm_schema["companies"].properties) == 3
    error_message = "The company schema must contain three managed properties."
  }

  assert {
    condition     = length(module.crm_schema["deals"].properties) == 3
    error_message = "The deal schema must contain three managed properties."
  }
}
