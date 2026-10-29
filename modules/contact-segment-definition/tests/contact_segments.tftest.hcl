mock_provider "hubspot" {
  mock_resource "hubspot_contact_segment" {
    defaults = {
      id = "80001"
    }
  }
}

variables {
  definitions = {
    all_contacts = {
      name            = "All contacts"
      processing_type = "manual"
    }
    completed_onboarding = {
      name            = "Completed onboarding"
      processing_type = "dynamic"
      filter_groups = [
        {
          filters = [
            {
              property      = "ns_onboarding_status"
              operator      = "is_equal_to"
              property_kind = "select"
              value         = "complete"
            },
            {
              property = "email"
              operator = "is_known"
            },
          ]
        },
        {
          filters = [
            {
              property      = "ns_buyer_role"
              operator      = "is_equal_to"
              property_kind = "select"
              value         = "champion"
            },
          ]
        },
      ]
    }
    contactable_snapshot = {
      name            = "Contactable snapshot"
      processing_type = "snapshot"
      filter_groups = [
        {
          filters = [
            {
              property      = "email"
              operator      = "is_not_equal_to"
              property_kind = "text"
              value         = "suppressed@example.com"
            },
          ]
        },
      ]
    }
  }
}

run "applies_stable_keyed_definitions" {
  command = apply

  assert {
    condition = output.ids == {
      all_contacts         = "80001"
      completed_onboarding = "80001"
      contactable_snapshot = "80001"
    }
    error_message = "The module must expose generated Contact segment IDs through stable keys."
  }

  assert {
    condition = (
      hubspot_contact_segment.this["all_contacts"].processing_type == "manual" &&
      hubspot_contact_segment.this["all_contacts"].filter_groups == null
    )
    error_message = "A manual definition must omit filter groups."
  }

  assert {
    condition = (
      hubspot_contact_segment.this["completed_onboarding"].processing_type == "dynamic" &&
      length(hubspot_contact_segment.this["completed_onboarding"].filter_groups) == 2 &&
      hubspot_contact_segment.this["contactable_snapshot"].name == "Contactable snapshot"
    )
    error_message = "Dynamic and snapshot definitions must pass their OR groups and names to the resource."
  }
}

run "rejects_unstable_keys" {
  command = plan

  variables {
    definitions = {
      "All Contacts" = {
        name            = "All contacts"
        processing_type = "manual"
      }
    }
  }

  expect_failures = [var.definitions]
}

run "rejects_duplicate_names" {
  command = plan

  variables {
    definitions = {
      first = {
        name            = "Duplicate"
        processing_type = "manual"
      }
      second = {
        name            = "Duplicate"
        processing_type = "manual"
      }
    }
  }

  expect_failures = [var.definitions]
}

run "rejects_unknown_processing_type" {
  command = plan

  variables {
    definitions = {
      static = {
        name            = "Static"
        processing_type = "static"
      }
    }
  }

  expect_failures = [var.definitions]
}

run "rejects_filters_on_manual_definitions" {
  command = plan

  variables {
    definitions = {
      all_contacts = {
        name            = "All contacts"
        processing_type = "manual"
        filter_groups = [
          {
            filters = [
              {
                property = "email"
                operator = "is_known"
              },
            ]
          },
        ]
      }
    }
  }

  expect_failures = [var.definitions]
}

run "rejects_filterless_dynamic_definitions" {
  command = plan

  variables {
    definitions = {
      completed_onboarding = {
        name            = "Completed onboarding"
        processing_type = "dynamic"
      }
    }
  }

  expect_failures = [var.definitions]
}

run "rejects_empty_and_groups" {
  command = plan

  variables {
    definitions = {
      completed_onboarding = {
        name            = "Completed onboarding"
        processing_type = "dynamic"
        filter_groups   = [{ filters = [] }]
      }
    }
  }

  expect_failures = [var.definitions]
}

run "rejects_equality_without_kind_and_value" {
  command = plan

  variables {
    definitions = {
      completed_onboarding = {
        name            = "Completed onboarding"
        processing_type = "dynamic"
        filter_groups = [
          {
            filters = [
              {
                property = "ns_onboarding_status"
                operator = "is_equal_to"
              },
            ]
          },
        ]
      }
    }
  }

  expect_failures = [var.definitions]
}

run "rejects_presence_with_value" {
  command = plan

  variables {
    definitions = {
      completed_onboarding = {
        name            = "Completed onboarding"
        processing_type = "dynamic"
        filter_groups = [
          {
            filters = [
              {
                property      = "email"
                operator      = "is_known"
                property_kind = "text"
                value         = "present"
              },
            ]
          },
        ]
      }
    }
  }

  expect_failures = [var.definitions]
}

run "rejects_unsupported_property_kind" {
  command = plan

  variables {
    definitions = {
      completed_onboarding = {
        name            = "Completed onboarding"
        processing_type = "dynamic"
        filter_groups = [
          {
            filters = [
              {
                property      = "ns_last_success_review"
                operator      = "is_equal_to"
                property_kind = "date"
                value         = "2026-01-01"
              },
            ]
          },
        ]
      }
    }
  }

  expect_failures = [var.definitions]
}
