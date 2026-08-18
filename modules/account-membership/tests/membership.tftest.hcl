mock_provider "hubspot" {
  mock_resource "hubspot_account_membership" {
    defaults = {
      id          = "123456789"
      super_admin = false
    }
  }
}

run "applies_stable_keyed_membership" {
  command = apply

  variables {
    memberships = {
      release_operator = {
        email              = "release-operator@example.com"
        first_name         = "Northstar"
        last_name          = "Operator"
        send_welcome_email = false
        allow_removal      = true
      }
    }
  }

  assert {
    condition     = output.ids == { release_operator = "123456789" }
    error_message = "The module must expose canonical Settings user IDs through stable keys."
  }

  assert {
    condition     = output.super_admin == { release_operator = false }
    error_message = "The module must expose observed Super Admin status through stable keys."
  }

  assert {
    condition = (
      hubspot_account_membership.this["release_operator"].send_welcome_email == false &&
      hubspot_account_membership.this["release_operator"].allow_removal == true
    )
    error_message = "The module must pass explicit welcome and removal choices to the resource."
  }
}

run "rejects_blank_configured_name" {
  command = plan

  variables {
    memberships = {
      invalid = {
        email              = "invalid@example.com"
        first_name         = "   "
        send_welcome_email = false
      }
    }
  }

  expect_failures = [var.memberships]
}
