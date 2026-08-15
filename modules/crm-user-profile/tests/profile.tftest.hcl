mock_provider "hubspot" {
  mock_resource "hubspot_crm_user_profile" {
    defaults = {
      id = "987654321"
    }
  }
}

run "applies_stable_keyed_profile" {
  command = apply

  variables {
    profiles = {
      release_operator = {
        account_membership_id = "123456789"
        job_title             = "Release Engineer"
        availability_status   = "available"
        time_zone             = "Australia/Melbourne"
        working_hours = [
          {
            days         = "MONDAY_TO_FRIDAY"
            start_minute = 540
            end_minute   = 1020
          }
        ]
      }
    }
  }

  assert {
    condition     = output.ids == { release_operator = "987654321" }
    error_message = "The module must expose canonical CRM user IDs through stable keys."
  }

  assert {
    condition = (
      hubspot_crm_user_profile.this["release_operator"].account_membership_id == "123456789" &&
      hubspot_crm_user_profile.this["release_operator"].time_zone == "Australia/Melbourne"
    )
    error_message = "The module must join the exact Settings identity and pass managed profile properties."
  }
}

run "rejects_profile_without_managed_properties" {
  command = plan

  variables {
    profiles = {
      invalid = {
        account_membership_id = "123456789"
      }
    }
  }

  expect_failures = [var.profiles]
}
