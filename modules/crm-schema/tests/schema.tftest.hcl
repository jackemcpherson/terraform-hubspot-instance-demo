mock_provider "hubspot" {}

variables {
  object_type = "contacts"
  groups = {
    ns_test_context = {
      label         = "Test context"
      display_order = 100
    }
  }
  properties = {
    ns_summary = {
      label = "Summary"
      group = "ns_test_context"
    }
    ns_status = {
      label         = "Status"
      group         = "ns_test_context"
      kind          = "select"
      display_order = 110
      options = {
        active = { label = "Active" }
        paused = { label = "Paused", display_order = 20, hidden = true }
      }
    }
  }
}

run "plans_keyed_groups_and_derived_property_kinds" {
  command = plan

  assert {
    condition     = length(hubspot_property_group.this) == 1 && length(hubspot_property.this) == 2
    error_message = "Map keys must drive stable group and property addresses."
  }

  assert {
    condition     = hubspot_property.this["ns_summary"].type == "string" && hubspot_property.this["ns_summary"].field_type == "text"
    error_message = "Default text kind must derive string/text."
  }

  assert {
    condition     = hubspot_property.this["ns_status"].type == "enumeration" && hubspot_property.this["ns_status"].field_type == "select"
    error_message = "Select kind must derive enumeration/select."
  }

  assert {
    condition     = output.properties["ns_status"].group == "ns_test_context" && output.properties["ns_status"].kind == "select"
    error_message = "Outputs must retain stable group and kind identities."
  }
}

run "rejects_unsupported_object_types" {
  command = plan
  variables { object_type = "calls" }
  expect_failures = [var.object_type]
}

run "rejects_invalid_group_keys" {
  command = plan
  variables {
    groups     = { "Northstar Context" = { label = "Context" } }
    properties = {}
  }
  expect_failures = [var.groups]
}

run "rejects_blank_group_labels" {
  command = plan
  variables {
    groups     = { ns_test_context = { label = "  " } }
    properties = {}
  }
  expect_failures = [var.groups]
}

run "rejects_invalid_group_orders" {
  command = plan
  variables {
    groups     = { ns_test_context = { label = "Context", display_order = -2 } }
    properties = {}
  }
  expect_failures = [var.groups]
}

run "rejects_fractional_group_orders" {
  command = plan
  variables {
    groups     = { ns_test_context = { label = "Context", display_order = 1.5 } }
    properties = {}
  }
  expect_failures = [var.groups]
}

run "rejects_invalid_property_keys" {
  command = plan
  variables {
    properties = { "Northstar status" = { label = "Status", group = "ns_test_context" } }
  }
  expect_failures = [var.properties]
}

run "rejects_blank_property_labels" {
  command = plan
  variables {
    properties = { ns_status = { label = " ", group = "ns_test_context" } }
  }
  expect_failures = [var.properties]
}

run "rejects_missing_group_references" {
  command = plan
  variables {
    properties = { ns_status = { label = "Status", group = "missing" } }
  }
  expect_failures = [hubspot_property.this["ns_status"]]
}

run "rejects_unsupported_kinds" {
  command = plan
  variables {
    properties = { ns_status = { label = "Status", group = "ns_test_context", kind = "radio" } }
  }
  expect_failures = [var.properties]
}

run "rejects_options_on_text_properties" {
  command = plan
  variables {
    properties = {
      ns_status = {
        label   = "Status"
        group   = "ns_test_context"
        options = { active = { label = "Active" } }
      }
    }
  }
  expect_failures = [var.properties]
}

run "rejects_empty_options_on_select_properties" {
  command = plan
  variables {
    properties = { ns_status = { label = "Status", group = "ns_test_context", kind = "select" } }
  }
  expect_failures = [var.properties]
}

run "rejects_invalid_property_orders" {
  command = plan
  variables {
    properties = { ns_status = { label = "Status", group = "ns_test_context", display_order = -2 } }
  }
  expect_failures = [var.properties]
}

run "rejects_fractional_property_orders" {
  command = plan
  variables {
    properties = { ns_status = { label = "Status", group = "ns_test_context", display_order = 1.5 } }
  }
  expect_failures = [var.properties]
}

run "rejects_invalid_option_keys" {
  command = plan
  variables {
    properties = {
      ns_status = {
        label   = "Status"
        group   = "ns_test_context"
        kind    = "select"
        options = { "Active customer" = { label = "Active" } }
      }
    }
  }
  expect_failures = [var.properties]
}

run "rejects_blank_option_labels" {
  command = plan
  variables {
    properties = {
      ns_status = {
        label   = "Status"
        group   = "ns_test_context"
        kind    = "select"
        options = { active = { label = " " } }
      }
    }
  }
  expect_failures = [var.properties]
}

run "rejects_invalid_option_orders" {
  command = plan
  variables {
    properties = {
      ns_status = {
        label   = "Status"
        group   = "ns_test_context"
        kind    = "select"
        options = { active = { label = "Active", display_order = -2 } }
      }
    }
  }
  expect_failures = [var.properties]
}

run "rejects_fractional_option_orders" {
  command = plan
  variables {
    properties = {
      ns_status = {
        label   = "Status"
        group   = "ns_test_context"
        kind    = "select"
        options = { active = { label = "Active", display_order = 1.5 } }
      }
    }
  }
  expect_failures = [var.properties]
}
