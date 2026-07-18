mock_provider "hubspot" {}

variables {
  object_type = "contacts"
  group = {
    name          = "ns_test_context"
    label         = "Test context"
    display_order = 100
  }
  properties = {
    ns_status = {
      label         = "Status"
      type          = "enumeration"
      field_type    = "select"
      display_order = 110
      options = {
        active = { label = "Active" }
      }
    }
  }
}

run "plans_a_keyed_property_schema" {
  command = plan

  assert {
    condition     = length(hubspot_property.this) == 1
    error_message = "The module must plan one property for each stable map key."
  }
}

run "rejects_unsupported_object_types" {
  command = plan

  variables {
    object_type = "calls"
  }

  expect_failures = [var.object_type]
}

run "rejects_unstable_group_names" {
  command = plan

  variables {
    group = {
      name          = "Northstar Context"
      label         = "Test context"
      display_order = 100
    }
  }

  expect_failures = [var.group]
}

run "rejects_empty_group_labels" {
  command = plan

  variables {
    group = {
      name          = "ns_test_context"
      label         = "  "
      display_order = 100
    }
  }

  expect_failures = [var.group]
}

run "rejects_fractional_group_order" {
  command = plan

  variables {
    group = {
      name          = "ns_test_context"
      label         = "Test context"
      display_order = 1.5
    }
  }

  expect_failures = [var.group]
}

run "rejects_unstable_property_keys" {
  command = plan

  variables {
    properties = {
      "Northstar status" = {
        label         = "Status"
        type          = "string"
        field_type    = "text"
        display_order = 110
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_unsupported_property_types" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = "Status"
        type          = "object"
        field_type    = "text"
        display_order = 110
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_empty_property_labels" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = ""
        type          = "string"
        field_type    = "text"
        display_order = 110
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_empty_property_field_types" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = "Status"
        type          = "string"
        field_type    = " "
        display_order = 110
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_fractional_property_order" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = "Status"
        type          = "string"
        field_type    = "text"
        display_order = 1.5
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_enumerations_without_options" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = "Status"
        type          = "enumeration"
        field_type    = "select"
        display_order = 110
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_options_on_scalar_properties" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = "Status"
        type          = "string"
        field_type    = "text"
        display_order = 110
        options = {
          active = { label = "Active" }
        }
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_unstable_option_keys" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = "Status"
        type          = "enumeration"
        field_type    = "select"
        display_order = 110
        options = {
          "Active customer" = { label = "Active" }
        }
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_empty_option_labels" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = "Status"
        type          = "enumeration"
        field_type    = "select"
        display_order = 110
        options = {
          active = { label = "" }
        }
      }
    }
  }

  expect_failures = [var.properties]
}

run "rejects_fractional_option_order" {
  command = plan

  variables {
    properties = {
      ns_status = {
        label         = "Status"
        type          = "enumeration"
        field_type    = "select"
        display_order = 110
        options = {
          active = { label = "Active", display_order = 1.5 }
        }
      }
    }
  }

  expect_failures = [var.properties]
}
