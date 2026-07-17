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
    condition     = toset(keys(local.schemas)) == toset(["contacts", "companies", "deals", "tickets"])
    error_message = "The demo must cover every standard CRM object type exposed by v0.1."
  }

  assert {
    condition     = length(module.crm_schema["contacts"].properties) == 3
    error_message = "The contact schema must contain three managed properties."
  }

  assert {
    condition     = length(module.crm_schema["companies"].properties) == 2
    error_message = "The company schema must contain two managed properties."
  }

  assert {
    condition     = length(module.crm_schema["deals"].properties) == 2
    error_message = "The deal schema must contain two managed properties."
  }

  assert {
    condition     = length(module.crm_schema["tickets"].properties) == 3
    error_message = "The ticket schema must contain three managed properties."
  }
}
